import pytest
from app import app

@pytest.fixture
def client():
    app.config.update({'TESTING' : True})
    with app.test_client() as client:
        yield client


def test_success_result(client):
    receiver = client.get('/')
    assert receiver.status_code == 200


def test_failed_result(client):
    receiver = client.get('/123456789')
    assert receiver.status_code == 404