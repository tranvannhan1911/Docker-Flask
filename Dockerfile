FROM python:3.6-alpine

WORKDIR /app

# Tạo ra biến môi trường tên là PORT với giá trị 5555
# ENV PORT 5555

COPY . .

RUN pip install -r requirements.txt

CMD ["python", "app.py"]