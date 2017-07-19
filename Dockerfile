FROM abuisine/nvidia:16.04-375.66

LABEL maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>"

ENV CCMINER_TPRUVOT_VERSION="v2.0-tpruvot"	

ENV BUILD_PACKAGES=" \
 git \
 ca-certificates \
 make \
 automake \
 autoconf \
 g++ \
 gcc \
 libssl-dev \
 libcurl4-openssl-dev \
 "

 # nvidia-cuda-toolkit \
 # nvidia-cuda-dev \

ENV PACKAGES=" \
 libcurl3 \
 libgomp1 \
 "
 # libcudart8.0 \

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
 && apt-get install --no-install-recommends -y ${BUILD_PACKAGES} ${PACKAGES} \
 && cd /tmp && git clone -b ${CCMINER_TPRUVOT_VERSION} --depth 1 https://github.com/tpruvot/ccminer.git

ADD https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb /tmp/
RUN apt-get install -y wget \
 && echo 'XKBMODEL="pc105"' >> /etc/default/keyboard \
 && echo 'XKBLAYOUT="us"' >> /etc/default/keyboard \
 && echo 'XKBVARIANT=""' >> /etc/default/keyboard \
 && echo 'XKBOPTIONS=""' >> /etc/default/keyboard \
 && echo 'BACKSPACE="guess"' >> /etc/default/keyboard \
 && apt-get install -y keyboard-configuration \
 && dpkg -i /tmp/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb \
 && apt-get update \
 && apt-get install cuda -y --no-install-recommends
# RUN cd /tmp/ccminer && ./build.sh && make install \
#  && apt-get -yqq remove --purge ${BUILD_PACKAGES} \
#  && apt-get -yqq autoremove \
#  && apt-get -yqq clean \
#  && rm -rf /var/lib/apt/lists/*

 # && apt-get -yqq remove --purge ${BUILD_PACKAGES} $(apt-mark showauto) \