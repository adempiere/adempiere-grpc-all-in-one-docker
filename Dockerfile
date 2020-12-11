FROM openjdk:8-jre-alpine

LABEL maintainer="ysenih@erpya.com; EdwinBetanc0urt@outlook.com" \
	description="ADempiere gRPC All In One Server used as ADempiere backend"

# Init ENV with default values
ENV	URL_REPO="https://github.com/adempiere/adempiere-gRPC-Server" \
	BASE_VERSION="rt-18.0" \
	BINARY_NAME="adempiere-gRPC-Server.zip" \
	SERVER_PORT="50059" \
	DB_HOST="localhost" \
	DB_PORT="5432" \
	DB_NAME="adempiere" \
	DB_PASSWORD="adempiere" \
	DB_TYPE="PostgreSQL" \
	SERVER_LOG_LEVEL="WARNING"

# Add system dependencies
RUN	echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
	echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories && \
	apk update && \
	apk add --no-cache \
		bash \
		ca-certificates \
		curl \
		fontconfig \
		ttf-dejavu

# Download and uncompress project
RUN	mkdir -p /opt/Apps && \
	cd /opt/Apps && \
	curl --output "$BINARY_NAME" \
		-L "$URL_REPO/releases/download/$BASE_VERSION/$BINARY_NAME" && \
	unzip -o $BINARY_NAME && \
	mv adempiere-gRPC-Server ADempiere-gRPC-Server && \
	rm $BINARY_NAME

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
