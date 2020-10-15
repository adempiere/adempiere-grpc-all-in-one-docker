FROM openjdk:8-jre-alpine

LABEL maintainer="ysenih@erpya.com; EdwinBetanc0urt@outlook.com" \
	description="ADempiere gRPC All In One Server"

ENV URL_REPO="https://github.com/erpcya/adempiere-gRPC-Server" \
	BASE_VERSION="rt-16.0" \
	BINARY_NAME="adempiere-gRPC-Server.zip"

RUN	mkdir -p /opt/Apps && \
	cd /opt/Apps && \
	apk --no-cache add curl && \
	curl --output "$BINARY_NAME" \
		-L "$URL_REPO/releases/download/$BASE_VERSION/$BINARY_NAME" && \
	unzip -o $BINARY_NAME && \
	mv adempiere-gRPC-Server ADempiere-gRPC-Server && \
	rm $BINARY_NAME

# Add connection template
COPY all_in_one_connection.yaml /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml

WORKDIR /opt/Apps/ADempiere-gRPC-Server/bin/

CMD 'sh' 'adempiere-all-in-one-server' 'all_in_one_connection.yaml'
