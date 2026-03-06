#!/bin/bash

echo "----- ТЕСТИРОВАНИЕ ЛАБОРАТОРНОЙ РАБОТЫ №1 -----"
echo ""

# 1. Клонирование репозитория
echo "[1] Клонирование репозитория..."
if [ -d "progac3semlaba1" ]; then
    rm -rf progac3semlaba1
fi
git clone https://github.com/fallencrow19/progac3semlaba1.git
cd progac3semlaba1
echo "✓ Репозиторий склонирован"
echo ""

# 2. Проверка структуры репозитория
echo "[2] Проверка структуры репозитория..."
if [ -f "main.cpp" ]; then
    echo "✓ main.cpp найден"
else
    echo "✗ main.cpp не найден"
    exit 1
fi

if [ -d ".github/workflows" ]; then
    echo "✓ Папка .github/workflows найдена"
    if [ -f ".github/workflows/ci.yml" ]; then
        echo "✓ ci.yml найден"
        echo "   Содержит сборку для ОС:"
        grep "runs-on:" .github/workflows/ci.yml | sed 's/^/   - /'
    else
        echo "✗ ci.yml не найден"
    fi
else
    echo "✗ Папка .github/workflows не найдена"
fi
echo ""

# 3. Компиляция программы
echo "[3] Компиляция программы..."
g++ -o hello main.cpp 2> compile_error.log
if [ $? -eq 0 ]; then
    echo "✓ Компиляция успешна"
else
    echo "✗ Ошибка компиляции"
    cat compile_error.log
    exit 1
fi
echo ""

# 4. Запуск программы
echo "[4] Запуск программы:"
echo "---------------------"
./hello
echo "---------------------"
echo ""

# 5. Проверка вывода программы
echo "[5] Проверка формата вывода..."
OUTPUT=$(./hello)
if [[ $OUTPUT == "Hello, World! Version 1.0."* ]]; then
    echo "✓ Формат вывода корректен: $OUTPUT"
    
    # Извлекаем номер версии
    VERSION=$(echo $OUTPUT | grep -oP 'Version \K[0-9.]+')
    echo "   Версия программы: $VERSION"
else
    echo "✗ Неверный формат вывода. Ожидается: 'Hello, World! Version 1.0.N'"
    echo "  Получено: $OUTPUT"
fi
echo ""

# 6. Проверка тегов
echo "[6] Проверка тегов в репозитории..."
git fetch --tags
TAGS=$(git tag -l | sort -V)
if [ -n "$TAGS" ]; then
    echo "✓ Найдены теги:"
    echo "$TAGS" | sed 's/^/   - /'
    
    # Проверяем последний тег
    LATEST_TAG=$(git tag -l | sort -V | tail -n1)
    echo "   Последний тег: $LATEST_TAG"
else
    echo "✗ Теги не найдены"
fi
echo ""

# 7. Проверка .gitignore
echo "[7] Проверка .gitignore..."
if [ -f ".gitignore" ]; then
    echo "✓ .gitignore найден"
    echo "   Игнорируемые файлы:"
    cat .gitignore | grep -v "^#" | grep -v "^$" | sed 's/^/   - /'
else
    echo "✗ .gitignore не найден"
fi
echo ""

echo "----- ТЕСТИРОВАНИЕ ЗАВЕРШЕНО -----"