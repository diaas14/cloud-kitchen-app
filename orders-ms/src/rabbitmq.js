const amqp = require("amqplib");

const rabbitmqUrl = "amqp://rabbitmq-serv:5672";
let connection = null;
let channel = null;
const username = "default";
const password = "default";

async function connect() {
  try {
    connection = await amqp.connect(rabbitmqUrl, {
      credentials: amqp.credentials.plain(username, password),
    });
    channel = await connection.createChannel();

    console.log("Connected to RabbitMQ");
  } catch (error) {
    console.error("Error connecting to RabbitMQ:", error);
    throw error;
  }
}

async function consumeMessages(queueNames, messageHandlers) {
  try {
    await Promise.all(
      queueNames.map(async (queueName, index) => {
        const messageHandler = messageHandlers[index];
        await channel.assertQueue(queueName);
        await channel.consume(queueName, (message) => {
          if (message !== null) {
            const messageContent = message.content.toString();
            console.log("Received message:", messageContent);
            messageHandler(messageContent);
            channel.ack(message);
          }
        });

        console.log(`Waiting for messages on queue '${queueName}'...`);
      })
    );
  } catch (error) {
    console.error("Error consuming messages:", error);
  }
}

function getConnection() {
  return connection;
}

function getChannel() {
  return channel;
}

module.exports = {
  connect,
  consumeMessages,
  getConnection,
  getChannel,
};
