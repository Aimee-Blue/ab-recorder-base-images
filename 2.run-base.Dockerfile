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

ENV TESTING_DISTRIB_DEPS="ffmpeg"

RUN echo 'APT::Default-Release "stable";' >> /etc/apt/apt.conf \
  && echo 'deb http://deb.debian.org/debian testing main' >> /etc/apt/sources.list \
  && echo 'deb-src http://deb.debian.org/debian testing main' >> /etc/apt/sources.list \
  && apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends $RUNTIME_DEPS \
  && apt-get -qq -t testing install -y --no-install-recommends $TESTING_DISTRIB_DEPS \
  && rm -rf /var/lib/apt/lists/* \
  && true

COPY --from=aimeeblue/ab-recorder-build-base:latest /opt/opencv-install/lib/lib* /usr/lib/
