# Docker với Flask

1. Cài đặt
    1. Dockerfile
        
        ```bash
        FROM python:3.6-alpine
        
        WORKDIR /app
        
        COPY . .
        
        RUN pip install -r requirements.txt
        
        CMD ["python", "app.py"]
        ```
        
    2. Build image
        
        ```bash
        $ docker build -t learning-docker/docker-flask:v1
        ```
        
    3. docker-compose.yml
        
        ```bash
        version: "3.7"
        
        services:
          flask-app:
            image: learning-docker/docker-flask:v1
            ports:
              - "5000:5000"
            restart: unless-stopped
        ```
        
    4. Run app on 0.0.0.0
        
        ```bash
        from flask import Flask, render_template
        
        app = Flask(__name__)
        
        @app.route("/")
        def hello():
            return render_template('index.html', title='Docker Python', name='James')
        
        if __name__ == "__main__":
            app.run(host="0.0.0.0")
        ```
        
2. Khác
    1. Biến môi trường ở Dockerfile
        - Mỗi lần thay đổi phải build lại image
        - app.py
            
            ```bash
            from flask import Flask, render_template
            import os
            
            app = Flask(__name__)
            
            @app.route("/")
            def hello():
                return render_template('index.html', title='Docker Python', name='James')
            
            if __name__ == "__main__":
                app.run(host="0.0.0.0", port=os.environ['PORT']) # Chạy project ở PORT nhận vào từ biến môi trường
            ```
            
        - Dockerfile
            
            ```bash
            FROM python:3.6-alpine
            
            WORKDIR /app
            
            # Tạo ra biến môi trường tên là PORT với giá trị 5555
            ENV PORT 5555
            
            COPY . .
            
            RUN pip install -r requirements.txt
            
            CMD ["python", "app.py"]
            ```
            
        - Sửa ports trong container thành 5555
            
            ```bash
            ports:
            	- "5000:5555"
            ```
            
    2. Biến môi trường ở docker-compose.yml
        - Mỗi khi sửa port phải sửa ở nhiều chỗ
        - docker-compose.yml
            
            ```bash
            version: "3.7"
            
            services:
              flask-app:
                image: learning-docker/docker-flask:v1
                ports:
                  - "5000:5555"
                restart: unless-stopped
                environment:
                  PORT: 5555
            ```
            
        - Build lại image
            
            ```bash
            $ docker build -t learning-docker/docker-flask:v1
            
            $ docker-compose down
            $ docker-compose up
            ```
            
    3. Biến môi trường với file .env
        - file .env
            
            ```bash
            PORT=8888
            PUBLIC_PORT=9999
            ```
            
        - docker-compose.yml
            
            ```bash
            version: "3.4"
            
            services:
              app:
                image: learning-docker/docker-flask
                ports:
                  - "${PUBLIC_PORT}:${PORT}"
                restart: unless-stopped
                environment:
                  PORT: ${PORT}
            ```
            
    4. remove image
        
        ```bash
        $ docker rmi <imageId>
        ```
        
3. Tài liệu tham khảo
    1. [https://viblo.asia/p/dockerize-ung-dung-python-flask-bWrZnxbY5xw](https://viblo.asia/p/dockerize-ung-dung-python-flask-bWrZnxbY5xw)
