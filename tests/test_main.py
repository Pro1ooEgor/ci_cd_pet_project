import pytest
from fastapi.testclient import TestClient
from app.main import app, tasks_db

client = TestClient(app)


@pytest.fixture(autouse=True)
def clear_db():
    """Clear the in-memory database before each test"""
    tasks_db.clear()
    yield
    tasks_db.clear()


def test_root():
    """Test the root endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "message" in data
    assert "version" in data


def test_health_check():
    """Test the health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "timestamp" in data


def test_create_task():
    """Test creating a new task"""
    task_data = {"title": "Test Task", "description": "This is a test task", "completed": False}
    response = client.post("/tasks", json=task_data)
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == task_data["title"]
    assert data["description"] == task_data["description"]
    assert data["completed"] == task_data["completed"]
    assert "id" in data
    assert "created_at" in data
    assert "updated_at" in data


def test_get_tasks():
    """Test getting all tasks"""
    # Create some tasks
    task1 = {"title": "Task 1", "description": "First task"}
    task2 = {"title": "Task 2", "description": "Second task"}

    client.post("/tasks", json=task1)
    client.post("/tasks", json=task2)

    # Get all tasks
    response = client.get("/tasks")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2


def test_get_task_by_id():
    """Test getting a specific task by ID"""
    # Create a task
    task_data = {"title": "Test Task", "description": "Test description"}
    create_response = client.post("/tasks", json=task_data)
    task_id = create_response.json()["id"]

    # Get the task
    response = client.get(f"/tasks/{task_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == task_id
    assert data["title"] == task_data["title"]


def test_get_nonexistent_task():
    """Test getting a task that doesn't exist"""
    response = client.get("/tasks/nonexistent-id")
    assert response.status_code == 404
    data = response.json()
    assert data["detail"] == "Task not found"


def test_update_task():
    """Test updating a task"""
    # Create a task
    task_data = {"title": "Original Title", "description": "Original description"}
    create_response = client.post("/tasks", json=task_data)
    task_id = create_response.json()["id"]

    # Update the task
    update_data = {"title": "Updated Title", "completed": True}
    response = client.put(f"/tasks/{task_id}", json=update_data)
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == update_data["title"]
    assert data["completed"] == update_data["completed"]
    assert data["description"] == task_data["description"]  # Should remain unchanged


def test_update_nonexistent_task():
    """Test updating a task that doesn't exist"""
    update_data = {"title": "Updated Title"}
    response = client.put("/tasks/nonexistent-id", json=update_data)
    assert response.status_code == 404


def test_delete_task():
    """Test deleting a task"""
    # Create a task
    task_data = {"title": "Task to Delete"}
    create_response = client.post("/tasks", json=task_data)
    task_id = create_response.json()["id"]

    # Delete the task
    response = client.delete(f"/tasks/{task_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "Task deleted successfully"

    # Verify it's deleted
    get_response = client.get(f"/tasks/{task_id}")
    assert get_response.status_code == 404


def test_delete_nonexistent_task():
    """Test deleting a task that doesn't exist"""
    response = client.delete("/tasks/nonexistent-id")
    assert response.status_code == 404


def test_get_stats():
    """Test getting task statistics"""
    # Initially should be empty
    response = client.get("/stats")
    assert response.status_code == 200
    data = response.json()
    assert data["total_tasks"] == 0
    assert data["completed_tasks"] == 0
    assert data["pending_tasks"] == 0

    # Create some tasks
    client.post("/tasks", json={"title": "Task 1", "completed": False})
    client.post("/tasks", json={"title": "Task 2", "completed": True})
    client.post("/tasks", json={"title": "Task 3", "completed": True})

    # Check stats
    response = client.get("/stats")
    data = response.json()
    assert data["total_tasks"] == 3
    assert data["completed_tasks"] == 2
    assert data["pending_tasks"] == 1


def test_pagination():
    """Test task pagination"""
    # Create 15 tasks
    for i in range(15):
        client.post("/tasks", json={"title": f"Task {i}"})

    # Get first 10
    response = client.get("/tasks?skip=0&limit=10")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 10

    # Get next 5
    response = client.get("/tasks?skip=10&limit=10")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 5
