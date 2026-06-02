#!/bin/bash

IMAGE_NAME="my-secure-app:latest"

echo "⏳ Починаємо збірку Docker-образу: $IMAGE_NAME..."
sudo docker build -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
    echo "❌ Помилка: Збірка образу провалилася. Перевір Dockerfile!"
    exit 1
fi

echo "✅ Збірка успішна! Запускаємо перевірку безпеки через Trivy..."


sudo trivy image --exit-code 1 --severity HIGH,CRITICAL $IMAGE_NAME

if [ $? -eq 0 ]; then
    echo "✅ ПЕРЕВІРКА ПРОЙДЕНА: Критичних вразливостей не знайдено. Образ готовий до деплою!"
else
    echo "🚨 УВАГА: Trivy знайшов небезпечні вразливості! Деплой заблоковано."
    exit 1
fi
