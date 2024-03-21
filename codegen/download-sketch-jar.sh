#!/bin/bash
set -e

JAR_PATH=sketch-1.7.6-noarch.jar
JAR_CHECKSUM="e4180c70f3d81cf1df88f3f768b2f9b79372970f6ef132aefa5abf2b4ac2b415"
TAR_PATH=sketch-1.7.6.tar.gz
TAR_CHECKSUM="5cdac9ce841fd532215ff9ad8cb61a38cbdf6de0a635a669d0e46cdae72da707"
TAR_URL=https://people.csail.mit.edu/asolar/sketch-1.7.6.tar.gz
JAR_IN_TAR=sketch-1.7.6/sketch-frontend/sketch-1.7.6-noarch.jar
JAR_IN_TAR_PREFIX=2

cd $(dirname $0)
if [ -f $JAR_PATH ] && sha256sum -c <(echo "$JAR_CHECKSUM  -") <$JAR_PATH
then
    echo "$JAR_PATH is valid"
    exit
fi
rm -f $JAR_PATH
if [ -f $TAR_PATH ] && sha256sum -c <(echo "$TAR_CHECKSUM  -") <$TAR_PATH
then
    echo "$TAR_PATH is valid"
else
    rm -f $TAR_PATH
    curl -s -L $TAR_URL | tee $TAR_PATH | sha256sum -c <(echo "$TAR_CHECKSUM  -") || { rm -f $TAR_PATH; echo "Fail to validate download"; exit 1; }
fi
tar -xf $TAR_PATH --strip-components $JAR_IN_TAR_PREFIX $JAR_IN_TAR
