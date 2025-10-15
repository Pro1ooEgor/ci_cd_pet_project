# 🚀 Быстрый старт

Это самый быстрый способ начать работу с проектом.

## 📋 Предварительные требования

```bash
# Проверьте версии
python3 --version  # Должна быть 3.10+
docker --version   # Опционально
git --version
```

## ⚡ Метод 1: Автоматическая установка

```bash
# Клонировать репозиторий
git clone <your-repo-url>
cd ci_cd_pet_project

# Запустить скрипт установки
./scripts/setup.sh

# Активировать окружение
source venv/bin/activate

# Запустить приложение
make run
```

**Готово!** Откройте http://localhost:8000/docs

## 🐳 Метод 2: Docker (Рекомендуется)

```bash
# Клонировать репозиторий
git clone <your-repo-url>
cd ci_cd_pet_project

# Запустить с Docker Compose
docker-compose up -d

# Проверить статус
docker-compose ps

# Посмотреть логи
docker-compose logs -f
```

**Готово!** Откройте http://localhost:8000/docs

## 📝 Метод 3: Ручная установка

```bash
# 1. Клонировать репозиторий
git clone <your-repo-url>
cd ci_cd_pet_project

# 2. Создать виртуальное окружение
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 3. Установить зависимости
pip install -r requirements-dev.txt

# 4. Запустить тесты (опционально)
pytest tests/ -v

# 5. Запустить приложение
uvicorn app.main:app --reload
```

**Готово!** Откройте http://localhost:8000/docs

## 🧪 Проверка работоспособности

После запуска выполните:

```bash
# Health check
curl http://localhost:8000/health

# Создать задачу
curl -X POST http://localhost:8000/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Task", "description": "My first task"}'

# Получить все задачи
curl http://localhost:8000/tasks
```

Ожидаемый ответ:
```json
{
  "status": "healthy",
  "timestamp": "2025-10-11T12:00:00.000000"
}
```

## 🔧 Основные команды

```bash
make help           # Показать все команды
make test           # Запустить тесты
make lint           # Проверить код
make format         # Форматировать код
make docker-up      # Запустить Docker
make docker-down    # Остановить Docker
```

## 📚 Куда дальше?

1. **Изучите API**: http://localhost:8000/docs
2. **Прочитайте документацию**: [README.md](README.md)
3. **Посмотрите код**: [app/main.py](app/main.py)
4. **Изучите тесты**: [tests/test_main.py](tests/test_main.py)

## ❓ Проблемы?

### Порт 8000 занят

```bash
# Найти процесс
lsof -i :8000

# Или измените порт
uvicorn app.main:app --reload --port 8080
```

### Ошибка импорта

```bash
# Убедитесь что активировано виртуальное окружение
source venv/bin/activate

# Переустановите зависимости
pip install -r requirements-dev.txt
```

### Docker ошибки

```bash
# Пересоберите образ
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 🎯 Следующие шаги

1. ✅ Запустить приложение локально
2. ✅ Протестировать API через Swagger
3. ✅ Запустить тесты
4. ✅ Попробовать Docker деплой
5. ✅ Настроить GitHub Actions (push в GitHub)
6. ✅ Изучить Kubernetes манифесты

## 📖 Полная документация

- [README.md](README.md) - Основная документация
- [API.md](docs/API.md) - Документация API
- [DEPLOYMENT.md](docs/DEPLOYMENT.md) - Деплой
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Архитектура
- [CONTRIBUTING.md](CONTRIBUTING.md) - Вклад в проект

---

**Удачи! 🎉**

