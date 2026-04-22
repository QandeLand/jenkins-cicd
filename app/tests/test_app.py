import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from app import app
import json

def test_health():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert b"ok" in response.data

def test_health_returns_json():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data["status"] == "ok"

def test_unknown_route_returns_404():
    client = app.test_client()
    response = client.get("/unknown")
    assert response.status_code == 404

def test_health_method_not_allowed():
    client = app.test_client()
    response = client.post("/health")
    assert response.status_code == 405