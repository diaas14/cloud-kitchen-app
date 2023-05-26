const amqp = require("amqplib");
const admin = require("firebase-admin");

const rabbitmqUrl = "amqp://rabbitmq-serv:5672";
const username = "default";
const password = "default";
const queue = "itemQuantityReduction";

async function reduceItemQuantityInFirebase(message) {
  console.log("reduceItemQuantityInFirebase executed.");
  //   const { itemId, providerId, quantity } = message;

  //   const businessDoc = await admin
  //     .firestore()
  //     .collection("businesses")
  //     .doc((userId = providerId))
  //     .get();
  //   if (!businessDoc.exists) {
  //     throw new Error("Business document not found");
  //   }

  //   const menu = businessDoc.data().menu;
  //   if (!menu || !Array.isArray(menu)) {
  //     throw new Error("Menu not found or is not an array");
  //   }

  //   const menuItem = menu.find((item) => item.itemId === itemId);
  //   if (!menuItem) {
  //     throw new Error("Menu item not found");
  //   }

  //   console.log("Menu Item ", menuItem);

  //   //   if (itemData) {
  //   //     // Reduce the quantity of the item
  //   //     const reducedQuantity = itemData.quantity - quantity;

  //   //     // Update the item in Firebase
  //   //     await itemRef.update({ quantity: reducedQuantity });

  //   //     console.log(`Reduced quantity of item ${itemId} to ${reducedQuantity}`);
  //   //   } else {
  //   //     console.log(`Item ${itemId} not found in Firebase`);
  //   //   }
  //   console.log(message);
}

async function consumeMessages() {
  try {
    const connection = await amqp.connect(rabbitmqUrl, {
      credentials: amqp.credentials.plain(username, password),
    });
    const channel = await connection.createChannel();

    await channel.assertQueue(queue);
    await channel.consume(queue, async (message) => {
      if (message !== null) {
        try {
          const messageContent = JSON.parse(message.content.toString());
          await reduceItemQuantityInFirebase(messageContent);
          console.log(
            `Received and processed item quantity reduction message: ${JSON.stringify(
              messageContent
            )}`
          );
          channel.ack(message);
        } catch (error) {
          console.error("Error processing message:", error);
          channel.reject(message, false);
        }
      }
    });

    console.log("Waiting for messages...");
  } catch (error) {
    console.error("Error consuming messages:", error);
  }
}

module.exports = { consumeMessages };
