const admin = require("firebase-admin");

const queue = "itemQuantityReduction";

async function reduceItemQuantityInFirebase(message) {
  console.log("reduceItemQuantityInFirebase executed.");
  const { itemId, providerId, quantity } = message;

  const menuRef = admin.firestore().collection("menu");
  const query = menuRef.where("providerId", "==", providerId);

  const snapshot = await query.get();

  if (snapshot.empty) {
    console.log("No matching documents.");
  } else {
    snapshot.forEach((doc) => {
      console.log("Document ID:", doc.id);
      console.log("Document data:", doc.data());
    });
  }
}

async function consumeMessages(channel) {
  try {
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
          console.log("Acknowledged");
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
