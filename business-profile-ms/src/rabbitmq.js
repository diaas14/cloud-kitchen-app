const amqp = require("amqplib");

const rabbitmqUrl = "amqp://rabbitmq-serv:5672";
let connection = null;
let channel = null;
const username = "default";
const password = "default";

let unsentMessages = [];

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

async function handleChannelClose() {
  console.log("Channel closed unexpectedly. Reconnecting...");
  channel = null;
  await connect();
  while (unsentMessages.length > 0) {
    const { queueName, message } = unsentMessages.shift();
    await sendMessageToQueue(queueName, message);
  }
}

async function sendMessageToQueue(queueName, message) {
  try {
    if (!channel) {
      throw new Error("Channel is not available");
    }
    await channel.assertQueue(queueName, { durable: true });
    await channel.sendToQueue(queueName, Buffer.from(JSON.stringify(message)), {
      persistent: true,
    });

    console.log(`Message sent to queue '${queueName}':`, message);
  } catch (error) {
    console.error("Error sending message to queue:", error);
    unsentMessages.push({ queueName, message });
    handleChannelClose();
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
  sendMessageToQueue,
  getConnection,
  getChannel,
};
