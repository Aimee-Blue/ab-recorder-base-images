docker login -u=$DOCKER_USERNAME -p=$DOCKER_PASSWORD \
    && docker push aimeeblue/ab-recorder-build-base \
    && docker push aimeeblue/ab-recorder-run-base
