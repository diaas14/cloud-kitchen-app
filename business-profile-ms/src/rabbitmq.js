const admin = require("firebase-admin");

const itemAvailabilityStatusQueue = "itemAvailabilityStatus";
const itemAvailabilityCheckQueue = "itemAvailabilityCheck";
const itemReductionRequestQueue = "itemReductionRequest";

async function checkItemAvailabilityInFirebase(messages) {
  const menuRef = admin.firestore().collection("menu");

  const itemIds = messages.map((message) => message.itemId);
  const query = menuRef.where("itemId", "in", itemIds);

  const snapshot = await query.get();
  const itemAvailabilityMap = new Map();

  snapshot.forEach((doc) => {
    itemAvailabilityMap.set(doc.data().itemId, doc.data().itemQuantity);
  });

  for (const message of messages) {
    const { itemId, quantity } = message;
    const itemQuantity = itemAvailabilityMap.get(itemId);

    if (itemQuantity === undefined) {
      console.log(`No matching documents for item ${itemId}.`);
      return false;
    }

    console.log("Quantity available:", itemQuantity);
    console.log("Available status:", itemQuantity >= quantity);

    if (itemQuantity < quantity) {
      return false;
    }
  }
  return true;
}

async function publishAvailabilityStatus(channel, res) {
  await channel.assertQueue(itemAvailabilityStatusQueue, { durable: true });
  const message = {
    availabilityStatus: res,
  };
  await channel.sendToQueue(
    itemAvailabilityStatusQueue,
    Buffer.from(JSON.stringify(message))
  );
  console.log(`Published availability status: ${JSON.stringify(message)}`);
}

async function consumeAvailabilityMessages(channel) {
  try {
    await channel.assertQueue(itemAvailabilityCheckQueue, { durable: true });
    await channel.prefetch(1);
    await channel.consume(itemAvailabilityCheckQueue, async (message) => {
      if (message !== null) {
        try {
          const messageContent = JSON.parse(message.content.toString());
          const res = await checkItemAvailabilityInFirebase(messageContent);
          console.log(
            `Received and processed item availability message: ${JSON.stringify(
              messageContent
            )}`
          );
          await publishAvailabilityStatus(channel, res);
          channel.ack(message);
          console.log("Acknowledged");
        } catch (error) {
          console.error("Error processing message:", error);
          channel.nack(message, false, false);
        }
      }
    });
    console.log("Waiting for availability messages...");
  } catch (error) {
    console.error("Error consuming availability messages:", error);
  }
}

async function consumeReductionMessages(channel) {
  try {
    await channel.assertQueue(itemReductionRequestQueue, { durable: true });
    await channel.prefetch(1);
    await channel.consume(itemReductionRequestQueue, async (message) => {
      if (message !== null) {
        try {
          console.log(
            "Received message from itemReductionRequestQueue:",
            message.content.toString()
          );
          channel.ack(message);
          console.log("Acknowledged");
        } catch (error) {
          console.error("Error processing message from another queue:", error);
          channel.nack(message, false, false);
        }
      }
    });
    console.log("Waiting for reduction messages...");
  } catch (error) {
    console.error("Error consuming reduction messages:", error);
  }
}

async function consumeMessages(channel) {
  try {
    await Promise.all([
      consumeAvailabilityMessages(channel),
      consumeReductionMessages(channel),
    ]);
  } catch (error) {
    console.error("Error consuming messages:", error);
  }
}

async function establishConnectionAndChannel(rabbitmqUrl, username, password) {
  try {
    const amqp = require("amqplib");
    const connection = await amqp.connect(rabbitmqUrl, {
      credentials: amqp.credentials.plain(username, password),
    });
    const channel = await connection.createChannel();
    return { connection, channel };
  } catch (error) {
    console.error("Error establishing connection and channel:", error);
  }
}

module.exports = {
  consumeMessages,
  establishConnectionAndChannel,
};
