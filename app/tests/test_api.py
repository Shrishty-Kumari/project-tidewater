from fastapi.testclient import TestClient
from api.main import app
client=TestClient(app)
def test_health():
 r=client.get('/healthz'); assert r.status_code==200; assert r.json()['status']=='ok'
def test_ready(): assert client.get('/readyz').status_code==200
