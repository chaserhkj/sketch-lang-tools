#!/bin/bash
# Build script for sketch-release

set -euxo pipefail

mkdir -p /build && cd /build
wget https://people.csail.mit.edu/asolar/sketch-$SKETCH_VERSION.tar.gz
tar -xv --no-same-owner -f sketch-$SKETCH_VERSION.tar.gz

cd sketch-$SKETCH_VERSION/sketch-backend
mkdir -p /install
./configure --prefix=/opt/sketch
make -j$(nproc)
make DESTDIR=/install install

cd ../sketch-frontend
install -m 755 sketch /install/opt/sketch/bin/
install -m 644 sketch-$SKETCH_VERSION-noarch.jar /install/opt/sketch/bin/
cp -r runtime /install/opt/sketch/
cp -r sketchlib /install/opt/sketch/

mkdir -p /install/usr/local/bin/
cat > /install/usr/local/bin/sketch << EOF
#!/bin/bash
#
# A wrapper launcher script for Sketch

export SKETCH_HOME=/opt/sketch/runtime
exec /opt/sketch/bin/sketch "$@"
EOF
chmod 755 /install/usr/local/bin/sketch