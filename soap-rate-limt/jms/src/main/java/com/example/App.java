package com.example;
import com.tibco.tibjms.TibjmsQueueConnectionFactory;

import com.example.App.HelloWorldConsumer;

import javax.jms.Connection;
import javax.jms.DeliveryMode;
import javax.jms.Destination;
import javax.jms.ExceptionListener;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.MessageProducer;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import java.io.ByteArrayOutputStream;

/**
 * Hello world!
 */
public class App {

    public static void main(String[] args) throws Exception {
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldConsumer(), false);
        Thread.sleep(1000);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldProducer(), false);
        Thread.sleep(1000);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldProducer(), false);
        Thread.sleep(1000);
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldProducer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldConsumer(), false);
        thread(new HelloWorldProducer(), false);
    }

    public static void thread(Runnable runnable, boolean daemon) {
        Thread brokerThread = new Thread(runnable);
        brokerThread.setDaemon(daemon);
        brokerThread.start();
    }

    public static class HelloWorldProducer implements Runnable {
        public void run() {
            try {
                TibjmsQueueConnectionFactory connectionFactory = new TibjmsQueueConnectionFactory("tcp://localhost:9000");
                // Create a connection
                Connection connection = connectionFactory.createConnection("admin", "");
                // Create a Connection
                //connectionFactory.createConnection();
                connection.start();

                // Create a Session
                Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);

                // Create the destination (Topic or Queue)
                Destination destination = session.createQueue("TEST.FOO");

                // Create a MessageProducer from the Session to the Topic or Queue
                MessageProducer producer = session.createProducer(destination);
                producer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);

                // Create a SOAP message
        /*         SOAPMessage soapMessage = createSOAPMessage();

                // Convert SOAP message to String
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                soapMessage.writeTo(out);
                String soapMessageString = new String(out.toByteArray());
         */        
                String requestID = "123";
                String timestamp = "2024-07-05T10:15:30Z";

                String soapMessage = "<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns=\"http://www.bidv.com.vn/entity/global/vn/account/acctdetail/fdrdetailinq/1.0\" xmlns:ns1=\"http://www.bidv.com/common/envelope/commonheader/1.0\" xmlns:ns2=\"http://www.bidv.com/global/common/account/1.0\">    <soap:Header/>    <soap:Body>       <ns:FDRDetailInqReq>          <ns1:Header>             <ns1:Common>                <ns1:BusinessDomain>CBS.TEST.BIDV.COM.VN</ns1:BusinessDomain>                <ns1:ServiceVersion>1.3</ns1:ServiceVersion>                <ns1:MessageId>"+requestID+"</ns1:MessageId>                <ns1:MessageTimestamp>"+timestamp+"</ns1:MessageTimestamp>             </ns1:Common>             <ns1:Client>                <ns1:SourceAppID>OMNI</ns1:SourceAppID>             </ns1:Client>          </ns1:Header>          <ns:BodyReqFDRDetailInquiry>             <ns:MoreRecordIndicator></ns:MoreRecordIndicator>             <ns:AccInfoType>                <ns2:AcctNo>2223619077</ns2:AcctNo>                 <ns2:AcctType>CD</ns2:AcctType>                 <ns2:CurCode>VND</ns2:CurCode>             </ns:AccInfoType>          </ns:BodyReqFDRDetailInquiry>       </ns:FDRDetailInqReq>    </soap:Body> </soap:Envelope>";  
        
                // Create a TextMessage with the SOAP message
                TextMessage message = session.createTextMessage(soapMessage);

                // Tell the producer to send the message
                System.out.println("Sent message: " + message.hashCode() + " : " + Thread.currentThread().getName());
                producer.send(message);

                // Clean up
                session.close();
                connection.close();
            }
            catch (Exception e) {
                System.out.println("Caught: " + e);
                e.printStackTrace();
            }
        }

        
    }

    public static class HelloWorldConsumer implements Runnable, ExceptionListener {
        public void run() {
            try {

                // Create a ConnectionFactory
                TibjmsQueueConnectionFactory connectionFactory = new TibjmsQueueConnectionFactory("tcp://1.55.137.70:7222");
                // Create a connection
                Connection connection = connectionFactory.createConnection("admin", "");
                // Create a Connection
                //connectionFactory.createConnection();
                connection.start();

                connection.setExceptionListener(this);

                // Create a Session
                Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);

                // Create the destination (Topic or Queue)
                Destination destination = session.createQueue("TEST.FOO");

                // Create a MessageConsumer from the Session to the Topic or Queue
                MessageConsumer consumer = session.createConsumer(destination);

                // Wait for a message
                Message message = consumer.receive(1000);

                if (message instanceof TextMessage) {
                    TextMessage textMessage = (TextMessage) message;
                    String text = textMessage.getText();
                    System.out.println("Received message");
                } else {
                    System.out.println("Received: " + message);
                }

                consumer.close();
                session.close();
                connection.close();
            } catch (Exception e) {
                System.out.println("Caught: " + e);
                e.printStackTrace();
            }
        }

        public synchronized void onException(JMSException ex) {
            System.out.println("JMS Exception occured.  Shutting down client.");
        }
    }
}