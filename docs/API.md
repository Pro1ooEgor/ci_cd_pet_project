# API Documentation

Полная документация API для FastAPI Pet Project.

## Base URL

```
Development: http://localhost:8000
Production: https://api.yourdomain.com
```

## Authentication

В текущей версии аутентификация не требуется. В будущем будет добавлена JWT аутентификация.

## Endpoints

### Health & Status

#### GET /

Корневой эндпоинт с информацией о приложении.

**Response:**
```json
{
  "message": "Welcome to Pet Project API",
  "status": "healthy",
  "version": "1.0.0"
}
```

#### GET /health

Health check эндпоинт для мониторинга.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-11T12:00:00.000000"
}
```

### Tasks Management

#### GET /tasks

Получить список всех задач с пагинацией.

**Query Parameters:**
- `skip` (integer, optional): Количество задач для пропуска. Default: 0
- `limit` (integer, optional): Максимальное количество задач. Default: 100

**Example Request:**
```bash
curl "http://localhost:8000/tasks?skip=0&limit=10"
```

**Response:**
```json
[
  {
    "id": "uuid-string",
    "title": "Task 1",
    "description": "Description of task 1",
    "completed": false,
    "created_at": "2025-10-11T12:00:00.000000",
    "updated_at": "2025-10-11T12:00:00.000000"
  }
]
```

#### POST /tasks

Создать новую задачу.

**Request Body:**
```json
{
  "title": "New Task",
  "description": "Task description",
  "completed": false
}
```

**Example Request:**
```bash
curl -X POST "http://localhost:8000/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "My Task", "description": "Do something"}'
```

**Response (201 Created):**
```json
{
  "id": "generated-uuid",
  "title": "New Task",
  "description": "Task description",
  "completed": false,
  "created_at": "2025-10-11T12:00:00.000000",
  "updated_at": "2025-10-11T12:00:00.000000"
}
```

#### GET /tasks/{task_id}

Получить конкретную задачу по ID.

**Path Parameters:**
- `task_id` (string, required): UUID задачи

**Example Request:**
```bash
curl "http://localhost:8000/tasks/uuid-string"
```

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "title": "Task Title",
  "description": "Task description",
  "completed": false,
  "created_at": "2025-10-11T12:00:00.000000",
  "updated_at": "2025-10-11T12:00:00.000000"
}
```

**Error Response (404 Not Found):**
```json
{
  "detail": "Task not found"
}
```

#### PUT /tasks/{task_id}

Обновить существующую задачу.

**Path Parameters:**
- `task_id` (string, required): UUID задачи

**Request Body (partial update):**
```json
{
  "title": "Updated Title",
  "completed": true
}
```

**Example Request:**
```bash
curl -X PUT "http://localhost:8000/tasks/uuid-string" \
  -H "Content-Type: application/json" \
  -d '{"completed": true}'
```

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "title": "Updated Title",
  "description": "Original description",
  "completed": true,
  "created_at": "2025-10-11T12:00:00.000000",
  "updated_at": "2025-10-11T12:30:00.000000"
}
```

#### DELETE /tasks/{task_id}

Удалить задачу.

**Path Parameters:**
- `task_id` (string, required): UUID задачи

**Example Request:**
```bash
curl -X DELETE "http://localhost:8000/tasks/uuid-string"
```

**Response (200 OK):**
```json
{
  "message": "Task deleted successfully"
}
```

**Error Response (404 Not Found):**
```json
{
  "detail": "Task not found"
}
```

### Statistics

#### GET /stats

Получить статистику по задачам.

**Example Request:**
```bash
curl "http://localhost:8000/stats"
```

**Response:**
```json
{
  "total_tasks": 10,
  "completed_tasks": 7,
  "pending_tasks": 3
}
```

## Data Models

### Task

```python
{
  "id": "string (UUID)",
  "title": "string (required)",
  "description": "string (optional)",
  "completed": "boolean (default: false)",
  "created_at": "datetime (ISO 8601)",
  "updated_at": "datetime (ISO 8601)"
}
```

### TaskCreate

```python
{
  "title": "string (required)",
  "description": "string (optional)",
  "completed": "boolean (default: false)"
}
```

### TaskUpdate

```python
{
  "title": "string (optional)",
  "description": "string (optional)",
  "completed": "boolean (optional)"
}
```

## Error Responses

### 404 Not Found
```json
{
  "detail": "Task not found"
}
```

### 422 Validation Error
```json
{
  "detail": [
    {
      "loc": ["body", "title"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

### 500 Internal Server Error
```json
{
  "detail": "Internal server error"
}
```

## Rate Limiting

В текущей версии ограничений нет. В будущем будет добавлен rate limiting.

## Interactive Documentation

Swagger UI доступен по адресу: `/docs`
ReDoc доступен по адресу: `/redoc`

## WebSocket Support

В текущей версии не реализовано. Планируется в будущих версиях для real-time обновлений.

## Versioning

API версионируется через тег релизов в Git. В будущем может быть добавлено версионирование URL (например, `/api/v1/tasks`).

