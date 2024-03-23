#!/bin/bash
set -e

download() {
    if [ -f $2 ] && sha256sum -c <(echo "$3  -") <$2
    then
        echo "$2 is valid"
    else
        rm -f $2
        curl -s -L $1 | tee $2 | sha256sum -c <(echo "$3  -") || { rm -f $2; echo "Fail to validate download"; exit 1; }
    fi
}

cd $(dirname $0)
mkdir -p lib
download "https://repo1.maven.org/maven2/com/google/code/gson/gson/2.8.5/gson-2.8.5.jar" lib/gson-2.8.5.jar \
    "233a0149fc365c9f6edbd683cfe266b19bdc773be98eabdaf6b3c924b48e7d81"