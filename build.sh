#!/bin/sh
set -e

USEMIRROR=y

name=twxl1993/seafile-build

gendir() {
	if [ "${1:0-4:4}" == ".git" ]; then
		echo $1
	else
		echo $1.git
	fi
}

if [ x"$USEMIRROR" = x"y" ]; then
	LIST="\
		https://github.com/haiwen/libevhtp.git \
		https://github.com/haiwen/libsearpc.git \
		https://github.com/haiwen/ccnet-server.git \
		https://github.com/haiwen/seafile-server.git \
		https://github.com/haiwen/seahub.git \
		https://github.com/haiwen/seafobj.git \
		https://github.com/haiwen/seafdav.git \
		"
	for repo in $LIST; do
		dir="mirrors/`basename ${repo}`"
		dir="`gendir $dir`"
		if [ ! -d "$dir" ]; then
			git clone --mirror "$repo" "$dir"
		fi
		git -C "$dir" remote update
	done

	BUILD_OPTS="--build-arg USEMIRROR=$USEMIRROR"
	RUN_OPTS="-v $PWD/mirrors:/mirrors"
fi

if ! docker images | grep ^$name > /dev/null; then
	docker build ${BUILD_OPTS} -f Dockerfile.builder \
        -t twxl1993/seafile-build .
fi
docker run --rm -it ${RUN_OPTS} \
    -v $PWD/seafile-server-pkgs:/seafile-server-pkgs \
    --name seafile-build twxl1993/seafile-build

