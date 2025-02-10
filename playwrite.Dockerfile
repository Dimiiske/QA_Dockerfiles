FROM node:18

WORKDIR /usr/src/app
COPY . .

RUN apt-get update && \
    apt-get -y install default-jdk wget unzip locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    npm install -g allure-commandline --save-dev && \
    npm ci && npm install @playwright/browser-chromium && \
    npx playwright install && \ 
    npx playwright install-deps && \
    npm cache clean --force && \
    chmod +x script.sh

RUN sed -i -e \
    's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU:ru
ENV LC_LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

CMD [/usr/src/app/script.sh]
