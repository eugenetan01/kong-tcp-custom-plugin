# Setup

**1. run the docker-compose file**

- `docker-compose up` -> to view the logs in stdout
- To rebuild the images run
  a. `docker-compose down` -> gracefully stop containers
  b. `docker system prune` -> delete cached containers
  c. `docker-compose up --build` -> rebuild containers

**2. setup a service on Kong Manager**

- host: 1.55.137.70
- protocol: tcp
- port: 7222

**3. setup a route**

```
curl -X POST http://localhost:2001/services/mq/routes \
 --data "protocols[]=tcp" \
 --data "name=tcp-route" \
 --data "destinations[1].port=9000"
```

# Setup JMS client

**1. navigate to ./jms folder**

**2. rename the lib/tibjms.jar to tibjms-1.0.jar**

**3. import the tibjms-1.0.jar to this directory on your local maven repo**

- if the below path doesn't exist, create it first
- `/Users/<replace-user>/.m2/repository/com/tibco/tibjms/1.0`

**4. import the jms-2.0.jar to this directory on your local maven repo**

- if the below path doesn't exist, create it first
- `/Users/<replace-url>/.m2/repository/javax/jms/jms/2.0`

**5. run the pom.xml with below command**

- `mvn clean install -U`

# Execution

**1. run the java app**

- `mvn exec:java -Dexec.mainClass="com.example.App"`

**2. observe responses, you should see messages hitting and being received from the MQ endpoint in the same terminal you ran step 1**

**3. go to kong manager and turn on the custom plugin**

- search for tcp-rate-limit in plugins page
- enable tcp-rate-limit globally or scope to the route\*\*

**4. terminate the java app in the terminal of step 1**

**5. run the java app with the command in step 1 again**

**6. observe after 5 messages are received from the MQ, an error starts to appear and no more new messages are received from the MQ**

** Note **

- simple springboot to specify how many messages and return the count

  - input:

- size based rate limit? -> whats the size of the payload and u can tell typically how many messages
  - based on count not reliable - what if someone dumps a huge message of 100mb?
  - look at the size of the message instead - look at the request size > 100kb?
  - based on size we can tell how many messages too - rate limit by size more accurate
  - what if someone sends a huge msg with 100mb with attachment, is it wrong?
