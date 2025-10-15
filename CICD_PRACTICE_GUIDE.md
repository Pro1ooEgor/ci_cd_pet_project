# 🎯 Руководство по практике CI/CD

Этот гайд поможет вам максимально эффективно использовать проект для изучения CI/CD и DevOps практик.

## 📚 Что вы изучите

### Уровень 1: Основы CI/CD
- ✅ Автоматическое тестирование
- ✅ Линтинг и форматирование кода
- ✅ Сборка Docker образов
- ✅ Базовый деплой

### Уровень 2: Продвинутые техники
- ✅ Multi-stage Docker builds
- ✅ Кэширование в CI/CD
- ✅ Сканирование безопасности
- ✅ Kubernetes deployment
- ✅ Auto-scaling

### Уровень 3: Production-ready
- ✅ Blue-Green deployment
- ✅ Canary releases
- ✅ Мониторинг и alerting
- ✅ Backup и recovery
- ✅ Infrastructure as Code

## 🚀 Практические упражнения

### Упражнение 1: Запуск локально
**Цель:** Понять структуру приложения

```bash
# 1. Запустить приложение
make run

# 2. Открыть Swagger UI
open http://localhost:8000/docs

# 3. Протестировать API
./scripts/test_api.sh

# 4. Запустить тесты
make test
```

**Что изучается:**
- FastAPI приложение
- REST API структура
- Unit testing с pytest
- Coverage measurement

### Упражнение 2: Docker контейнеризация
**Цель:** Научиться работать с Docker

```bash
# 1. Собрать образ
docker build -t my-fastapi-app .

# 2. Проверить размер
docker images | grep my-fastapi-app

# 3. Запустить контейнер
docker run -d -p 8000:8000 --name api my-fastapi-app

# 4. Проверить логи
docker logs -f api

# 5. Проверить health
curl http://localhost:8000/health

# 6. Остановить
docker stop api && docker rm api
```

**Что изучается:**
- Dockerfile best practices
- Multi-stage builds
- Container health checks
- Log management

### Упражнение 3: Docker Compose
**Цель:** Orchestration для локальной разработки

```bash
# 1. Запустить все сервисы
docker-compose up -d

# 2. Проверить статус
docker-compose ps

# 3. Масштабировать
docker-compose up -d --scale api=3

# 4. Посмотреть логи
docker-compose logs -f

# 5. Остановить
docker-compose down
```

**Что изучается:**
- Multi-container applications
- Service dependencies
- Scaling
- Networking

### Упражнение 4: GitHub Actions CI
**Цель:** Автоматизировать тестирование

```bash
# 1. Создать репозиторий на GitHub
git init
git add .
git commit -m "feat: initial commit"
git remote add origin <your-repo-url>
git push -u origin main

# 2. Проверить GitHub Actions
# Откройте: https://github.com/your-username/repo/actions

# 3. Внести изменение и создать PR
git checkout -b feature/test-ci
# Измените код
git commit -m "feat: test CI pipeline"
git push origin feature/test-ci
# Создайте PR на GitHub

# 4. Посмотрите как работает CI
```

**Что изучается:**
- GitHub Actions workflow
- Matrix testing (множество версий Python)
- Automated testing
- Code quality checks
- Security scanning
- Pull Request checks

### Упражнение 5: Container Registry
**Цель:** Публикация Docker образов

```bash
# 1. Настроить GitHub Container Registry (GHCR)
# GitHub автоматически создаст registry при push в main

# 2. После merge в main, проверить образ
# https://github.com/your-username/repo/pkgs/container/repo

# 3. Скачать образ
docker pull ghcr.io/your-username/repo:latest

# 4. Запустить скачанный образ
docker run -p 8000:8000 ghcr.io/your-username/repo:latest
```

**Что изучается:**
- Container registry
- Image tagging strategies
- Pull/Push процессы
- Version management

### Упражнение 6: Kubernetes Deployment
**Цель:** Деплой в Kubernetes

```bash
# Требуется: minikube или k8s кластер

# 1. Запустить minikube (локально)
minikube start

# 2. Обновить образ в deployment.yaml
# Замените image на ваш

# 3. Применить манифесты
kubectl apply -f k8s/

# 4. Проверить deployment
kubectl get pods
kubectl get services
kubectl get hpa

# 5. Проверить приложение
kubectl port-forward service/fastapi-pet-project-service 8000:80

# 6. Масштабировать вручную
kubectl scale deployment fastapi-pet-project --replicas=5

# 7. Проверить auto-scaling
# Создайте нагрузку на API
```

**Что изучается:**
- Kubernetes deployments
- Services и load balancing
- Horizontal Pod Autoscaling
- Health probes
- Rolling updates

### Упражнение 7: Continuous Deployment
**Цель:** Автоматический деплой

**Option A: Deплой на VPS**
```bash
# 1. Настроить сервер (DigitalOcean, Linode, etc.)
# 2. Установить Docker на сервере
# 3. Настроить SSH ключи

# 4. Добавить GitHub Secrets:
# - SERVER_HOST
# - SERVER_USER
# - SSH_PRIVATE_KEY

# 5. Раскомментировать deploy-to-server в .github/workflows/cd.yml

# 6. Push в main
git push origin main

# 7. Проверить деплой в Actions
```

**Option B: Deплой в Cloud (Heroku)**
```bash
# 1. Создать аккаунт на Heroku
heroku login

# 2. Создать приложение
heroku create my-fastapi-app

# 3. Установить container stack
heroku stack:set container

# 4. Деплой
git push heroku main

# 5. Открыть приложение
heroku open
```

**Что изучается:**
- Automated deployment
- SSH deployment
- Cloud platforms
- Production configuration
- Secrets management

### Упражнение 8: Мониторинг и Alerting
**Цель:** Настроить мониторинг

```bash
# 1. Добавить health check мониторинг
# Используйте: UptimeRobot, Pingdom, или Better Uptime

# 2. Настроить webhook для уведомлений
# GitHub Actions → Slack/Discord/Telegram

# 3. Добавить в .github/workflows/ci.yml:
# - name: Notify on failure
#   if: failure()
#   run: |
#     curl -X POST webhook-url \
#       -d '{"text": "Build failed!"}'

# 4. Проверить уведомления
```

**Что изучается:**
- Uptime monitoring
- Alerting
- Webhooks
- Notification systems

## 🎓 Учебные сценарии

### Сценарий 1: Добавление новой функции
**Задача:** Добавить эндпоинт для фильтрации задач

1. Создать ветку: `git checkout -b feature/filter-tasks`
2. Добавить эндпоинт в `app/main.py`:
```python
@app.get("/tasks/filter")
async def filter_tasks(completed: bool):
    return [t for t in tasks_db.values() if t.completed == completed]
```
3. Написать тест в `tests/test_main.py`
4. Запустить локально: `make test`
5. Закоммитить: `git commit -m "feat: add task filtering"`
6. Push и создать PR
7. Посмотреть как работает CI
8. Merge после успешных проверок
9. Посмотреть как работает CD

**Навыки:** Git workflow, TDD, CI/CD pipeline

### Сценарий 2: Исправление бага
**Задача:** Исправить ошибку валидации

1. Создать issue на GitHub
2. Создать ветку: `git checkout -b fix/validation-bug`
3. Исправить код
4. Добавить regression test
5. Push и создать PR с reference на issue
6. Code review
7. Merge и автоматический деплой

**Навыки:** Bug tracking, Regression testing, Issue management

### Сценарий 3: Оптимизация Docker образа
**Задача:** Уменьшить размер образа

1. Проверить текущий размер: `docker images`
2. Оптимизировать Dockerfile:
   - Использовать alpine вместо slim
   - Multi-stage build
   - Минимизировать layers
   - .dockerignore optimization
3. Сравнить размеры
4. Проверить что всё работает
5. Commit и push

**Навыки:** Docker optimization, Performance tuning

### Сценарий 4: Настройка production environment
**Задача:** Подготовить production deployment

1. Создать `docker-compose.prod.yml`
2. Добавить PostgreSQL вместо in-memory
3. Настроить environment variables
4. Добавить reverse proxy (Nginx)
5. Настроить SSL/TLS
6. Добавить logging
7. Настроить backups

**Навыки:** Production configuration, Database setup, Security

### Сценарий 5: Load Testing
**Задача:** Протестировать под нагрузкой

```bash
# 1. Установить locust
pip install locust

# 2. Создать locustfile.py
cat > locustfile.py << 'EOF'
from locust import HttpUser, task, between

class APIUser(HttpUser):
    wait_time = between(1, 3)
    
    @task
    def health_check(self):
        self.client.get("/health")
    
    @task(3)
    def get_tasks(self):
        self.client.get("/tasks")
    
    @task(2)
    def create_task(self):
        self.client.post("/tasks", json={
            "title": "Load test task",
            "description": "Testing"
        })
EOF

# 3. Запустить нагрузочное тестирование
locust -f locustfile.py --host http://localhost:8000

# 4. Открыть UI: http://localhost:8089
# 5. Запустить тест с 100 users, spawn rate 10
# 6. Анализировать результаты
```

**Навыки:** Load testing, Performance analysis, Bottleneck identification

## 🏆 Челленджи

### 🥉 Бронзовый уровень
- [ ] Запустить проект локально
- [ ] Написать дополнительный тест
- [ ] Создать PR с изменением
- [ ] Запустить в Docker

### 🥈 Серебряный уровень
- [ ] Добавить новый эндпоинт
- [ ] Настроить GitHub Actions
- [ ] Деплой в Heroku/Railway
- [ ] Оптимизировать Docker образ
- [ ] Добавить pre-commit hooks

### 🥇 Золотой уровень
- [ ] Интегрировать PostgreSQL
- [ ] Добавить JWT аутентификацию
- [ ] Настроить Kubernetes деплой
- [ ] Добавить мониторинг
- [ ] Настроить auto-scaling
- [ ] Создать staging/production environments

### 💎 Платиновый уровень
- [ ] Microservices архитектура
- [ ] Service Mesh (Istio)
- [ ] Distributed tracing
- [ ] Blue-Green deployment
- [ ] Canary releases
- [ ] GitOps с ArgoCD
- [ ] Infrastructure as Code (Terraform)

## 📊 Метрики успеха

Отслеживайте свой прогресс:

### CI/CD Metrics
- ⏱️ **Build Time:** < 5 минут
- ✅ **Test Coverage:** > 80%
- 🔒 **Security Issues:** 0 high/critical
- 📦 **Image Size:** < 200MB

### Deployment Metrics
- 🚀 **Deployment Frequency:** Несколько раз в день
- ⏰ **Lead Time:** < 1 час
- 📈 **Success Rate:** > 95%
- 🔄 **Rollback Time:** < 5 минут

## 🛠️ Рекомендуемые инструменты для изучения

### Must-Have
- Git & GitHub
- Docker & Docker Compose
- GitHub Actions

### Recommended
- Kubernetes (minikube для локального)
- Helm (пакетный менеджер для K8s)
- Terraform (Infrastructure as Code)
- Ansible (Configuration management)

### Advanced
- ArgoCD (GitOps)
- Prometheus & Grafana (Monitoring)
- ELK Stack (Logging)
- Istio (Service Mesh)

## 📚 Дополнительные ресурсы

### Онлайн курсы
- [Docker Mastery](https://www.udemy.com/course/docker-mastery/)
- [Kubernetes for Developers](https://kubernetes.io/docs/tutorials/)
- [GitHub Actions Tutorial](https://docs.github.com/en/actions/learn-github-actions)

### Книги
- "The DevOps Handbook" - Gene Kim
- "Continuous Delivery" - Jez Humble
- "Site Reliability Engineering" - Google

### Практика
- [Play with Docker](https://labs.play-with-docker.com/)
- [Play with Kubernetes](https://labs.play-with-k8s.com/)
- [Katacoda Scenarios](https://www.katacoda.com/)

## 💡 Советы

1. **Начните с простого:** Не пытайтесь внедрить всё сразу
2. **Автоматизируйте постепенно:** Каждая автоматизация должна решать реальную проблему
3. **Тестируйте всё:** Тесты - основа надежного CI/CD
4. **Документируйте:** Документация важна как код
5. **Мониторьте:** Что не мониторится - не может быть улучшено
6. **Учитесь на ошибках:** Каждый failed build - урок

## 🤝 Получение помощи

- 📖 Читайте документацию в `docs/`
- 🐛 Создавайте Issues для вопросов
- 💬 Обсуждайте в Discussions
- 🔍 Изучайте существующие PR

---

**Удачи в изучении DevOps! 🚀**

Помните: Лучший способ учиться - практика. Не бойтесь экспериментировать и ломать вещи (в безопасной среде)!

