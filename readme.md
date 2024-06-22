# Setup
__1. Run the docker-compose file__
- `docker-compose up` -> to view the logs in stdout
- To rebuild the images run
  a. `docker-compose down` -> gracefully stop containers
  b. `docker system prune` -> delete cached containers
  c. `docker-compose up --build` -> rebuild containers

__1. setup a service on Kong Manager__
- host: tcpserver
- protocol: tcp
- port: 65432

__2. setup a route__
```
curl -X POST http://localhost:2001/services/tcp-service/routes \
  --data "protocols[]=tcp" \
  --data "name=tcp-route" \
  --data "destinations[1].port=9000"
```

OR

- follow the UI below to configure route
![](/img/ss_route.png)

__3. Test the route__
- Go to client folder and run main.py to fire a tcp request to tcpserver
```
python3 main.py
```
- See a response similar to this

![](/img/client_resp_no_plugin.png)

__3. Take note env variables in docker-compose for use or reference throughout this project__
- Kong setup on following ports:
  a. Kong Manager: 2002
  b. tcpserver: 65432
  c. Kong TCP proxy: 9000
  d. Kong Admin API: 2001
  e. Kong HTTP proxy: 2000

# Execution
__1. Go to Kong Manager and enable the tcp-counter plugin__

![](/img/enable-tcpcounter.png)
![](/img/plugin-conf.png)

# Measure
__2. Go to client folder and run main.py again to test the functionality of the plugin__
- The tcp-transform plugin will do 2 things:

  1. Transform the message and add the string "I am a test app" to send to upstream TCP server

  2. log the output to stdout to show when:

    a. A tcp request is read

    ![](/img/read_tcp.png)

    b. Send the response downstream

    ![](/img/get_resp_send_downstream.png)

    c. Client main.py gets response with modified payload

    ![](/img/client_resp.png)
