FROM ubuntu:18.04 as builder
LABEL MAINTAINER="twxl1993 <twxl1993@gmail.com>"

ARG USEMIRROR=

RUN [ x"$USEMIRROR" = x"y" ] && \
    sed -i -r 's/[0-9a-z]+\.ubuntu\.com/mirrors.aliyun.com/' /etc/apt/sources.list; \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends python-dev git python-pip; \
    git clone https://github.com/haiwen/seafile-rpi.git; \
    cp -f /seafile-rpi/build.sh /; rm -rf /seafile-rpi; \
    [ x"$USEMIRROR" = x"y" ] && \
      sed -i -e "s@pip install @pip install -i https://mirrors.aliyun.com/pypi/simple @" \
          -e "s@easy_install @easy_install -i https://mirrors.aliyun.com/pypi/simple @" \
          -e "s@https://github.com/haiwen@/mirrors@" \
          -e "s@https://www.github.com/haiwen@/mirrors@" \
	  /build.sh; \
    cat /build.sh

WORKDIR /

VOLUME ["/seafile-server-pkgs"]

ENTRYPOINT ["/build.sh"]
