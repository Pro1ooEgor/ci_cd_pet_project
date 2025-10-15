# Архитектура проекта

Документация архитектуры FastAPI Pet Project.

## 🏗️ Общая структура

```
┌─────────────────┐
│   GitHub        │
│   Actions       │
│   (CI/CD)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Container     │
│   Registry      │
│   (GHCR)        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐       ┌─────────────┐
│   Deployment    │◄──────│   Health    │
│   Target        │       │   Checks    │
│ (K8s/Docker)    │       └─────────────┘
└─────────────────┘
         │
         ▼
┌─────────────────┐
│   FastAPI       │
│   Application   │
└─────────────────┘
```

## 📦 Компоненты системы

### 1. Application Layer (FastAPI)

**Файл:** `app/main.py`

- **FastAPI Application:** Основное приложение
- **CORS Middleware:** Для cross-origin запросов
- **Pydantic Models:** Валидация данных
- **In-Memory Storage:** Временное хранилище (для demo)

**Эндпоинты:**
```
GET  /              - Root endpoint
GET  /health        - Health check
GET  /tasks         - List tasks
POST /tasks         - Create task
GET  /tasks/{id}    - Get task
PUT  /tasks/{id}    - Update task
DELETE /tasks/{id}  - Delete task
GET  /stats         - Statistics
```

### 2. Testing Layer

**Директория:** `tests/`

- **pytest:** Test framework
- **TestClient:** FastAPI test client
- **Coverage:** Code coverage measurement

**Типы тестов:**
- Unit tests для эндпоинтов
- Integration tests для бизнес-логики
- Автоматический setup/teardown базы данных

### 3. Container Layer (Docker)

**Файлы:**
- `Dockerfile` - Образ приложения
- `docker-compose.yml` - Локальная разработка

**Особенности:**
- Multi-stage builds (можно расширить)
- Health checks
- Минимальный размер образа (Python slim)
- Non-root user (можно добавить)

### 4. CI/CD Layer (GitHub Actions)

**Workflows:**

#### CI Pipeline (`.github/workflows/ci.yml`)
```
┌─────────────┐
│ Push/PR     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Checkout    │
│ Code        │
└──────┬──────┘
       │
       ├─────────────────┬─────────────────┬──────────────────┐
       ▼                 ▼                 ▼                  ▼
┌────────────┐    ┌────────────┐   ┌────────────┐   ┌────────────┐
│ Python 3.10│    │ Python 3.11│   │ Python 3.12│   │  Security  │
│   Tests    │    │   Tests    │   │   Tests    │   │   Scan     │
└────────────┘    └────────────┘   └────────────┘   └────────────┘
       │                 │                 │                  │
       └─────────────────┴─────────────────┴──────────────────┘
                               │
                               ▼
                        ┌────────────┐
                        │  Docker    │
                        │  Build     │
                        └────────────┘
```

#### CD Pipeline (`.github/workflows/cd.yml`)
```
┌─────────────┐
│ Push to     │
│ main/tags   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Build       │
│ Docker      │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Push to     │
│ GHCR        │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Deploy      │
│ (optional)  │
└─────────────┘
```

### 5. Orchestration Layer (Kubernetes)

**Файлы:** `k8s/`

**Компоненты:**
- **Deployment:** Управление pod'ами
- **Service:** Load balancing
- **HPA:** Автоскейлинг
- **Ingress:** Внешний доступ

**Масштабирование:**
```
┌──────────────────────────────────────┐
│           Load Balancer              │
│             (Ingress)                │
└────────────────┬─────────────────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
    ▼            ▼            ▼
┌───────┐   ┌───────┐   ┌───────┐
│ Pod 1 │   │ Pod 2 │   │ Pod 3 │
│FastAPI│   │FastAPI│   │FastAPI│
└───────┘   └───────┘   └───────┘
    │            │            │
    └────────────┼────────────┘
                 │
         (Shared Storage)
```

## 🔄 Data Flow

### Request Processing

```
User Request
    │
    ▼
┌─────────────────────┐
│  Load Balancer      │
│  (Ingress/Nginx)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  FastAPI            │
│  Application        │
└──────────┬──────────┘
           │
           ├─────► CORS Middleware
           │
           ├─────► Pydantic Validation
           │
           ▼
┌─────────────────────┐
│  Business Logic     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Data Storage       │
│  (In-Memory)        │
└──────────┬──────────┘
           │
           ▼
     JSON Response
```

## 🔌 Integration Points

### Внешние интеграции (будущее)

1. **Database:**
   - PostgreSQL для production
   - SQLAlchemy ORM
   - Alembic для миграций

2. **Cache:**
   - Redis для кэширования
   - Session storage

3. **Monitoring:**
   - Prometheus metrics
   - Grafana dashboards
   - Sentry для errors

4. **Logging:**
   - Structured logging (JSON)
   - ELK Stack
   - CloudWatch/Stackdriver

5. **Authentication:**
   - JWT tokens
   - OAuth2
   - API keys

## 🏛️ Design Patterns

### Используемые паттерны

1. **Repository Pattern** (можно добавить):
```python
class TaskRepository:
    def get(self, id: str) -> Task
    def list(self, skip: int, limit: int) -> List[Task]
    def create(self, task: TaskCreate) -> Task
    def update(self, id: str, task: TaskUpdate) -> Task
    def delete(self, id: str) -> None
```

2. **Dependency Injection** (FastAPI):
```python
async def get_task(
    task_id: str,
    repo: TaskRepository = Depends(get_repository)
):
    return repo.get(task_id)
```

3. **Factory Pattern** (для создания объектов):
```python
class TaskFactory:
    @staticmethod
    def create(data: TaskCreate) -> Task:
        return Task(**data.dict(), id=uuid4())
```

## 🔐 Security Architecture

### Текущая реализация

- CORS настроен (можно ограничить в production)
- Pydantic валидация входных данных
- Trivy сканирование уязвимостей

### Планируемое

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │ HTTPS
       ▼
┌─────────────┐
│   WAF       │
│ (Optional)  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Rate        │
│ Limiting    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ API Gateway │
│ + Auth      │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  FastAPI    │
│  Backend    │
└─────────────┘
```

## 📊 Performance Considerations

### Текущая архитектура

- **In-memory storage:** Быстро, но не persistent
- **Single process:** Ограничение производительности
- **No caching:** Каждый запрос обрабатывается полностью

### Оптимизации для production

1. **Horizontal Scaling:**
   - Multiple replicas
   - Load balancing
   - Session affinity (если нужно)

2. **Vertical Scaling:**
   - Увеличение CPU/Memory
   - Uvicorn workers

3. **Caching:**
   - Redis для результатов
   - In-memory cache (LRU)

4. **Database:**
   - Connection pooling
   - Read replicas
   - Indexes

5. **CDN:**
   - Статические ресурсы
   - API responses (для публичных данных)

## 🔄 Deployment Strategies

### Rolling Update (По умолчанию в K8s)

```
Old: ████████░░ → ██████░░░░ → ████░░░░░░ → ░░░░░░░░░░
New: ░░░░░░░░░░ → ░░██░░░░░░ → ░░░░████░░ → ██████████
```

### Blue-Green Deployment

```
Blue (v1.0):  ████████████  →  ░░░░░░░░░░░░
                    ↓ switch
Green (v2.0): ░░░░░░░░░░░░  →  ████████████
```

### Canary Deployment

```
v1.0: ████████████ → ██████████ → ████████ → ░░░░
v2.0: ░░░░░░░░░░░░ → ░░░░░░░░░░ → ░░░░░░░░ → ████
```

## 📈 Scalability

### Horizontal Scaling

Приложение stateless, может масштабироваться горизонтально:

```
1 instance  → 100 RPS
3 instances → 300 RPS
10 instances → 1000 RPS
```

### Bottlenecks

1. **In-Memory Storage:** 
   - Проблема: Не shared между instances
   - Решение: External database (PostgreSQL/MongoDB)

2. **No Caching:**
   - Проблема: Повторная обработка
   - Решение: Redis cache

3. **Synchronous Processing:**
   - Проблема: Blocking операции
   - Решение: Async processing, task queues

## 🛠️ Development Workflow

```
Developer
    │
    ├─► git checkout -b feature/new
    │
    ├─► make run (local testing)
    │
    ├─► make test
    │
    ├─► git commit -m "feat: ..."
    │
    ├─► git push origin feature/new
    │
    └─► Create PR
            │
            ▼
        GitHub Actions (CI)
            │
            ├─► Tests
            ├─► Linting
            ├─► Security scan
            │
            ▼
        Code Review
            │
            ▼
        Merge to main
            │
            ▼
        GitHub Actions (CD)
            │
            ├─► Build image
            ├─► Push to GHCR
            └─► Deploy (optional)
```

## 🔮 Future Improvements

### Phase 1 (Basic)
- [ ] PostgreSQL integration
- [ ] Proper error handling
- [ ] Request logging
- [ ] API versioning

### Phase 2 (Intermediate)
- [ ] JWT authentication
- [ ] Redis caching
- [ ] Background tasks (Celery)
- [ ] Structured logging

### Phase 3 (Advanced)
- [ ] GraphQL API
- [ ] WebSocket support
- [ ] Microservices architecture
- [ ] Service mesh (Istio)
- [ ] Distributed tracing
- [ ] APM (Application Performance Monitoring)

## 📚 References

- [FastAPI Best Practices](https://fastapi.tiangolo.com/tutorial/)
- [12 Factor App](https://12factor.net/)
- [Kubernetes Patterns](https://kubernetes.io/docs/concepts/)
- [Microservices Patterns](https://microservices.io/patterns/)

