#!/bin/bash

/app/selenoid -conf /app/browsers.json &

# display
Xvfb -ac :99 -screen 0 1280x1024x16 & 

# tests
make 

# notifications
cp -r ./allure-report/history ./allure-results/history
allure generate allure-results -o allure-report
java "-DconfigFile=/app/notifications/config-linux.json" -jar /app/notifications/allure-notification.jar

rm -rf ./allure-report # remove the report directory to generate the html file. If don't delete it - get an error

allure generate --single-file ./allure-results --clean
cp ./allure-report/index.html /var/backups/index.html
