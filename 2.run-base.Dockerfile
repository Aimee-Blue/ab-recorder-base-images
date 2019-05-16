FROM node:10-slim as ab-recorder-run-base

ENV OPENCV_RUNTIME_DEPS='libjpeg62-turbo \
  libpng16-16 \
  libopenblas-base \
  libtbb2 \
  libwebp6 \
  libtiff5 \
  libopenexr22 \
  libglib2.0-0'

ENV RUNTIME_DEPS="${OPENCV_RUNTIME_DEPS} \
  v4l-utils \
  alsa-utils"

RUN apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends $RUNTIME_DEPS

COPY --from=aimeeblue/ab-recorder-build-base:latest /opt/opencv-install/lib* /usr/lib/
