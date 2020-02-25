# Docker Android Build Box
[![docker icon](https://dockeri.co/image/lenigauffier/ionic-android)](https://hub.docker.com/r/lenigauffier/ionic-android)
[![Build Status](https://travis-ci.com/legau/docker-ionic-android.svg?branch=master)](https://travis-ci.com/legau/docker-ionic-android)


## Introduction

An optimized **docker** image for **Ionic Android Development** targeted to be used in CICD. From [Android Build Box by mingchen](https://github.com/mingchen/docker-android-build-box)

## What Is Inside

It includes the following components:

* Ubuntu 18.04
* Android SDK 19 20 21 22 23 24 25 26 27 28 29
* Android build tools:
  * 29.0.2
* Python 2, Python 3
* Ionic@5.4.4
* Cordova


## Pull Docker Image

The docker image is publicly automated build on [Docker Hub](https://hub.docker.com/r/lenigauffier/ionic-android) 
based on the Dockerfile in this repo, so there is no hidden stuff in it. To pull the latest docker image:

    docker pull lenigauffier/ionic-android:latest


### Use the image for a Gitlab pipeline

Here is an example of `.gitlab-ci.yml`

    cache:
      key: "$CI_COMMIT_REF_NAME"
      paths:
        - node_modules/
    stages:
      - build 
    build: 
      stage: build
      image: lenigauffier/ionic-android:latest
      variables:
          FILE_TYPE: apk
          OUTPUT_PATH: platforms/android/app/build/outputs/apk/debug/app-debug
      script:
        - ionic cordova build android --production
        - cp $OUTPUT_PATH.$FILE_TYPE $CI_PROJECT_NAME-$CI_COMMIT_REF_SLUG.$FILE_TYPE
      artifacts:
        name:
        paths:
            - $CI_PROJECT_NAME-$CI_COMMIT_REF_SLUG.$FILE_TYPE
        expire_in: 7 days
      
## Docker Build Image

    docker build -t ionic-android .

## Contribution

If you want to enhance this docker image or fix something, feel free to send [pull request](https://github.com/legau/docker-ionic-android/pull/new/master).


## References

* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
* [Build your own image](https://docs.docker.com/engine/getstarted/step_four/)
* [uber android build environment](https://hub.docker.com/r/uber/android-build-environment/)
* [Refactoring a Dockerfile for image size](https://blog.replicated.com/refactoring-a-dockerfile-for-image-size/)

