curl -X POST http://localhost:2001/services/mq/routes \
 --data "protocols[]=tcp" \
 --data "name=tcp-route" \
 --data "destinations[1].port=9000"

1429 [kong] init.lua:426 [tcp-rate-limit] /opt/conf/kong/plugins/tcp-rate-limit/handler.lua:22: attempt to index upvalue 'shared' (a nil value) while prereading client data, client: 192.168.65.1, server: 0.0.0.0:9000
