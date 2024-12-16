# 使用官方Python基础映像
FROM python:3.9-slim

# 设置工作目录
WORKDIR /app

# 复制当前目录内容到工作目录
COPY . /app

# 安装系统依赖（例如Chrome和相关工具）
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libnss3 \
    libgconf-2-4 \
    && apt-get clean

# 下载并安装Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install

# 安装ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+') \
    && wget -q https://chromedriver.storage.googleapis.com/${CHROME_VERSION}/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip -d /usr/local/bin/ \
    && rm chromedriver_linux64.zip

# 安装Python依赖
RUN pip install --no-cache-dir drissionpage flask

# 暴露应用服务端口
EXPOSE 5000

# 使用环境变量指定要运行的脚本，默认值为'app.py'
CMD ["python", "${SCRIPT_NAME:-app.py}"]
