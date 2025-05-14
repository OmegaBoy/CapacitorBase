FROM  debian:bookworm

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libfontconfig1 \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    python3 \
    python3-pip \
    wget \
    unzip \
    zip \
    gradle \
    lib32stdc++6 \
    lib32z1 \
    && apt-get clean

RUN apt install default-jre -y && \
    apt install default-jdk -y

# Set environment variables for Java
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT} .android && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/ && \
    rm cmdline-tools.zip && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools-tmp && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools-tmp ${ANDROID_SDK_ROOT}/cmdline-tools/latest

ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:${PATH}"
ENV ANDROID_HOME=/opt/android-sdk

# Accept licenses and install SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs \
    build-essential && \
    node --version && \ 
    npm --version

RUN npm install -g @quasar/cli && \
    npm install -g @vue/cli && \
    npm install -g @vue/cli-init

RUN mkdir /home/app

# VOLUME [ "/home/node/app" ]
WORKDIR /home/app

CMD ["/bin/bash"]