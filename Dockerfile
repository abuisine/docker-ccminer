FROM abuisine/nvidia:16.04-375.66

LABEL maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>"

ENV CCMINER_TPRUVOT_VERSION="v2.0-tpruvot" CUDA_VERSION="8.0.61-1"

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

ENV PACKAGES=" \
 libcurl3 \
 libgomp1 \
 "

COPY resources/cuda-8.0-light/ /usr/local/share/cuda-8.0
RUN ln -s /usr/local/share/cuda-8.0 /usr/local/share/cuda \
 && echo "/usr/local/share/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf \
 && ldconfig

RUN echo 'XKBMODEL="pc105"' >> /etc/default/keyboard \
 && echo 'XKBLAYOUT="us"' >> /etc/default/keyboard \
 && echo 'XKBVARIANT=""' >> /etc/default/keyboard \
 && echo 'XKBOPTIONS=""' >> /etc/default/keyboard \
 && echo 'BACKSPACE="guess"' >> /etc/default/keyboard \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq update \
 && apt-get install --no-install-recommends -y ${BUILD_PACKAGES} ${PACKAGES} \
 && cd /tmp && git clone -b ${CCMINER_TPRUVOT_VERSION} --depth 1 https://github.com/tpruvot/ccminer.git \
 && cd ccminer \
 && PATH=$PATH:/usr/local/share/cuda/bin/ CPATH=$CPATH:/usr/local/share/cuda/include/ LIBRARY_PATH=/usr/local/share/cuda/lib64/ ./build.sh \
 && make install \
 && apt-get -yqq remove --purge ${BUILD_PACKAGES} \
 && apt-get -yqq autoremove \
 && apt-get -yqq clean \
 && rm -rf /var/lib/apt/lists/*

 # && apt-get -yqq remove --purge ${BUILD_PACKAGES} $(apt-mark showauto) \