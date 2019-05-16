if [[ "$USE_CACHE_FROM" == "1" ]]; then
  CACHE_FROM_BUILD='--cache-from aimeeblue/ab-recorder-build-base:latest'
  CACHE_FROM_RUN='--cache-from aimeeblue/ab-recorder-run-base:latest'
else
  CACHE_FROM_BUILD=''
  CACHE_FROM_RUN=''
fi

echo \# USE_CACHE_FROM=$USE_CACHE_FROM
echo \# CACHE_FROM_BUILD=$CACHE_FROM_BUILD
echo \# CACHE_FROM_RUN=$CACHE_FROM_RUN

echo \# docker build $CACHE_FROM_BUILD --tag aimeeblue/ab-recorder-build-base:new -f 1.build-base.Dockerfile . 
docker build $CACHE_FROM_BUILD --tag aimeeblue/ab-recorder-build-base:new -f 1.build-base.Dockerfile . 

echo \# docker tag aimeeblue/ab-recorder-build-base:new aimeeblue/ab-recorder-build-base:latest
docker tag aimeeblue/ab-recorder-build-base:new aimeeblue/ab-recorder-build-base:latest

echo \# docker build $CACHE_FROM_RUN --tag aimeeblue/ab-recorder-run-base:new -f 2.run-base.Dockerfile . 
docker build $CACHE_FROM_RUN --tag aimeeblue/ab-recorder-run-base:new -f 2.run-base.Dockerfile . 

echo \# docker tag aimeeblue/ab-recorder-run-base:new aimeeblue/ab-recorder-run-base:latest
docker tag aimeeblue/ab-recorder-run-base:new aimeeblue/ab-recorder-run-base:latest

echo \# DONE
