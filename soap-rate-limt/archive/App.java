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
import java.io.OutputStream;
import java.net.Socket;
import javax.jms.*;
/**
 * Hello world!
 */
public class App {

    public static void main(String[] args) throws Exception {
        HelloWorldProducer producer = new HelloWorldProducer();
        /* String serverAddress = "1.55.137.70";
        int port = 9225;

        try (Socket socket = new Socket(serverAddress, port);
             OutputStream outputStream = socket.getOutputStream()) {

            String requestID = "123";
            String timestamp = "2024-07-05T10:15:30Z";

            String plainMessage = "<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns=\"http://www.bidv.com.vn/entity/global/vn/account/acctdetail/fdrdetailinq/1.0\" xmlns:ns1=\"http://www.bidv.com/common/envelope/commonheader/1.0\" xmlns:ns2=\"http://www.bidv.com/global/common/account/1.0\">    <soap:Header/>    <soap:Body>       <ns:FDRDetailInqReq>          <ns1:Header>             <ns1:Common>                <ns1:BusinessDomain>CBS.TEST.BIDV.COM.VN</ns1:BusinessDomain>                <ns1:ServiceVersion>1.3</ns1:ServiceVersion>                <ns1:MessageId>" + requestID + "</ns1:MessageId>                <ns1:MessageTimestamp>" + timestamp + "</ns1:MessageTimestamp>             </ns1:Common>             <ns1:Client>                <ns1:SourceAppID>OMNI</ns1:SourceAppID>             </ns1:Client>          </ns1:Header>          <ns:BodyReqFDRDetailInquiry>             <ns:MoreRecordIndicator></ns:MoreRecordIndicator>             <ns:AccInfoType>                <ns2:AcctNo>2223619077</ns2:AcctNo>                 <ns2:AcctType>CD</ns2:AcctType>                 <ns2:CurCode>VND</ns2:CurCode>             </ns:AccInfoType>          </ns:BodyReqFDRDetailInquiry>       </ns:FDRDetailInqReq>    </soap:Body> </soap:Envelope>";

            for (int i = 0; i < 5; i++) {
                outputStream.write(plainMessage.getBytes());
                outputStream.flush();
                System.out.println("Sent message: " + plainMessage);
            }
        } catch (Exception e) {
            System.out.println("Caught: " + e);
            e.printStackTrace();
        }
 */
        HelloWorldConsumer consumer = new HelloWorldConsumer();

        producer.run();
        consumer.run();

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
                String plainMessage = "<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns=\"http://www.bidv.com.vn/entity/global/vn/account/acctdetail/fdrdetailinq/1.0\" xmlns:ns1=\"http://www.bidv.com/common/envelope/commonheader/1.0\" xmlns:ns2=\"http://www.bidv.com/global/common/account/1.0\"><soap:Header/><soap:Body><ns:FDRDetailInqReq><ns1:Header><ns1:Common><ns1:BusinessDomain>CBS.TEST.BIDV.COM.VN</ns1:BusinessDomain><ns1:ServiceVersion>1.3</ns1:ServiceVersion><ns1:MessageId>" + requestID + "</ns1:MessageId><ns1:MessageTimestamp>" + timestamp + "</ns1:MessageTimestamp></ns1:Common><ns1:Client><ns1:SourceAppID>OMNI</ns1:SourceAppID></ns1:Client></ns1:Header><ns:BodyReqFDRDetailInquiry><ns:MoreRecordIndicator></ns:MoreRecordIndicator><ns:AccInfoType><ns2:AcctNo>2223619077</ns2:AcctNo><ns2:AcctType>CD</ns2:AcctType><ns2:CurCode>VND</ns2:CurCode></ns:AccInfoType></ns:BodyReqFDRDetailInquiry></ns:FDRDetailInqReq></soap:Body></soap:Envelope>";

                byte[] messageBytes = plainMessage.getBytes("UTF-8");
                //TextMessage message = session.createTextMessage(soapMessage);

                // Tell the producer to send the message
                //System.out.println("Sent message: " + message.hashCode() + " : " + Thread.currentThread().getName());
                for (int i = 0; i < 5; i++){
                    BytesMessage bytesMessage = session.createBytesMessage();
                    bytesMessage.writeBytes(messageBytes);
                    producer.send(bytesMessage);
                    System.out.println("Sent BytesMessage: " + plainMessage);
                }
                // Clean up

                /* TextMessage message = session.createTextMessage(plainMessage);
                for (int i = 0; i < 5; i++){
                    producer.send(message);
                    System.out.println("Sent message: " + message.hashCode() + " : " + Thread.currentThread().getName());
                } */
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
                TibjmsQueueConnectionFactory connectionFactory = new TibjmsQueueConnectionFactory("tcp://1.55.137.70:9225");
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
                /*Message message;
                // Wait for a message
                while ((message = consumer.receive(1000)) != null) {
                    // Log the flushed message if needed
                    if (message instanceof TextMessage) {
                        TextMessage textMessage = (TextMessage) message;
                        String text = textMessage.getText();
                        System.out.println("Flushed message: " + text);
                    } else {
                        System.out.println("Flushed: " + message);
                    }
                } */
                while (true) {
                    Message message = consumer.receive(5000);  // Wait up to 5 seconds for a message
                    if (message != null) {
                        System.out.println("Message received");
                        if (message instanceof BytesMessage) {
                            BytesMessage bytesMessage = (BytesMessage) message;
                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = bytesMessage.readBytes(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                            }
    
                            String messageContent = outputStream.toString("UTF-8");
                            System.out.println("Received BytesMessage content: " + messageContent);
    
                            outputStream.close();
                        } else if (message instanceof TextMessage) {
                            TextMessage textMessage = (TextMessage) message;
                            System.out.println("Received TextMessage content: " + textMessage.getText());
                        } else {
                            System.out.println("Received non-bytes message: " + message);
                        }
                    } else {
                        System.out.println("No more messages.");
                        break;
                    }
                } 
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