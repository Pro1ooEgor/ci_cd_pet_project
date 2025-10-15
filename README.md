# FastAPI CI/CD Pet Project 🚀

Учебный проект на FastAPI для практики навыков CI/CD и DevOps. Включает настроенный CI/CD pipeline с GitHub Actions, Docker контейнеризацию, тесты и автоматические проверки кода.

## 📋 Содержание

- [Возможности](#возможности)
- [Технологии](#технологии)
- [Быстрый старт](#быстрый-старт)
- [Локальная разработка](#локальная-разработка)
- [Тестирование](#тестирование)
- [Docker](#docker)
- [CI/CD Pipeline](#cicd-pipeline)
- [API Документация](#api-документация)
- [Структура проекта](#структура-проекта)
- [DevOps практики](#devops-практики)

## ✨ Возможности

- ✅ RESTful API с CRUD операциями для задач
- ✅ Автоматические тесты с покрытием кода
- ✅ CI/CD pipeline с GitHub Actions
- ✅ Docker контейнеризация
- ✅ Автоматическая проверка кода (linting, formatting)
- ✅ Автоматическое сканирование безопасности
- ✅ Health checks и мониторинг
- ✅ Автоматическая сборка и публикация Docker образов

## 🛠 Технологии

- **Backend:** FastAPI 0.104+
- **Тестирование:** pytest, pytest-cov
- **Контейнеризация:** Docker, Docker Compose
- **CI/CD:** GitHub Actions
- **Качество кода:** black, flake8, mypy
- **Безопасность:** Trivy vulnerability scanner

## 🚀 Быстрый старт

### Предварительные требования

- Python 3.10+
- Docker и Docker Compose (опционально)
- Git

### Установка

1. Клонируйте репозиторий:
```bash
git clone <your-repo-url>
cd ci_cd_pet_project
```

2. Создайте виртуальное окружение:
```bash
python -m venv venv
source venv/bin/activate  # На Windows: venv\Scripts\activate
```

3. Установите зависимости:
```bash
make dev-install
# или
pip install -r requirements-dev.txt
```

4. Запустите приложение:
```bash
make run
# или
uvicorn app.main:app --reload
```

5. Откройте браузер: http://localhost:8000

## 💻 Локальная разработка

### Доступные команды (Makefile)

```bash
make help           # Показать все доступные команды
make install        # Установить production зависимости
make dev-install    # Установить development зависимости
make test           # Запустить тесты с покрытием
make lint           # Запустить линтеры
make format         # Форматировать код
make clean          # Очистить кэш и временные файлы
make run            # Запустить приложение
make docker-build   # Собрать Docker образ
make docker-up      # Запустить Docker контейнеры
make docker-down    # Остановить Docker контейнеры
```

### Форматирование и проверка кода

```bash
# Форматирование кода
make format

# Проверка линтерами
make lint

# Запуск всех проверок
make format && make lint && make test
```

## 🧪 Тестирование

Проект включает полный набор тестов:

```bash
# Запустить все тесты
make test

# Запустить тесты с подробным выводом
pytest tests/ -v

# Запустить тесты с покрытием
pytest tests/ --cov=app --cov-report=html

# Запустить конкретный тест
pytest tests/test_main.py::test_create_task -v
```

Покрытие кода будет сохранено в `htmlcov/index.html`

## 🐳 Docker

### Локальный запуск с Docker

```bash
# Собрать и запустить контейнеры
make docker-up

# Остановить контейнеры
make docker-down

# Просмотр логов
make docker-logs

# Или используйте docker-compose напрямую
docker-compose up -d
docker-compose logs -f
docker-compose down
```

### Сборка образа вручную

```bash
# Собрать образ
docker build -t fastapi-pet-project .

# Запустить контейнер
docker run -d -p 8000:8000 --name api fastapi-pet-project

# Проверить статус
docker ps
curl http://localhost:8000/health
```

## 🔄 CI/CD Pipeline

Проект использует GitHub Actions для автоматизации:

### CI Pipeline (`.github/workflows/ci.yml`)

Запускается при каждом push и pull request:

1. **Тестирование на нескольких версиях Python** (3.10, 3.11, 3.12)
   - Запуск pytest с покрытием кода
   - Загрузка результатов в Codecov

2. **Проверка качества кода**
   - flake8 для проверки стиля
   - black для проверки форматирования
   - mypy для проверки типов

3. **Сборка Docker образа**
   - Проверка успешной сборки
   - Тестирование работоспособности образа

4. **Сканирование безопасности**
   - Trivy scanner для поиска уязвимостей

### CD Pipeline (`.github/workflows/cd.yml`)

Запускается при push в main или создании тега:

1. **Сборка и публикация Docker образа**
   - Автоматическая публикация в GitHub Container Registry
   - Создание тегов версий
   - Кэширование слоёв для ускорения сборки

2. **Подготовка к деплою**
   - Генерация артефактов деплоя
   - (Опционально) Деплой на сервер через SSH

### PR Checks (`.github/workflows/pr-checks.yml`)

Дополнительные проверки для Pull Request:
- Валидация заголовка PR (conventional commits)
- Проверка на конфликты
- Автоматические комментарии

## 📚 API Документация

После запуска приложения доступна интерактивная документация:

- **Swagger UI:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc

### Основные эндпоинты

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/` | Корневой эндпоинт |
| GET | `/health` | Health check |
| GET | `/tasks` | Получить все задачи |
| POST | `/tasks` | Создать задачу |
| GET | `/tasks/{id}` | Получить задачу по ID |
| PUT | `/tasks/{id}` | Обновить задачу |
| DELETE | `/tasks/{id}` | Удалить задачу |
| GET | `/stats` | Получить статистику |

### Примеры запросов

```bash
# Health check
curl http://localhost:8000/health

# Создать задачу
curl -X POST http://localhost:8000/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Task", "description": "Test description"}'

# Получить все задачи
curl http://localhost:8000/tasks

# Получить статистику
curl http://localhost:8000/stats
```

## 📁 Структура проекта

```
ci_cd_pet_project/
├── .github/
│   └── workflows/          # GitHub Actions workflows
│       ├── ci.yml          # CI pipeline
│       ├── cd.yml          # CD pipeline
│       └── pr-checks.yml   # PR validation
├── app/
│   ├── __init__.py
│   └── main.py            # Основное приложение FastAPI
├── tests/
│   ├── __init__.py
│   └── test_main.py       # Тесты
├── .dockerignore          # Игнорируемые файлы для Docker
├── .flake8                # Конфигурация flake8
├── .gitignore             # Игнорируемые файлы для Git
├── Dockerfile             # Docker образ
├── docker-compose.yml     # Docker Compose конфигурация
├── Makefile              # Команды для разработки
├── pyproject.toml        # Конфигурация инструментов
├── pytest.ini            # Конфигурация pytest
├── requirements.txt      # Production зависимости
├── requirements-dev.txt  # Development зависимости
└── README.md            # Документация
```

## 🎯 DevOps практики

Этот проект демонстрирует следующие DevOps практики:

### 1. Continuous Integration (CI)
- ✅ Автоматический запуск тестов при каждом коммите
- ✅ Проверка качества кода (linting)
- ✅ Проверка форматирования кода
- ✅ Статический анализ типов
- ✅ Измерение покрытия кода тестами

### 2. Continuous Deployment (CD)
- ✅ Автоматическая сборка Docker образов
- ✅ Публикация в Container Registry
- ✅ Версионирование с помощью тегов
- ✅ Подготовка к автоматическому деплою

### 3. Контейнеризация
- ✅ Multi-stage Docker builds
- ✅ Оптимизация размера образа
- ✅ Health checks для контейнеров
- ✅ Docker Compose для локальной разработки

### 4. Безопасность
- ✅ Сканирование уязвимостей с Trivy
- ✅ Минимальные Docker образы (slim)
- ✅ Не запуск от root (можно добавить)
- ✅ Секреты через переменные окружения

### 5. Мониторинг
- ✅ Health check эндпоинты
- ✅ Docker health checks
- ✅ Логирование (можно расширить)

### 6. Автоматизация
- ✅ Makefile для стандартизации команд
- ✅ Git hooks (можно добавить pre-commit)
- ✅ Автоматические PR проверки

## 🔧 Настройка для вашего проекта

### 1. GitHub Actions Secrets

Для деплоя на сервер добавьте секреты в Settings → Secrets:

```
SERVER_HOST       # IP или домен сервера
SERVER_USER       # Пользователь для SSH
SSH_PRIVATE_KEY   # Приватный ключ для SSH
```

### 2. GitHub Container Registry

Образы автоматически публикуются в GHCR. Для использования:

```bash
# Войти в registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Скачать образ
docker pull ghcr.io/yourusername/ci_cd_pet_project:latest
```

### 3. Включение деплоя

Раскомментируйте секцию `deploy-to-server` в `.github/workflows/cd.yml` и настройте под ваш сервер.

## 📈 Следующие шаги

Идеи для расширения проекта:

- [ ] Добавить PostgreSQL базу данных
- [ ] Интегрировать Redis для кэширования
- [ ] Добавить аутентификацию (JWT)
- [ ] Настроить мониторинг (Prometheus + Grafana)
- [ ] Добавить логирование (ELK stack)
- [ ] Kubernetes манифесты
- [ ] Terraform для инфраструктуры
- [ ] Ansible для конфигурации
- [ ] Integration тесты
- [ ] Load тесты (Locust)

## 🤝 Вклад в проект

1. Fork проекта
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'feat: add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📝 Лицензия

Этот проект создан в учебных целях и доступен под MIT лицензией.

## 📞 Контакты

Если у вас есть вопросы или предложения - создайте Issue в репозитории!

---

**Happy coding and deploying! 🚀**

