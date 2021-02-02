FROM adoptopenjdk/openjdk8:jre8u275-b01-alpine

LABEL	maintainer="ysenih@erpya.com; EdwinBetanc0urt@outlook.com" \
	description="ADempiere gRPC All In One Server used as ADempiere backend"

ARG BASE_VERSION="rt-19.1"
ARG URL_REPO="https://github.com/adempiere/adempiere-gRPC-Server"
ARG BINARY_NAME="adempiere-gRPC-Server.zip"

# Init ENV with default values
ENV	BASE_VERSION=$BASE_VERSION \
	SERVER_PORT="50059" \
	SERVICES_ENABLED="access; business; core; dashboarding; dictionary; enrollment; log; ui; workflow; store; pos;" \
	SERVER_LOG_LEVEL="WARNING" \
	DB_HOST="localhost" \
	DB_PORT="5432" \
	DB_NAME="adempiere" \
	DB_USER="adempiere" \
	DB_PASSWORD="adempiere" \
	DB_TYPE="PostgreSQL"

# Add system dependencies
RUN	echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
	echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories && \
	echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories && \
	rm -rf /var/cache/apk/* && \
	apk update && \
	apk add --virtual .build-deps \
	 	ca-certificates \
	 	curl && \
	apk add \
		bash \
	 	fontconfig \
		ttf-dejavu

# Download and uncompress project
RUN	mkdir -p /opt/Apps && \
	cd /opt/Apps && \
	curl --output "$BINARY_NAME" \
		-L "$URL_REPO/releases/download/$BASE_VERSION/$BINARY_NAME" && \
	unzip -o $BINARY_NAME && \
	mv adempiere-gRPC-Server ADempiere-gRPC-Server && \
	rm $BINARY_NAME && \
	apk del .build-deps && \
	rm -rf /var/cache/apk/* \
		/var/lib/apt/list/* \
		/tmp/*

# Add connection template and start script files
COPY "all_in_one_connection.yaml" "start.sh" "/opt/Apps/ADempiere-gRPC-Server/bin/"

WORKDIR /opt/Apps/ADempiere-gRPC-Server/bin/

# Start app
CMD	'sh' 'start.sh'
