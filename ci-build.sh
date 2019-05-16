if [[ "$USE_CACHE_FROM" == "1" ]]; then
  CACHE_FROM_BUILD='--cache-from aimeeblue/ab-recorder-build-base:latest'
  CACHE_FROM_RUN='--cache-from aimeeblue/ab-recorder-run-base:latest'
else
  CACHE_FROM_BUILD=''
  CACHE_FROM_RUN=''
fi

echo \# Settings: 
echo \# USE_CACHE_FROM'   '= $USE_CACHE_FROM '(set to 1 to use --cache-from)'
echo \# CACHE_FROM_BUILD' '= $CACHE_FROM_BUILD
echo \# CACHE_FROM_RUN'   '= $CACHE_FROM_RUN

BUILD_BASE="docker build $CACHE_FROM_BUILD --tag aimeeblue/ab-recorder-build-base:new -f 1.build-base.Dockerfile ."
TAG_BASE="docker tag aimeeblue/ab-recorder-build-base:new aimeeblue/ab-recorder-build-base:latest"
BUILD_RUN="docker build $CACHE_FROM_RUN --tag aimeeblue/ab-recorder-run-base:new -f 2.run-base.Dockerfile ."
TAG_RUN="docker tag aimeeblue/ab-recorder-run-base:new aimeeblue/ab-recorder-run-base:latest"

echo \# 🚀 $BUILD_BASE \
  && $BUILD_BASE \
  && echo \# 🚀 $TAG_BASE \
  && $TAG_BASE \
  && echo \# 🚀 $BUILD_RUN \
  && $BUILD_RUN \
  && echo \# 🚀 $TAG_RUN \
  && $TAG_RUN \
  && echo \# ✅ - Done \
  && true
