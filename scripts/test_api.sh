#!/bin/bash

# Скрипт для тестирования API эндпоинтов

set -e

API_URL="${API_URL:-http://localhost:8000}"

echo "🧪 Testing FastAPI Pet Project API"
echo "📍 API URL: $API_URL"
echo ""

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для проверки ответа
check_response() {
    local name="$1"
    local response="$2"
    local expected_code="$3"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $name - OK"
        return 0
    else
        echo -e "${RED}✗${NC} $name - FAILED"
        return 1
    fi
}

# Счетчик тестов
passed=0
failed=0

echo "1️⃣  Testing root endpoint..."
response=$(curl -s -w "\n%{http_code}" "$API_URL/")
status_code=$(echo "$response" | tail -n1)
if [ "$status_code" = "200" ]; then
    check_response "GET /" "$response" 200
    ((passed++))
else
    echo -e "${RED}✗${NC} GET / - FAILED (HTTP $status_code)"
    ((failed++))
fi

echo ""
echo "2️⃣  Testing health check..."
response=$(curl -s -w "\n%{http_code}" "$API_URL/health")
status_code=$(echo "$response" | tail -n1)
if [ "$status_code" = "200" ]; then
    check_response "GET /health" "$response" 200
    ((passed++))
else
    echo -e "${RED}✗${NC} GET /health - FAILED (HTTP $status_code)"
    ((failed++))
fi

echo ""
echo "3️⃣  Creating a new task..."
response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/tasks" \
    -H "Content-Type: application/json" \
    -d '{"title": "Test Task", "description": "Testing API"}')
status_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n-1)

if [ "$status_code" = "201" ]; then
    check_response "POST /tasks" "$response" 201
    task_id=$(echo "$body" | python3 -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")
    echo "   Task ID: $task_id"
    ((passed++))
else
    echo -e "${RED}✗${NC} POST /tasks - FAILED (HTTP $status_code)"
    ((failed++))
    task_id=""
fi

echo ""
echo "4️⃣  Getting all tasks..."
response=$(curl -s -w "\n%{http_code}" "$API_URL/tasks")
status_code=$(echo "$response" | tail -n1)
if [ "$status_code" = "200" ]; then
    check_response "GET /tasks" "$response" 200
    ((passed++))
else
    echo -e "${RED}✗${NC} GET /tasks - FAILED (HTTP $status_code)"
    ((failed++))
fi

if [ -n "$task_id" ]; then
    echo ""
    echo "5️⃣  Getting task by ID..."
    response=$(curl -s -w "\n%{http_code}" "$API_URL/tasks/$task_id")
    status_code=$(echo "$response" | tail -n1)
    if [ "$status_code" = "200" ]; then
        check_response "GET /tasks/{id}" "$response" 200
        ((passed++))
    else
        echo -e "${RED}✗${NC} GET /tasks/{id} - FAILED (HTTP $status_code)"
        ((failed++))
    fi

    echo ""
    echo "6️⃣  Updating task..."
    response=$(curl -s -w "\n%{http_code}" -X PUT "$API_URL/tasks/$task_id" \
        -H "Content-Type: application/json" \
        -d '{"completed": true}')
    status_code=$(echo "$response" | tail -n1)
    if [ "$status_code" = "200" ]; then
        check_response "PUT /tasks/{id}" "$response" 200
        ((passed++))
    else
        echo -e "${RED}✗${NC} PUT /tasks/{id} - FAILED (HTTP $status_code)"
        ((failed++))
    fi

    echo ""
    echo "7️⃣  Deleting task..."
    response=$(curl -s -w "\n%{http_code}" -X DELETE "$API_URL/tasks/$task_id")
    status_code=$(echo "$response" | tail -n1)
    if [ "$status_code" = "200" ]; then
        check_response "DELETE /tasks/{id}" "$response" 200
        ((passed++))
    else
        echo -e "${RED}✗${NC} DELETE /tasks/{id} - FAILED (HTTP $status_code)"
        ((failed++))
    fi
fi

echo ""
echo "8️⃣  Testing statistics..."
response=$(curl -s -w "\n%{http_code}" "$API_URL/stats")
status_code=$(echo "$response" | tail -n1)
if [ "$status_code" = "200" ]; then
    check_response "GET /stats" "$response" 200
    ((passed++))
else
    echo -e "${RED}✗${NC} GET /stats - FAILED (HTTP $status_code)"
    ((failed++))
fi

echo ""
echo "9️⃣  Testing 404 error..."
response=$(curl -s -w "\n%{http_code}" "$API_URL/tasks/nonexistent-id")
status_code=$(echo "$response" | tail -n1)
if [ "$status_code" = "404" ]; then
    check_response "GET /tasks/{invalid_id} (404)" "$response" 404
    ((passed++))
else
    echo -e "${RED}✗${NC} GET /tasks/{invalid_id} - FAILED (Expected 404, got $status_code)"
    ((failed++))
fi

# Итоги
echo ""
echo "════════════════════════════════════════"
echo "📊 Test Results:"
echo "   Passed: ${GREEN}$passed${NC}"
echo "   Failed: ${RED}$failed${NC}"
echo "   Total:  $((passed + failed))"
echo "════════════════════════════════════════"

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✨ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed!${NC}"
    exit 1
fi

