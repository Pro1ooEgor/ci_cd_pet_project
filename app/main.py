from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import uuid
from datetime import datetime

app = FastAPI(
    title="Pet Project API",
    description="A simple FastAPI project for CI/CD and DevOps practice",
    version="1.0.0",
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# In-memory database (for simplicity)
tasks_db = {}


# Models
class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    completed: bool = False


class Task(TaskBase):
    id: str
    created_at: datetime
    updated_at: datetime


class TaskCreate(TaskBase):
    pass


class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    completed: Optional[bool] = None


# Health check endpoint
@app.get("/")
async def root():
    return {"message": "Welcome to Pet Project API", "status": "healthy", "version": "1.0.0"}


@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.utcnow().isoformat()}


# CRUD endpoints for tasks
@app.post("/tasks", response_model=Task, status_code=201)
async def create_task(task: TaskCreate):
    """Create a new task"""
    task_id = str(uuid.uuid4())
    now = datetime.utcnow()

    new_task = Task(
        id=task_id,
        title=task.title,
        description=task.description,
        completed=task.completed,
        created_at=now,
        updated_at=now,
    )

    tasks_db[task_id] = new_task
    return new_task


@app.get("/tasks", response_model=List[Task])
async def get_tasks(skip: int = 0, limit: int = 100):
    """Get all tasks with pagination"""
    all_tasks = list(tasks_db.values())
    return all_tasks[skip : skip + limit]


@app.get("/tasks/{task_id}", response_model=Task)
async def get_task(task_id: str):
    """Get a specific task by ID"""
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    return tasks_db[task_id]


@app.put("/tasks/{task_id}", response_model=Task)
async def update_task(task_id: str, task_update: TaskUpdate):
    """Update a task"""
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")

    stored_task = tasks_db[task_id]
    update_data = task_update.dict(exclude_unset=True)

    updated_task = stored_task.copy(update={**update_data, "updated_at": datetime.utcnow()})
    tasks_db[task_id] = updated_task

    return updated_task


@app.delete("/tasks/{task_id}")
async def delete_task(task_id: str):
    """Delete a task"""
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")

    del tasks_db[task_id]
    return {"message": "Task deleted successfully"}


# Statistics endpoint
@app.get("/stats")
async def get_stats():
    """Get statistics about tasks"""
    total_tasks = len(tasks_db)
    completed_tasks = sum(1 for task in tasks_db.values() if task.completed)
    pending_tasks = total_tasks - completed_tasks

    return {
        "total_tasks": total_tasks,
        "completed_tasks": completed_tasks,
        "pending_tasks": pending_tasks,
    }
