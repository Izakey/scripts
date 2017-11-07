#!/bin/bash
githubAccount=$1

# REM create core folder
mkdir -p core
cd core

get_modules() {
  for module in $@
  do
    git clone https://github.com/$githubAccount/$module.git
    cd $module
    git remote add upstream https://github.com/mifosio/$module.git
    # For some reason permission is denied
    chmod +x gradlew
    ./gradlew publishToMavenLocal
    cd ..
  done
}

get_modules lang async cassandra mariadb data-jpa 'command' api 'test'

# Return to start folder
cd ..

# REM create tools folder
mkdir tools
cd tools

# REM initialize javamoney
git clone https://github.com/JavaMoney/javamoney-lib.git
cd javamoney-lib
mvn install -Dmaven.test.skip=true

cd ..

# REM initialize crypto
git clone https://github.com/$githubAccount/crypto.git
cd crypto
git remote add upstream https://github.com/mifosio/crypto.git
chmod +x gradlew
./gradlew publishToMavenLocal
cd ..

# exit tools directory
cd ..


get_modules anubis permitted-feign-client provisioner identity rhythm template office customer group accounting portfolio deposit-account-management cheques payroll teller reporting

mkdir integration-tests
cd integration-tests

get_modules service-starter default-setup demo-server

# REM initialize Web App
git clone https://github.com/$githubAccount/fims-web-app.git
cd fims-web-app
git remote add upstream https://github.com/mifosio/fims-web-app.git
npm i

cd ..
