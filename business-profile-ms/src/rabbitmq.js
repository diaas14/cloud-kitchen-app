const admin = require("firebase-admin");

const queue = "itemAvailabilityCheck";

// async function checkItemAvailabilityInFirebase(messages) {
//   const menuRef = admin.firestore().collection("menu");

//   for (const message of messages) {
//     const { itemId, providerId, quantity } = message;

//     const query = menuRef.where("itemId", "==", itemId);

//     const snapshot = await query.get();

//     if (snapshot.empty) {
//       console.log(`No matching documents for item ${itemId}.`);
//       // Handle unavailability of the item
//     } else {
//       snapshot.forEach((doc) => {
//         console.log("Quantity avaliable:", doc.data()["itemQuantity"]);
//         console.log(
//           "Avaliable status:",
//           doc.data()["itemQuantity"] >= quantity
//         );
//         // Process the available item
//       });
//     }
//   }
// }

async function checkItemAvailabilityInFirebase(messages) {
  console.log("checkItemAvailabilityInFirebase executed");
  const menuRef = admin.firestore().collection("menu");

  for (const message of messages) {
    const { itemId, providerId, quantity } = message;

    const query = menuRef.where("itemId", "==", itemId);

    const snapshot = await query.get();
    var available = true;

    if (snapshot.empty) {
      console.log(`No matching documents for item ${itemId}.`);
      return false;
    } else {
      snapshot.forEach((doc) => {
        console.log("Quantity avaliable:", doc.data()["itemQuantity"]);
        console.log(
          "Avaliable status:",
          doc.data()["itemQuantity"] >= quantity
        );
        available &= doc.data()["itemQuantity"] >= quantity;
      });
    }
  }
  return available;
}

async function publishAvailabilityStatus(channel, res) {
  const availabilityStatusQueue = "availabilityStatus";
  await channel.assertQueue(availabilityStatusQueue);
  channel.sendToQueue(
    availabilityStatusQueue,
    Buffer.from(JSON.stringify(res))
  );
  console.log(`Published availability status: ${JSON.stringify(res)}`);
}

async function consumeMessages(channel) {
  try {
    await channel.assertQueue(queue);
    await channel.prefetch(0);
    await channel.consume(queue, async (message) => {
      if (message !== null) {
        try {
          console.log("Message received!");
          const messageContent = JSON.parse(message.content.toString());
          const res = await checkItemAvailabilityInFirebase(messageContent);
          console.log(res);
          console.log(
            `Received and processed item availability message: ${JSON.stringify(
              messageContent
            )}`
          );
          // Publish the result to the availabilityStatus queue
          await publishAvailabilityStatus(channel, res);

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
