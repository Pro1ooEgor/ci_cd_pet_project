# Руководство по вкладу в проект

Спасибо за интерес к проекту! Это руководство поможет вам внести свой вклад.

## 🚀 Начало работы

1. **Fork** репозитория
2. **Clone** вашего fork:
   ```bash
   git clone https://github.com/your-username/ci_cd_pet_project.git
   cd ci_cd_pet_project
   ```
3. Создайте **виртуальное окружение**:
   ```bash
   python -m venv venv
   source venv/bin/activate
   ```
4. Установите **зависимости**:
   ```bash
   make dev-install
   ```

## 📝 Процесс разработки

### 1. Создайте ветку

Используйте осмысленное название ветки:

```bash
git checkout -b feature/add-new-endpoint
git checkout -b fix/resolve-bug
git checkout -b docs/update-readme
```

### 2. Внесите изменения

- Следуйте существующему стилю кода
- Пишите понятные комментарии
- Обновляйте документацию при необходимости

### 3. Проверьте код

Перед коммитом запустите:

```bash
# Форматирование
make format

# Линтеры
make lint

# Тесты
make test
```

Все проверки должны пройти успешно!

### 4. Напишите тесты

Для новой функциональности обязательно добавьте тесты:

```python
def test_new_feature():
    """Test the new feature"""
    # Arrange
    # Act
    # Assert
    pass
```

### 5. Commit изменений

Используйте [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git commit -m "feat: add new endpoint for user management"
git commit -m "fix: resolve database connection issue"
git commit -m "docs: update API documentation"
git commit -m "test: add tests for new feature"
git commit -m "refactor: improve code structure"
```

Типы коммитов:
- `feat`: Новая функция
- `fix`: Исправление бага
- `docs`: Изменения в документации
- `style`: Форматирование, без изменения логики
- `refactor`: Рефакторинг кода
- `test`: Добавление или изменение тестов
- `chore`: Обслуживание проекта

### 6. Push изменений

```bash
git push origin feature/add-new-endpoint
```

### 7. Создайте Pull Request

1. Перейдите на GitHub
2. Нажмите "New Pull Request"
3. Заполните описание:
   - Что изменено
   - Почему это нужно
   - Как тестировалось

## ✅ Чеклист PR

Перед созданием PR убедитесь:

- [ ] Код форматирован (`make format`)
- [ ] Линтеры пройдены (`make lint`)
- [ ] Тесты пройдены (`make test`)
- [ ] Добавлены новые тесты (если нужно)
- [ ] Документация обновлена
- [ ] Коммиты следуют Conventional Commits
- [ ] PR имеет понятное описание

## 🐛 Сообщение об ошибках

При создании issue об ошибке укажите:

1. **Описание проблемы**
2. **Шаги для воспроизведения**
3. **Ожидаемое поведение**
4. **Актуальное поведение**
5. **Окружение** (OS, Python версия)
6. **Логи или скриншоты**

## 💡 Предложение функций

При предложении новой функции опишите:

1. **Проблему**, которую решает функция
2. **Предлагаемое решение**
3. **Альтернативы**, которые вы рассматривали
4. **Дополнительный контекст**

## 📋 Стандарты кода

### Python Style Guide

- Следуем **PEP 8**
- Используем **Black** для форматирования
- Максимальная длина строки: **100 символов**
- Используем **type hints** где возможно

### Документация

- Используйте docstrings для функций и классов
- Комментируйте сложную логику
- Обновляйте README при добавлении функций

### Тесты

- Покрытие кода > 80%
- Один тест = одна проверка
- Используйте понятные имена тестов
- Следуйте паттерну Arrange-Act-Assert

## 🔍 Code Review

Ваш PR будет проверен на:

- Соответствие стандартам кода
- Наличие и качество тестов
- Качество документации
- Производительность
- Безопасность

## 🎯 Приоритетные задачи

Ищете, с чего начать? Проверьте issues с метками:

- `good first issue` - для новичков
- `help wanted` - нужна помощь
- `bug` - исправление ошибок
- `enhancement` - улучшения

## 🤝 Общение

- Будьте вежливы и уважительны
- Конструктивная критика приветствуется
- Помогайте другим участникам

## 📚 Ресурсы

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [pytest Documentation](https://docs.pytest.org/)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

Спасибо за ваш вклад! 🎉

