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
download "https://artifactory.cronapp.io/public-release/com/google/code/gson/gson-extras/2.8.5/gson-extras-2.8.5.jar" lib/gson-extras-2.8.5.jar \
    "df7a03bf8d1fc010e237a98de6479adc430c08f63e1848071dc63ff08f259f91"
download "https://repo1.maven.org/maven2/javax/annotation/jsr250-api/1.0/jsr250-api-1.0.jar" lib/jsr250-api-1.0.jar \
    "a1a922d0d9b6d183ed3800dfac01d1e1eb159f0e8c6f94736931c1def54a941f"
download "https://repo1.maven.org/maven2/org/reflections/reflections/0.10.2/reflections-0.10.2.jar" lib/reflections-0.10.2.jar \
    "938a2d08fe54050d7610b944d8ddc3a09355710d9e6be0aac838dbc04e9a2825"