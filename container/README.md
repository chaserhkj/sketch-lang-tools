# Containers for sketch

Containers build files for the Sketch tool.

[sketch-build](sketch-build) contains a complete build environment capable of compiling both the sketch backend and the sketch frontend.

> This container provided a script `patch-frontend` in PATH to patch the sketch frontend build configurations so that a self-contained jar file could be assembled from the source code.

[sketch-release](sketch-release) is a ready-to-use container of the release version of the sketch tool.
