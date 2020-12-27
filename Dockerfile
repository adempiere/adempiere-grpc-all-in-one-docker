FROM adoptopenjdk/openjdk8:jre8u275-b01-alpine

LABEL	maintainer="ysenih@erpya.com; EdwinBetanc0urt@outlook.com" \
	description="ADempiere gRPC All In One Server used as ADempiere backend"

ARG	URL_REPO="https://github.com/adempiere/adempiere-gRPC-Server" \
	BASE_VERSION="rt-18.1" \
	BINARY_NAME="adempiere-gRPC-Server.zip"

# Init ENV with default values
ENV	BASE_VERSION=$BASE_VERSION \
	SERVER_PORT="50059" \
	DB_HOST="localhost" \
	DB_PORT="5432" \
	DB_NAME="adempiere" \
	DB_PASSWORD="adempiere" \
	DB_TYPE="PostgreSQL" \
	SERVER_LOG_LEVEL="WARNING"

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

# Add connection template
COPY all_in_one_connection.yaml /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml

WORKDIR /opt/Apps/ADempiere-gRPC-Server/bin/

# Set ENV in the connection file
CMD	sed -i "s|50059|$SERVER_PORT|g" all_in_one_connection.yaml && \
	sed -i "s|localhost|$DB_HOST|g" all_in_one_connection.yaml && \
	sed -i "s|5432|$DB_PORT|g" all_in_one_connection.yaml && \
	sed -i "s|adempieredb|$DB_NAME|g" all_in_one_connection.yaml && \
	sed -i "s|adempiereuser|$DB_USER|g" all_in_one_connection.yaml && \
	sed -i "s|adempierepass|$DB_PASSWORD|g" all_in_one_connection.yaml && \
	sed -i "s|PostgreSQL|$DB_TYPE|g" all_in_one_connection.yaml && \
	sed -i "s|WARNING|$SERVER_LOG_LEVEL|g" all_in_one_connection.yaml && \
	'sh' 'adempiere-all-in-one-server' 'all_in_one_connection.yaml'
