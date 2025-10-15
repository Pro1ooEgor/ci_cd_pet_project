.PHONY: help install dev-install test lint format clean run docker-build docker-up docker-down

help:
	@echo "Available commands:"
	@echo "  make install       - Install production dependencies"
	@echo "  make dev-install   - Install development dependencies"
	@echo "  make test          - Run tests with coverage"
	@echo "  make lint          - Run linters (flake8, mypy)"
	@echo "  make format        - Format code with black"
	@echo "  make clean         - Remove cache and build files"
	@echo "  make run           - Run the application locally"
	@echo "  make docker-build  - Build Docker image"
	@echo "  make docker-up     - Start Docker containers"
	@echo "  make docker-down   - Stop Docker containers"

install:
	pip install -r requirements.txt

dev-install:
	pip install -r requirements-dev.txt

test:
	pytest tests/ -v --cov=app --cov-report=html --cov-report=term

lint:
	flake8 app tests
	mypy app --ignore-missing-imports

format:
	black app tests

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "htmlcov" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name ".coverage" -delete 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true

run:
	uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

build:
	docker build -t fastapi-pet-project .

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

