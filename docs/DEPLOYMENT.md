# Руководство по деплою

Это руководство описывает различные способы деплоя FastAPI Pet Project.

## 📋 Содержание

1. [Docker Compose](#docker-compose)
2. [Kubernetes](#kubernetes)
3. [VPS/Dedicated Server](#vpsdedicated-server)
4. [Cloud Platforms](#cloud-platforms)
5. [GitHub Actions CD](#github-actions-cd)

## 🐳 Docker Compose

Самый простой способ для development и small production.

### Локальный деплой

```bash
# Собрать и запустить
docker-compose up -d

# Проверить статус
docker-compose ps

# Посмотреть логи
docker-compose logs -f

# Остановить
docker-compose down
```

### Production конфигурация

Создайте `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  api:
    image: ghcr.io/yourusername/ci_cd_pet_project:latest
    container_name: fastapi_prod
    ports:
      - "80:8000"
    environment:
      - ENVIRONMENT=production
    restart: always
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

Запуск:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## ☸️ Kubernetes

Для масштабируемых production deployments.

### Подготовка

1. Убедитесь, что у вас есть доступ к Kubernetes кластеру
2. Установите `kubectl`
3. Настройте контекст кластера

### Деплой

```bash
# Применить все манифесты
kubectl apply -f k8s/

# Проверить статус
kubectl get pods
kubectl get services
kubectl get ingress

# Проверить логи
kubectl logs -f deployment/fastapi-pet-project

# Масштабирование
kubectl scale deployment fastapi-pet-project --replicas=5
```

### Настройка образа

Отредактируйте `k8s/deployment.yaml`:

```yaml
spec:
  containers:
  - name: api
    image: ghcr.io/YOUR_USERNAME/ci_cd_pet_project:latest
```

### Настройка домена

Отредактируйте `k8s/ingress.yaml`:

```yaml
spec:
  rules:
  - host: api.yourdomain.com
```

### Секреты (для будущего использования)

```bash
# Создать секрет
kubectl create secret generic app-secrets \
  --from-literal=DATABASE_URL='postgresql://...' \
  --from-literal=SECRET_KEY='your-secret-key'

# Использовать в deployment
envFrom:
  - secretRef:
      name: app-secrets
```

## 🖥️ VPS/Dedicated Server

Деплой на обычный сервер (DigitalOcean, Linode, AWS EC2, etc.)

### Требования

- Ubuntu 20.04+ или другой Linux
- Docker и Docker Compose установлены
- Открыт порт 80/443
- Домен (опционально)

### Ручной деплой

1. **Подключитесь к серверу:**
```bash
ssh user@your-server.com
```

2. **Установите Docker:**
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

3. **Установите Docker Compose:**
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

4. **Клонируйте репозиторий:**
```bash
git clone https://github.com/yourusername/ci_cd_pet_project.git
cd ci_cd_pet_project
```

5. **Запустите приложение:**
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Автоматический деплой со скриптом

```bash
# На вашем локальном компьютере
export SERVER_HOST="your-server.com"
export SERVER_USER="deploy"
./scripts/deploy.sh
```

### Настройка Nginx reverse proxy

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### SSL с Let's Encrypt

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d api.yourdomain.com
```

## ☁️ Cloud Platforms

### Heroku

```bash
# Установить Heroku CLI
# https://devcenter.heroku.com/articles/heroku-cli

# Войти
heroku login

# Создать приложение
heroku create your-app-name

# Установить stack на container
heroku stack:set container

# Деплой
git push heroku main

# Открыть приложение
heroku open
```

### Railway

1. Подключите GitHub репозиторий на [railway.app](https://railway.app)
2. Railway автоматически определит Dockerfile
3. Настройте переменные окружения
4. Деплой произойдет автоматически

### Render

1. Создайте новый Web Service на [render.com](https://render.com)
2. Подключите GitHub репозиторий
3. Настройки:
   - Environment: Docker
   - Build Command: (оставьте пустым)
   - Start Command: (оставьте пустым)
4. Деплой произойдет автоматически

### AWS ECS (Elastic Container Service)

1. Создайте ECR репозиторий
2. Загрузите образ:
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com
docker tag fastapi-pet-project:latest YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/fastapi-pet-project:latest
docker push YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/fastapi-pet-project:latest
```
3. Создайте ECS кластер и сервис
4. Настройте Load Balancer

### Google Cloud Run

```bash
# Настроить gcloud CLI
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# Собрать и загрузить образ
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/fastapi-pet-project

# Деплой
gcloud run deploy fastapi-pet-project \
  --image gcr.io/YOUR_PROJECT_ID/fastapi-pet-project \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

## 🔄 GitHub Actions CD

Автоматический деплой настроен в `.github/workflows/cd.yml`.

### Настройка для GitHub Container Registry

1. Образы автоматически публикуются в GHCR при push в `main`
2. Используйте образ:
```bash
docker pull ghcr.io/yourusername/ci_cd_pet_project:latest
```

### Настройка деплоя на сервер

1. Добавьте секреты в GitHub:
   - Settings → Secrets and variables → Actions
   - Добавьте:
     - `SERVER_HOST`: IP или домен сервера
     - `SERVER_USER`: пользователь SSH
     - `SSH_PRIVATE_KEY`: приватный SSH ключ

2. Раскомментируйте секцию `deploy-to-server` в `cd.yml`

3. При каждом push в `main` будет происходить автоматический деплой

## 🔐 Безопасность

### Checklist перед production деплоем

- [ ] Изменить все секреты и ключи
- [ ] Настроить HTTPS/SSL
- [ ] Настроить firewall (UFW, Security Groups)
- [ ] Настроить rate limiting
- [ ] Настроить CORS для разрешенных доменов
- [ ] Настроить логирование и мониторинг
- [ ] Настроить backups (если используется БД)
- [ ] Отключить debug режим
- [ ] Проверить безопасность с помощью сканеров

### Переменные окружения

Обязательно настройте:
```bash
ENVIRONMENT=production
DEBUG=false
SECRET_KEY=generate-strong-secret-key
ALLOWED_HOSTS=yourdomain.com
```

## 📊 Мониторинг

### Health checks

Приложение предоставляет `/health` эндпоинт для мониторинга.

### Uptime мониторинг

Используйте сервисы:
- UptimeRobot
- Pingdom
- StatusCake
- Better Uptime

### Логирование

Для production настройте централизованное логирование:
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Grafana Loki
- CloudWatch (AWS)
- Stackdriver (GCP)

### Метрики

Добавьте Prometheus metrics (требует расширения приложения).

## 🔄 Обновления

### Rolling updates (Kubernetes)

Kubernetes автоматически выполняет rolling updates:
```bash
kubectl set image deployment/fastapi-pet-project api=ghcr.io/yourusername/ci_cd_pet_project:v2.0.0
```

### Blue-Green deployment

1. Деплой новой версии рядом со старой
2. Переключение трафика после проверки
3. Удаление старой версии

### Canary deployment

1. Деплой новой версии для части пользователей
2. Постепенное увеличение трафика
3. Откат при проблемах

## 🆘 Troubleshooting

### Приложение не запускается

```bash
# Проверить логи
docker logs fastapi_pet_project
kubectl logs -f deployment/fastapi-pet-project

# Проверить health check
curl http://localhost:8000/health
```

### Контейнер постоянно перезапускается

```bash
# Проверить ресурсы
docker stats
kubectl top pods

# Проверить health check timeout
```

### Медленная работа

- Увеличить количество workers в uvicorn
- Масштабировать горизонтально (больше pod'ов)
- Добавить кэширование (Redis)
- Оптимизировать запросы к БД

## 📚 Дополнительные ресурсы

- [FastAPI Deployment](https://fastapi.tiangolo.com/deployment/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [12 Factor App](https://12factor.net/)

