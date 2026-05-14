FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

# Чекаємо БД, робимо міграції, запускаємо сервер
ENTRYPOINT ["sh", "-c", "while ! python -c 'import socket; socket.create_connection((\"db\", 3306), timeout=2)' 2>/dev/null; do echo 'Waiting for MySQL...'; sleep 2; done && python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
