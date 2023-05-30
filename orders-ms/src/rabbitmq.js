const amqp = require("amqplib");

let connection = null;
let channel = null;

const rabbitmqUrl = "amqp://rabbitmq-serv:5672";
const username = "default";
const password = "default";

async function establishConnectionAndChannel() {
  try {
    connection = await amqp.connect(rabbitmqUrl, {
      credentials: amqp.credentials.plain(username, password),
    });
    channel = await connection.createChannel();
    console.log("RabbitMQ connection and channel established");
    return { connection, channel };
  } catch (error) {
    console.error(
      "Failed to establish RabbitMQ connection and channel:",
      error
    );
  }
}

async function closeConnectionAndChannel(channel, connection) {
  try {
    await channel.close();
    await connection.close();
    console.log("RabbitMQ connection closed");
  } catch (error) {
    console.error("Failed to close RabbitMQ connection:", error);
  }
}

function getConnection() {
  return connection;
}

function getChannel() {
  return channel;
}

module.exports = {
  establishConnectionAndChannel,
  closeConnectionAndChannel,
  getConnection,
  getChannel,
};
