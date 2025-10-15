# 📁 Структура проекта

Полное описание файловой структуры FastAPI Pet Project.

```
ci_cd_pet_project/
│
├── 📁 .github/                      # GitHub конфигурация
│   └── workflows/                   # GitHub Actions workflows
│       ├── ci.yml                   # CI pipeline (тесты, линтинг, сборка)
│       ├── cd.yml                   # CD pipeline (деплой)
│       └── pr-checks.yml            # Проверки Pull Request
│
├── 📁 app/                          # Исходный код приложения
│   ├── __init__.py                  # Package marker
│   └── main.py                      # FastAPI приложение (эндпоинты, модели)
│
├── 📁 tests/                        # Тесты
│   ├── __init__.py                  # Package marker
│   └── test_main.py                 # Тесты для main.py
│
├── 📁 docs/                         # Документация
│   ├── API.md                       # API документация
│   ├── ARCHITECTURE.md              # Архитектура проекта
│   └── DEPLOYMENT.md                # Руководство по деплою
│
├── 📁 k8s/                          # Kubernetes манифесты
│   ├── deployment.yaml              # Deployment + Service + HPA
│   └── ingress.yaml                 # Ingress конфигурация
│
├── 📁 scripts/                      # Utility скрипты
│   ├── setup.sh                     # Автоматическая установка
│   ├── run_local.sh                 # Запуск с проверками
│   └── deploy.sh                    # Деплой на сервер
│
├── 📄 .dockerignore                 # Игнорируемые файлы для Docker
├── 📄 .editorconfig                 # Настройки редактора
├── 📄 .flake8                       # Конфигурация flake8
├── 📄 .gitignore                    # Игнорируемые файлы для Git
├── 📄 .pre-commit-config.yaml       # Pre-commit hooks
│
├── 📄 CONTRIBUTING.md               # Руководство для контрибьюторов
├── 📄 LICENSE                       # Лицензия (MIT)
├── 📄 QUICKSTART.md                 # Быстрый старт
├── 📄 README.md                     # Основная документация
├── 📄 PROJECT_STRUCTURE.md          # Этот файл
│
├── 📄 Dockerfile                    # Docker образ
├── 📄 docker-compose.yml            # Docker Compose конфигурация
│
├── 📄 Makefile                      # Команды для разработки
├── 📄 pyproject.toml                # Конфигурация Python инструментов
├── 📄 pytest.ini                    # Конфигурация pytest
│
├── 📄 requirements.txt              # Production зависимости
└── 📄 requirements-dev.txt          # Development зависимости
```

## 📝 Описание ключевых файлов

### Application Files

#### `app/main.py`
Главный файл приложения. Содержит:
- FastAPI app instance
- CORS middleware настройки
- Pydantic модели (Task, TaskCreate, TaskUpdate)
- In-memory хранилище (tasks_db)
- CRUD эндпоинты для задач
- Health check эндпоинты
- Статистику

**Размер:** ~150 строк  
**Зависимости:** FastAPI, Pydantic, uuid, datetime

#### `tests/test_main.py`
Полный набор тестов. Содержит:
- 13 тестов покрывающих все эндпоинты
- Fixture для очистки БД
- Unit тесты для CRUD операций
- Тесты для edge cases (404, validation)

**Покрытие кода:** ~100%

### Configuration Files

#### `requirements.txt`
Production зависимости:
```
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
python-dotenv==1.0.0
```

#### `requirements-dev.txt`
Development зависимости (включает requirements.txt):
```
pytest==7.4.3
pytest-asyncio==0.21.1
pytest-cov==4.1.0
httpx==0.25.1
black==23.11.0
flake8==6.1.0
mypy==1.7.0
```

#### `pyproject.toml`
Централизованная конфигурация для:
- Black (форматирование)
- MyPy (type checking)
- Pytest (тестирование)
- Coverage (покрытие кода)

#### `pytest.ini`
Настройки pytest:
- Пути к тестам
- Опции запуска
- Маркеры для группировки тестов

#### `.flake8`
Настройки линтера:
- Максимальная длина строки: 127
- Исключения директорий
- Игнорируемые правила

### Docker Files

#### `Dockerfile`
Multi-stage Docker образ:
- Base: Python 3.11-slim
- Оптимизированная установка зависимостей
- Health check
- Non-root user (можно добавить)

**Размер образа:** ~200MB (можно оптимизировать до ~100MB)

#### `docker-compose.yml`
Локальная разработка:
- Один сервис (api)
- Volume mounting для hot reload
- Health checks
- Port mapping 8000:8000

#### `.dockerignore`
Исключает из образа:
- Python cache (__pycache__, *.pyc)
- Virtual environments
- Tests
- Documentation
- Git files

### CI/CD Files

#### `.github/workflows/ci.yml`
CI Pipeline включает:
1. **Multi-version testing** (Python 3.10, 3.11, 3.12)
2. **Code quality checks:**
   - Flake8 (linting)
   - Black (formatting)
   - MyPy (type checking)
3. **Testing:**
   - Pytest with coverage
   - Codecov integration
4. **Docker build:**
   - Test build
   - Container health check
5. **Security:**
   - Trivy vulnerability scan

**Triggers:** Push и PR на main/develop

#### `.github/workflows/cd.yml`
CD Pipeline включает:
1. **Docker build & push:**
   - GitHub Container Registry
   - Automatic tagging (branch, sha, semver)
   - Layer caching
2. **Deployment artifact generation**
3. **Optional server deployment** (закомментирован)

**Triggers:** Push на main, создание тегов

#### `.github/workflows/pr-checks.yml`
PR validations:
- Semantic commit messages
- Merge conflicts check
- Welcome comment для новых PR

### Kubernetes Files

#### `k8s/deployment.yaml`
Содержит:
- **Deployment:** 3 replicas, resource limits, probes
- **Service:** LoadBalancer type, port 80→8000
- **HPA:** Auto-scaling 2-10 pods по CPU/Memory

#### `k8s/ingress.yaml`
Настройки:
- Nginx ingress
- TLS/SSL (Let's Encrypt)
- Domain routing

### Utility Scripts

#### `scripts/setup.sh`
Автоматическая установка:
- Проверка Python версии
- Создание venv
- Установка зависимостей
- Создание .env
- Запуск тестов

**Использование:** `./scripts/setup.sh`

#### `scripts/run_local.sh`
Запуск с проверками:
- Форматирование
- Линтинг
- Тесты
- Запуск приложения

**Использование:** `./scripts/run_local.sh`

#### `scripts/deploy.sh`
Деплой на сервер:
- SSH подключение
- Docker pull & restart
- Health checks

**Использование:** `SERVER_HOST=... ./scripts/deploy.sh`

### Documentation

#### `README.md`
Главная документация (~400 строк):
- Описание проекта
- Быстрый старт
- Полное руководство
- DevOps практики
- Примеры использования

#### `CONTRIBUTING.md`
Руководство для контрибьюторов:
- Процесс разработки
- Conventional commits
- Code review
- Standards

#### `QUICKSTART.md`
Быстрый старт (эта страница):
- 3 способа установки
- Основные команды
- Troubleshooting

#### `docs/API.md`
API документация:
- Все эндпоинты
- Request/Response примеры
- Error codes
- Data models

#### `docs/ARCHITECTURE.md`
Архитектура проекта:
- Диаграммы компонентов
- Data flow
- Design patterns
- Scalability

#### `docs/DEPLOYMENT.md`
Руководство по деплою:
- Docker Compose
- Kubernetes
- Cloud platforms
- Security checklist

### Helper Files

#### `Makefile`
Удобные команды:
```bash
make help          # Список команд
make test          # Тесты
make lint          # Линтинг
make format        # Форматирование
make docker-up     # Docker запуск
```

#### `.pre-commit-config.yaml`
Автоматические проверки перед коммитом:
- Trailing whitespace
- YAML validation
- Black formatting
- Flake8 linting

#### `.editorconfig`
Единые настройки для редакторов:
- Encoding: UTF-8
- Line endings: LF
- Indentation: 4 spaces (Python), 2 spaces (YAML)

#### `LICENSE`
MIT License - открытое использование

## 📊 Статистика проекта

```
Всего файлов:        ~35
Python файлов:       3 (app + tests)
Строк кода:          ~200
Строк тестов:        ~200
Workflow файлов:     3
Kubernetes файлов:   2
Документации:        ~1500 строк
Скриптов:            3
```

## 🎯 Ключевые возможности структуры

### ✅ Separation of Concerns
- Код отделен от тестов
- Конфигурация отделена от кода
- Документация организована по темам

### ✅ DevOps Ready
- CI/CD workflows готовы к использованию
- Docker & Kubernetes конфигурации
- Автоматизация через Makefile

### ✅ Developer Friendly
- Pre-commit hooks
- Comprehensive documentation
- Helper scripts

### ✅ Production Ready
- Health checks
- Security scanning
- Monitoring готовность
- Scalability из коробки

### ✅ Maintainable
- Понятная структура
- Хорошие комментарии
- Модульная архитектура

## 🔄 Как расширять проект

### Добавить новый эндпоинт
1. Добавить модель в `app/main.py`
2. Добавить эндпоинт функцию
3. Написать тесты в `tests/test_main.py`
4. Обновить `docs/API.md`

### Добавить базу данных
1. Создать `app/database.py`
2. Создать `app/models.py` (SQLAlchemy)
3. Добавить миграции (Alembic)
4. Обновить `requirements.txt`

### Добавить аутентификацию
1. Создать `app/auth.py`
2. Добавить JWT dependencies
3. Обновить эндпоинты
4. Добавить тесты

### Добавить новый сервис
1. Создать директорию в `app/services/`
2. Добавить необходимые модули
3. Обновить tests
4. Документировать

## 🔍 Навигация по коду

### Для разработчиков
**Начните с:**
1. `README.md` - общее понимание
2. `app/main.py` - код приложения
3. `tests/test_main.py` - примеры использования

### Для DevOps
**Начните с:**
1. `Dockerfile` - понять образ
2. `docker-compose.yml` - локальный запуск
3. `.github/workflows/` - CI/CD
4. `k8s/` - Kubernetes деплой

### Для контрибьюторов
**Начните с:**
1. `CONTRIBUTING.md` - процесс
2. `README.md` - контекст
3. `docs/ARCHITECTURE.md` - архитектура

---

**Вопросы?** Создайте Issue в репозитории!

