import json, logging, os, time, uuid
import psycopg, redis
from fastapi import FastAPI, HTTPException, Request, Response
from pydantic import BaseModel
from prometheus_client import Counter, Gauge, Histogram, generate_latest, CONTENT_TYPE_LATEST

VERSION=os.getenv('APP_VERSION','1.9.0')
DB=os.getenv('DATABASE_URL','postgresql://settle:settle-local-only@postgres:5432/settle')
REDIS=os.getenv('REDIS_URL','redis://redis:6379/0')
logging.basicConfig(level=logging.INFO); log=logging.getLogger('settle-api')
REQ=Counter('settle_api_requests_total','API requests',['method','path','status'])
LAT=Histogram('settle_api_request_duration_seconds','API latency',['method','path'])
QUEUE=Gauge('settle_worker_queue_depth','Redis queue depth')

class Settlement(BaseModel):
    merchant_id:int
    amount_cents:int
    request_id:str|None=None

def db(): return psycopg.connect(DB, connect_timeout=3)
def rc(): return redis.Redis.from_url(REDIS, decode_responses=True)

app=FastAPI(title='settle-api',version=VERSION)
@app.middleware('http')
async def metrics(request:Request, call_next):
    start=time.monotonic(); rid=request.headers.get('X-Request-ID',str(uuid.uuid4()))
    response=await call_next(request); elapsed=time.monotonic()-start
    REQ.labels(request.method,request.url.path,response.status_code).inc(); LAT.labels(request.method,request.url.path).observe(elapsed)
    response.headers['X-Request-ID']=rid
    log.info(json.dumps({'event':'request','request_id':rid,'path':request.url.path,'status':response.status_code,'duration_seconds':round(elapsed,4),'version':VERSION}))
    return response

@app.get('/healthz')
def healthz():
    if os.getenv('FAULTY_RELEASE','false').lower()=='true': return Response('fault injected',status_code=500)
    return {'status':'ok','version':VERSION}

@app.get('/readyz')
def readyz(): return {'status':'ready','version':VERSION}

@app.get('/health/db')
def db_health():
    try:
        with db() as c: c.execute('SELECT 1')
        return {'status':'ok'}
    except Exception as e: raise HTTPException(503,'database unavailable') from e

@app.post('/settlements',status_code=202)
def settlement(item:Settlement, request:Request):
    rid=item.request_id or request.headers.get('X-Request-ID') or str(uuid.uuid4()); sid=str(uuid.uuid4())
    payload={'settlement_id':sid,'merchant_id':item.merchant_id,'amount_cents':item.amount_cents,'request_id':rid}
    try:
        with db() as c: c.execute("INSERT INTO settlements(settlement_id,merchant_id,amount_cents,request_id,status) VALUES(%s,%s,%s,%s,'queued')",(sid,item.merchant_id,item.amount_cents,rid))
        r=rc(); r.lpush('settlements',json.dumps(payload)); QUEUE.set(r.llen('settlements'))
    except Exception as e: raise HTTPException(503,'database/queue unavailable') from e
    return payload|{'status':'queued'}

@app.get('/reports/daily')
def report():
    time.sleep(7)
    try:
        with db() as c: row=c.execute('SELECT count(*),coalesce(sum(amount_cents),0) FROM settlements').fetchone()
        return {'status':'ok','settlements':row[0],'amount_cents':row[1]}
    except Exception as e: raise HTTPException(503,'database unavailable') from e

@app.get('/metrics')
def metrics_endpoint():
    try: QUEUE.set(rc().llen('settlements'))
    except Exception: pass
    return Response(generate_latest(),media_type=CONTENT_TYPE_LATEST)
