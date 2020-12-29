FROM openjdk:8-jre-alpine

LABEL maintainer="ysenih@erpya.com; EdwinBetanc0urt@outlook.com" \
	description="ADempiere gRPC All In One Server used as ADempiere backend"

# Init ENV with default values
ENV	URL_REPO="https://github.com/adempiere/adempiere-gRPC-Server" \
	BASE_VERSION="rt-18.1" \
	BINARY_NAME="adempiere-gRPC-Server.zip" \
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

# Add connection template and start script files
COPY "all_in_one_connection.yaml" "start.sh" "/opt/Apps/ADempiere-gRPC-Server/bin/"

WORKDIR /opt/Apps/ADempiere-gRPC-Server/bin/

# Start app
CMD	'sh' 'start.sh'
