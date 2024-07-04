# Setup

**1. Run docker ActiveMQ to start the JMS broker**

- `docker run --detach --name mycontainer -p 61616:61616 -p 8161:8161 --rm apache/activemq-artemis:latest-alpine`
- If you want to enter into the broker container and interact with the shell use the following:
  - `docker exec -it mycontainer /var/lib/artemis-instance/bin/artemis shell --user artemis --password artemis`
- Link to setup this [here](https://activemq.apache.org/components/artemis/documentation/latest/docker.html)

# Execute

**1. Ensure login creds are as follow:**

- Username: "artemis"
- password: "artemis"

**2. Command to start the java app**

- `mvn exec:java -Dexec.mainClass="com.example.App"`
