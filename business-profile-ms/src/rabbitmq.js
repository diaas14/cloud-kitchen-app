const admin = require("firebase-admin");
const amqp = require("amqplib");

const rabbitmqUrl = "amqp://rabbitmq-serv:5672";
const username = "default";
const password = "default";

const initiateTransactionQueue = "initiateTransaction";
const transactionResultQueue = "transactionResult";

async function processTransaction(orderItems) {
  try {
    const db = admin.firestore();
    const menuRef = db.collection("menu");

    const transactionResult = await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(menuRef);
      const items = snapshot.docs.reduce((acc, doc) => {
        acc[doc.id] = doc.data();
        return acc;
      }, {});

      for (let i = 0; i < orderItems.length; i++) {
        const orderItem = orderItems[i];
        const itemId = orderItem.itemId;
        const quantity = orderItem.quantity;

        console.log(
          `Available quantity: ${
            items[itemId].itemQuantity
          }, Requested quantity: ${quantity}, type: ${
            items[itemId].itemQuantity >= quantity
          }`
        );

        if (!items[itemId] || items[itemId].itemQuantity < quantity) {
          throw new Error(`Insufficient quantity for item ${itemId}`);
        }
      }

      for (let i = 0; i < orderItems.length; i++) {
        const orderItem = orderItems[i];
        const itemId = orderItem.itemId;
        const quantity = orderItem.quantity;

        items[itemId].itemQuantity -= quantity;
      }

      for (const itemId in items) {
        transaction.set(menuRef.doc(itemId), items[itemId]);
      }
      return true;
    });

    console.log("Order placed successfully.");
    return transactionResult;
  } catch (error) {
    console.error("Failed to place the order:", error);
    throw error;
  }
}

async function sendTransactionResult(channel, transactionResult) {
  try {
    const resultMessage = JSON.stringify(transactionResult);
    await channel.assertQueue(transactionResultQueue, { durable: true });
    await channel.sendToQueue(
      transactionResultQueue,
      Buffer.from(resultMessage)
    );
    console.log("Transaction result sent successfully.");
  } catch (error) {
    console.error("Error sending transaction result:", error);
  }
}

async function consumeTransactionRequestMessages(channel) {
  try {
    await channel.assertQueue(initiateTransactionQueue, { durable: true });
    await channel.consume(initiateTransactionQueue, async (message) => {
      if (message !== null) {
        const messageContent = JSON.parse(message.content.toString());
        console.log(
          `Received and processed item availability message: ${JSON.stringify(
            messageContent
          )}`
        );
        let transactionResult = false;
        try {
          transactionResult = await processTransaction(messageContent);
        } catch (error) {
          console.error("Error processing message:", error);
        }
        channel.ack(message);
        console.log("Acknowledged");
        await sendTransactionResult(channel, transactionResult);
      }
    });

    console.log("Waiting for availability messages...");
  } catch (error) {
    console.error("Error consuming availability messages:", error);
  }
}

async function establishConnectionAndChannel() {
  try {
    const connection = await amqp.connect(rabbitmqUrl, {
      credentials: amqp.credentials.plain(username, password),
    });

    connection.on("error", (error) => {
      console.error("RabbitMQ connection error:", error);
    });

    const channel = await connection.createChannel();
    await channel.prefetch(1);
    console.log("RabbitMQ connection and channel established");
    return { connection, channel };
  } catch (error) {
    console.error("Error establishing connection and channel:", error);
  }
}

async function closeConnectionAndChannel(channel, connection) {
  try {
    await channel.close();
    await connection.close();
    console.log("RabbitMQ connection closed");
  } catch (error) {
    console.error("Failed to close RabbitMQ connection:", error);
    throw error;
  }
}

module.exports = {
  consumeTransactionRequestMessages,
  establishConnectionAndChannel,
  closeConnectionAndChannel,
};

// const admin = require("firebase-admin");
// const amqp = require("amqplib");

// const rabbitmqUrl = "amqp://rabbitmq-serv:5672";
// const username = "default";
// const password = "default";

// const initiateTransactionQueue = "initiateTransaction";
// const transactionResultQueue = "transactionResult";

// let connection = null;
// let channel = null;

// async function processTransaction(orderItems) {
//   try {
//     const db = admin.firestore();
//     const menuRef = db.collection("menu");

//     const transactionResult = await db.runTransaction(async (transaction) => {
//       const snapshot = await transaction.get(menuRef);
//       const items = snapshot.docs.reduce((acc, doc) => {
//         acc[doc.id] = doc.data();
//         return acc;
//       }, {});

//       for (let i = 0; i < orderItems.length; i++) {
//         const orderItem = orderItems[i];
//         const itemId = orderItem.itemId;
//         const quantity = orderItem.quantity;

//         console.log(
//           `Available quantity: ${
//             items[itemId].itemQuantity
//           }, Requested quantity: ${quantity}, type: ${
//             items[itemId].itemQuantity >= quantity
//           }`
//         );
//         if (!items[itemId] || items[itemId].itemQuantity < quantity) {
//           throw new Error(`Insufficient quantity for item ${itemId}`);
//         }
//       }

//       // Reduce the quantities of the items in the order
//       for (let i = 0; i < orderItems.length; i++) {
//         const orderItem = orderItems[i];
//         const itemId = orderItem.itemId;
//         const quantity = orderItem.quantity;

//         items[itemId].itemQuantity -= quantity;
//       }

//       // Update the item quantities in the transaction
//       for (const itemId in items) {
//         transaction.set(menuRef.doc(itemId), items[itemId]);
//       }
//       return true;
//     });

//     console.log("Order placed successfully.");
//     return transactionResult;
//   } catch (error) {
//     console.error("Failed to place the order:", error);
//     throw error;
//   }
// }

// async function sendTransactionResult(channel, transactionResult) {
//   try {
//     const resultMessage = JSON.stringify(transactionResult);
//     await channel.assertQueue(transactionResultQueue, { durable: true });
//     await channel.sendToQueue(
//       transactionResultQueue,
//       Buffer.from(resultMessage)
//     );
//     console.log("Transaction result sent successfully.");
//   } catch (error) {
//     console.error("Error sending transaction result:", error);
//   }
// }

// async function consumeTransactionRequestMessages(channel) {
//   try {
//     await channel.assertQueue(initiateTransactionQueue, { durable: true });
//     await channel.consume(initiateTransactionQueue, async (message) => {
//       if (message !== null) {
//         try {
//           const messageContent = JSON.parse(message.content.toString());
//           const transactionResult = await processTransaction(messageContent);
//           console.log(
//             `Received and processed item availability message: ${JSON.stringify(
//               messageContent
//             )} Result of transaction: ${transactionResult}`
//           );
//           await sendTransactionResult(channel, transactionResult);
//           channel.ack(message);
//           console.log("Acknowledged");
//         } catch (error) {
//           console.error("Error processing message:", error);
//           channel.nack(message, false, false);
//         }
//       }
//     });
//     console.log("Waiting for availability messages...");
//   } catch (error) {
//     console.error("Error consuming availability messages:", error);
//   }
// }

// async function consumeMessages(channel) {
//   try {
//     await Promise.all([consumeTransactionRequestMessages(channel)]);
//   } catch (error) {
//     console.error("Error consuming messages:", error);
//   }
// }

// async function establishConnectionAndChannel() {
//   try {
//     connection = await amqp.connect(rabbitmqUrl, {
//       credentials: amqp.credentials.plain(username, password),
//     });

//     connection.on("error", (error) => {
//       console.error("RabbitMQ connection error:", error);
//     });

//     channel = await connection.createChannel();
//     await channel.prefetch(1);
//     console.log("RabbitMQ connection and channel established");
//     return { connection, channel };
//   } catch (error) {
//     console.error("Error establishing connection and channel:", error);
//   }
// }

// function getConnection() {
//   return connection;
// }

// function getChannel() {
//   return channel;
// }

// async function closeConnectionAndChannel(channel, connection) {
//   try {
//     await channel.close();
//     await connection.close();
//     console.log("RabbitMQ connection closed");
//   } catch (error) {
//     console.error("Failed to close RabbitMQ connection:", error);
//     throw error;
//   }
// }

// module.exports = {
//   consumeMessages,
//   establishConnectionAndChannel,
//   closeConnectionAndChannel,
//   getConnection,
//   getChannel,
// };
