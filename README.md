ADempiere Access gRPC Docker Server
=====================

[Docker](https://www.docker.io/) file for trusted builds of [ADempiere gRPC Deploy](http://erpya.com/) on https://hub.docker.com/r/erpya/adempiere-grpc-all-in-one.

You will need use a file with a structure like it: [all_in_one_connection.yaml](all_in_one_connection.yaml)
```yaml

server:
    port: 50059
    services:
       -   access
       -   enrollment
       -   dictionary
       -   business
       -   core
       -   ui
       -   dashboarding
       -   workflow
       -   log
database:
    host: localhost
    port: 5432
    name: adempiere
    user: adempiere
    password: adempiere
    type: PostgreSQL

```

Run the latest container with:
```shell
    docker pull erpya/adempiere-grpc-all-in-one
```

```shell
docker run --name adempiere-grpc-all-in-one -it \
	-p 50059:50059 \
	-v $(pwd)/access_connection.yaml:/opt/Apps/ADempiere-gRPC-Server/bin/access_connection.yaml \
	erpya/adempiere-grpc-all-in-one
```
