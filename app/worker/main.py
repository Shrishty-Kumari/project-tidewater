import json, logging, os, signal, time
import psycopg, redis
from prometheus_client import start_http_server, Counter, Gauge, Histogram
DB=os.getenv('DATABASE_URL','postgresql://settle:settle-local-only@postgres:5432/settle'); REDIS=os.getenv('REDIS_URL','redis://redis:6379/0'); running=True
logging.basicConfig(level=logging.INFO); log=logging.getLogger('settle-worker')
JOBS=Counter('settle_worker_jobs_total','worker jobs',['status']); DUR=Histogram('settle_worker_job_duration_seconds','job duration'); DEPTH=Gauge('settle_worker_queue_depth','queue depth')
def stop(sig,_):
 global running; running=False; log.info(json.dumps({'event':'shutdown_requested','signal':sig}))
signal.signal(signal.SIGTERM,stop); signal.signal(signal.SIGINT,stop)
def process(job):
 start=time.monotonic(); sid=job['settlement_id']
 try:
  with psycopg.connect(DB,connect_timeout=3) as c:
   row=c.execute('SELECT status FROM settlements WHERE settlement_id=%s FOR UPDATE',(sid,)).fetchone()
   if not row: raise RuntimeError('settlement not found')
   if row[0]=='paid': return
   key='settlement:'+sid
   c.execute("INSERT INTO bank_payments(idempotency_key,settlement_id,amount_cents) VALUES(%s,%s,%s) ON CONFLICT(idempotency_key) DO NOTHING",(key,sid,job['amount_cents']))
   time.sleep(.2)
   c.execute("UPDATE settlements SET status='paid',paid_at=now() WHERE settlement_id=%s",(sid,))
  JOBS.labels('success').inc()
 except Exception:
  JOBS.labels('failed').inc(); log.exception(json.dumps({'event':'job_failed','settlement_id':sid})); raise
 finally: DUR.observe(time.monotonic()-start)
def main():
 start_http_server(9100); r=redis.Redis.from_url(REDIS,decode_responses=True)
 while running:
  try:
   DEPTH.set(r.llen('settlements')); item=r.brpop('settlements',timeout=2)
   if not item: continue
   _,raw=item; job=json.loads(raw)
   try: process(job)
   except Exception:
    n=int(job.get('retries',0));
    if n<5: job['retries']=n+1; r.lpush('settlements',json.dumps(job))
  except Exception: log.exception(json.dumps({'event':'worker_loop_error'})); time.sleep(1)
if __name__=='__main__': main()
