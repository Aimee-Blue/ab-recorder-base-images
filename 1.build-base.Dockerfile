FROM node:16 as builder

ENV BUILD_DEPS='build-essential \
  unzip \
  cmake \
  clang \
  libclang-dev \
  python \
  libjpeg62-turbo \
  libjpeg62-turbo-dev \
  libpng-dev \
  libopenblas-dev \
  libtbb2 \
  libtbb-dev \
  pkg-config'

RUN apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends $BUILD_DEPS \
  && rm -rf /var/lib/apt/lists/* \
  && true

ENV OPENCV_VERSION=3.4.6

# Download OpenCV
RUN cd /opt && \
  wget -q https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
  unzip -qq ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip && \
  wget -q https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
  unzip -qq ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip

RUN cd /opt/opencv-${OPENCV_VERSION} && mkdir build && cd build && \
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_C_COMPILER=/usr/bin/clang \
  -D CMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -D CMAKE_INSTALL_PREFIX=/opt/opencv-install \
  -D BUILD_DOCS=OFF \
  -D BUILD_TESTS=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D BUILD_JAVA=OFF \
  -D BUILD_opencv_apps=OFF \
  -D BUILD_opencv_aruco=OFF \
  -D BUILD_opencv_bgsegm=OFF \
  -D BUILD_opencv_bioinspired=OFF \
  -D BUILD_opencv_ccalib=OFF \
  -D BUILD_opencv_datasets=OFF \
  -D BUILD_opencv_dnn_objdetect=OFF \
  -D BUILD_opencv_dpm=OFF \
  -D BUILD_opencv_fuzzy=OFF \
  -D BUILD_opencv_hfs=OFF \
  -D BUILD_opencv_java_bindings_generator=OFF \
  -D BUILD_opencv_js=OFF \
  -D BUILD_opencv_img_hash=OFF \
  -D BUILD_opencv_line_descriptor=OFF \
  -D BUILD_opencv_optflow=OFF \
  -D BUILD_opencv_phase_unwrapping=OFF \
  -D BUILD_opencv_python3=OFF \
  -D BUILD_opencv_python_bindings_generator=OFF \
  -D BUILD_opencv_reg=OFF \
  -D BUILD_opencv_rgbd=OFF \
  -D BUILD_opencv_saliency=OFF \
  -D BUILD_opencv_shape=OFF \
  -D BUILD_opencv_stereo=OFF \
  -D BUILD_opencv_stitching=OFF \
  -D BUILD_opencv_structured_light=OFF \
  -D BUILD_opencv_superres=OFF \
  -D BUILD_opencv_surface_matching=OFF \
  -D BUILD_opencv_ts=OFF \
  -D BUILD_opencv_xobjdetect=OFF \
  -D BUILD_opencv_xphoto=OFF \
  -D INSTALL_CREATE_DISTRIB=ON \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D INSTALL_C_EXAMPLES=OFF \
  -D WITH_CUDA=OFF \
  -D WITH_OPENGL=OFF \
  -D WITH_OPENCL=OFF \
  -D WITH_IPP=ON \
  -D WITH_TBB=ON \
  -D WITH_EIGEN=ON \
  -D WITH_V4L=ON \
  -D WITH_FFMPEG=ON \
  -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
  -D PYTHON_EXECUTABLE=/usr/local/bin/python \
  .. && \
  make -j$(nproc) && \
  make install

RUN cd /opt \
  && rm -rf /opt/opencv_contrib-${OPENCV_VERSION} \
  && rm -rf /opt/opencv-${OPENCV_VERSION} \
  && true

ENV OPENCV4NODEJS_DISABLE_AUTOBUILD=1 \
  OPENCV_INCLUDE_DIR='/opt/opencv-install/include' \
  OPENCV_LIB_DIR='/opt/opencv-install/lib' \
  OPENCV_BIN_DIR='/opt/opencv-install/bin' \
  CC=clang \
  CXX=clang++
