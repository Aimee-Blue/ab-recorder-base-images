FROM node:16-slim as ab-recorder-run-base-snips

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
  alsa-utils \
  pulseaudio-utils \
  procps \
  curl \
  libudev-dev \
  libusb-1.0-0-dev \
  udev \
  usbutils \
  ffmpeg \
  zip"

ENV TZ='Australia/Sydney'

ENV SNIPS_DEPS='snips-platform-demo \
  snips-platform-voice \
  snips-watch \
  snips-skill-server \
  snips-template'

ENV CLEANUP_DEPS="curl dirmngr apt-transport-https gnupg ca-certificates"

RUN apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends dirmngr apt-transport-https gnupg ca-certificates \
  && bash -c  'echo "deb https://debian.snips.ai/stretch stable main" > \
    /etc/apt/sources.list.d/snips.list' \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F727C778CCB0A455 \
  && apt-key adv --fetch-keys  https://debian.snips.ai/5FFCD0DEB5BA45CD.pub \
  && apt-get -qq update \
  && apt-get -qq install -y $SNIPS_DEPS \
  && apt-get -qq install -y --no-install-recommends $RUNTIME_DEPS \
  && curl -L https://github.com/krallin/tini/releases/download/v0.18.0/tini -o /etc/tini \
  && chmod +x /etc/tini \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && apt-get -qq purge -y $CLEANUP_DEPS \
  && rm -rf /var/lib/apt/lists/* \
  && true

COPY --from=aimeeblue/ab-recorder-build-base:latest /opt/opencv-install/lib/lib* /usr/lib/

ENTRYPOINT ["/etc/tini", "--"]