FROM ubuntu:18.04

ENV ANDROID_SDK_ROOT="/opt/android-sdk" \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/" \
    GRADLE_HOME="/usr/share/gradle"

# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_TOOLS_VERSION="4333796"

# nodejs version
ENV NODE_VERSION="10.x"

ENV IONIC_VERSION="5.4.4"

# Set locale
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

RUN apt-get clean && apt-get update -qq && apt-get install -qq -y apt-utils locales && locale-gen $LANG

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM=dumb \
    DEBIAN_FRONTEND=noninteractive

# Variables must be references after they are created
ENV ANDROID_SDK_HOME="$ANDROID_SDK_ROOT"

ENV PATH="$PATH:$ANDROID_SDK_HOME/tools/bin:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$GRADLE_HOME/bin"

WORKDIR /tmp

# Installing packages
RUN apt-get update -qq > /dev/null && \
    apt-get install -qq locales > /dev/null && \
    locale-gen "$LANG" > /dev/null && \
    apt-get install -qq --no-install-recommends \
        build-essential \
        autoconf \
        curl \
        git \
        file \
        less \
        gpg-agent \
        lib32stdc++6 \
        lib32z1 \
        lib32z1-dev \
        lib32ncurses5 \
        libc6-dev \
        libgmp-dev \
        libmpc-dev \
        libmpfr-dev \
        libxslt-dev \
        libxml2-dev \
        m4 \
        ncurses-dev \
        openjdk-8-jdk \
        openssh-client \
        pkg-config \
        ruby-full \
        software-properties-common \
        unzip \
        wget \
        zip \
        zlib1g-dev > /dev/null && \
    curl -sL -k https://deb.nodesource.com/setup_${NODE_VERSION} \
        | bash - > /dev/null && \
    apt-get install -qq nodejs > /dev/null && \
    apt-get clean > /dev/null && \
    rm -rf /var/lib/apt/lists/ && \
    npm install --quiet -g npm > /dev/null && \
    npm install --quiet -g \
        cordova ionic@${IONIC_VERSION} > /dev/null && \
    npm cache clean --force > /dev/null && \
    rm -rf /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y gradle && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

# Install Android SDK
RUN echo "Installing sdk tools ${ANDROID_SDK_TOOLS_VERSION}" && \
    wget --quiet --output-document=sdk-tools.zip \
        "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip" && \
    mkdir --parents "$ANDROID_SDK_ROOT" && \
    unzip -q sdk-tools.zip -d "$ANDROID_SDK_ROOT" && \
    rm --force sdk-tools.zip && \
# Install SDKs
# Please keep these in descending order!
# The `yes` is for accepting all non-standard tool licenses.
    mkdir --parents "$ANDROID_SDK_ROOT/.android/" && \
    echo '### User Sources for Android SDK Manager' > \
        "$ANDROID_SDK_ROOT/.android/repositories.cfg" && \
    yes | "$ANDROID_SDK_ROOT"/tools/bin/sdkmanager --licenses > /dev/null && \
    echo "Installing platforms" && \
    yes | "$ANDROID_SDK_ROOT"/tools/bin/sdkmanager \
        "platforms;android-29" \
        "platforms;android-28" \
        "platforms;android-27" \
        "platforms;android-26" \
        "platforms;android-25" \
        "platforms;android-24" \
        "platforms;android-23" \
        "platforms;android-22" \
        "platforms;android-21" \
        "platforms;android-20" \
        "platforms;android-19" > /dev/null && \
    echo "Installing platform tools " && \
    yes | "$ANDROID_SDK_ROOT"/tools/bin/sdkmanager \
        "platform-tools" > /dev/null && \
    echo "Installing build tools " && \
    yes | "$ANDROID_SDK_ROOT"/tools/bin/sdkmanager \
        "build-tools;29.0.2" > /dev/null && \
    echo "Installing extras " && \
    yes | "$ANDROID_SDK_ROOT"/tools/bin/sdkmanager \
        "extras;android;m2repository" \
        "extras;google;m2repository" > /dev/null
# Copy sdk license agreement files.
RUN mkdir -p $ANDROID_SDK_ROOT/licenses
COPY sdk/licenses/* $ANDROID_SDK_ROOT/licenses/

# Create some jenkins required directory to allow this image run with Jenkins
RUN mkdir -p /var/lib/jenkins/workspace
RUN mkdir -p /home/jenkins
RUN chmod 777 /home/jenkins
RUN chmod 777 /var/lib/jenkins/workspace
RUN chmod 777 $ANDROID_SDK_ROOT/.android