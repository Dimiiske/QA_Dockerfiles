FROM continuumio/miniconda3:23.5.2-0-alpine

RUN apk update && \
    apk --no-cache add openjdk11 wget xvfb unzip make chromium chromium-chromedriver tzdata xsel xclip && \
    rm -rf /var/cache/apk/*

WORKDIR /app/
COPY . .

COPY https://github.com/aerokube/selenoid/releases/download/1.11.3/selenoid_linux_amd64 /app/selenoid

RUN wget https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.30.0/allure-commandline-2.30.0.zip && \
    unzip allure-commandline-2.30.0.zip -d /opt && \
    ln -s /opt/allure-2.30.0/bin/allure /usr/bin/allure && \
    rm allure-commandline-2.30.0.zip

RUN conda update -n base -c defaults conda && \
    conda env update -f environment.yml

RUN pip install -U pytest Pillow selenium allure-pytest pyperclip chromedriver_binary==112.0.5615.49.0

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

RUN mkdir -p /var/backups && \
    ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

COPY script.sh /app/
RUN chmod +x /app/script.sh /app/selenoid

ENV DISPLAY=:99

CMD ["/app/script.sh"]
