ADempiere Access gRPC Docker Server
=====================

[Docker](https://www.docker.io/) file for trusted builds of [ADempiere gRPC Deploy](http://erpya.com/) on https://hub.docker.com/r/erpya/adempiere-grpc-all-in-one.

You will need use a file with a structure like it: [all_in_one_connection.yaml](all_in_one_connection.yaml)

```yaml
server:
    port: 50059
    services:
       -   access
       -   business
       -   core
       -   dashboarding
       -   dictionary
       -   enrollment
       -   log
       -   ui
       -   workflow
       -   store
database:
    host: localhost
    port: 5432
    name: adempiere
    user: adempiere
    password: adempiere
    type: PostgreSQL
```

### For all enviroment you should run the follow images:
- ADempiere gRPC: https://hub.docker.com/r/erpya/adempiere-grpc-all-in-one
```shell
docker pull erpya/adempiere-grpc-all-in-one
```
- Proxy ADempiere API: https://hub.docker.com/r/erpya/proxy-adempiere-api
```shell
docker pull erpya/proxy-adempiere-api
```
- ADempiere Vue: https://hub.docker.com/r/erpya/adempiere-vue
```shell
docker pull erpya/adempiere-vue
```

Download docker image:
```shell
    docker pull erpya/adempiere-grpc-all-in-one
```

Run with default connection:
```shell
docker run -d \
    -it \
    --name adempiere-grpc-all-in-one \
	-p 50059:50059 \
	erpya/adempiere-grpc-all-in-one
```

Run with custom connection:
```shell
docker run -d \
    -it \
    --name adempiere-grpc-all-in-one \
    -p 50059:50059 \
    -e "SERVER_PORT=50059" \
    -e "DB_HOST=Your-Database-Server-Address" \
    -e "DB_NAME=Your-Database-Name" \
    -e "DB_USER=Your-Database-User" \
    -e "DB_PASSWORD=Your-Database-Password" \
    -e "DB_TYPE=Your-Database-Type" \
    erpya/adempiere-grpc-all-in-one
```

## Environment variables for the configuration

 * `SERVER_PORT`: Indicates the port on which the gRPC service will start, by default its value is `50059`. Make sure that it is set to the same value as the TCP port in the container.
 * `DB_HOST`: Database server address, by default its value is `localhost`.
 * `DB_PORT`: Indicates the database listening port, by default its value is `5432`.
 * `DB_NAME`: Name of the database, by default its value is `adempiere`.
 * `DB_USER`: Database connection user, by default its value is `adempiere`.
 * `DB_PASSWORD`: Password of the database connection, by default its value is `adempiere`.
 * `DB_TYPE`: Database management system, by default is `PostgreSQL`.
