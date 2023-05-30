const amqp = require("amqplib");
const admin = require("firebase-admin");
const rabbitmq = require("../rabbitmq");

const initiateTransactionQueue = "initiateTransaction";
const transactionResultQueue = "transactionResult";

class OrderController {
  async createOrder(req, res) {
    const { customerId, providerId, cartItems } = req.body;

    try {
      const parsedCartItems = JSON.parse(cartItems);

      const channel = rabbitmq.getChannel();
      await channel.prefetch(1);

      await this.sendTransactionRequest(channel, parsedCartItems);

      await this.listenForTransactionResult(
        channel,
        parsedCartItems,
        customerId,
        providerId,
        this.storeOrderInOrdersCollection
      );

      console.log("Sending response..");
      res.status(200).json({ message: "Order created successfully." });
    } catch (error) {
      console.error("Error creating order:", error);
      res.status(500).json({ message: "Internal server error." });
    }
  }

  async storeOrderInOrdersCollection(
    order,
    customerId,
    providerId,
    transactionResult
  ) {
    try {
      console.log("Finally returned: ", transactionResult);
      console.log("Storing in DB...");

      const ordersRef = admin.firestore().collection("orders");
      const newOrderRef = ordersRef.doc();

      const newOrder = {
        orderId: newOrderRef.id,
        customerId: customerId,
        providerId: providerId,
        items: Object.values(order),
      };

      await newOrderRef.set(newOrder);
      console.log("Order created successfully!");

      return Promise.resolve(); // Resolve the promise when the items are stored
    } catch (err) {
      console.error("Error storing order in database:", err);
      return Promise.reject(err); // Reject the promise if there's an error storing the items
    }
  }

  async sendTransactionRequest(channel, order) {
    const messages = Object.entries(order).map(([itemId, { units }]) => ({
      itemId,
      quantity: units,
    }));

    try {
      await channel.assertQueue(initiateTransactionQueue, {
        durable: true,
      });

      await channel.sendToQueue(
        initiateTransactionQueue,
        Buffer.from(JSON.stringify(messages))
      );

      console.log(
        `Sent item availability check message: ${JSON.stringify(messages)}`
      );
    } catch (error) {
      console.error("Error sending transaction request:", error);
    }
  }

  async listenForTransactionResult(
    channel,
    order,
    customerId,
    providerId,
    callback
  ) {
    return new Promise(async (resolve, reject) => {
      let messageProcessed = false; // Flag to track if a message has been processed
      console.log("Message Processed ", messageProcessed);
      try {
        await channel.assertQueue(transactionResultQueue, { durable: true });

        channel.consume(transactionResultQueue, async (message) => {
          if (message !== null && !messageProcessed) {
            messageProcessed = true; // Set the flag to true to stop consuming messages
            console.log("Processed message ", messageProcessed);
            const transactionResult = JSON.parse(message.content.toString());
            console.log(
              `Received transaction result: ${JSON.stringify(
                transactionResult
              )}`
            );
            channel.ack(message);
            console.log("Acknowledged");

            try {
              await callback(order, customerId, providerId, transactionResult);
              console.log("Resolving");
              resolve(); // Resolve the promise when the items are stored
            } catch (error) {
              console.log("Rejecting");
              reject(error); // Reject the promise if there's an error storing the items
            }
          }
        });
      } catch (error) {
        console.error("Error consuming transaction results:", error);
        reject(error); // Reject the promise if there's an error consuming the results
      }
    });
  }
}

module.exports = OrderController;

// const amqp = require("amqplib");
// const admin = require("firebase-admin");
// const rabbitmq = require("../rabbitmq");

// const initiateTransactionQueue = "initiateTransaction";
// const transactionResultQueue = "transactionResult";

// class OrderController {
//   async createOrder(req, res) {
//     const { customerId, providerId, cartItems } = req.body;

//     try {
//       const parsedCartItems = JSON.parse(cartItems);

//       const channel = rabbitmq.getChannel();
//       await channel.prefetch(1);

//       await this.sendTransactionRequest(channel, parsedCartItems);

//       await this.listenForTransactionResult(
//         channel,
//         parsedCartItems,
//         customerId,
//         providerId,
//         this.storeOrderInOrdersCollection
//       );

//       console.log("Sending response..");
//       res.status(200).json({ message: "Order created successfully." });
//     } catch (error) {
//       console.error("Error creating order:", error);
//       res.status(500).json({ message: "Internal server error." });
//     }
//   }

//   async storeOrderInOrdersCollection(
//     order,
//     customerId,
//     providerId,
//     transactionResult
//   ) {
//     try {
//       console.log("Finally returned: ", transactionResult);
//       console.log("Storing in DB...");

//       const ordersRef = admin.firestore().collection("orders");
//       const newOrderRef = ordersRef.doc();

//       const newOrder = {
//         orderId: newOrderRef.id,
//         customerId: customerId,
//         providerId: providerId,
//         items: Object.values(order),
//       };

//       await newOrderRef.set(newOrder);
//       console.log("Order created successfully!");

//       return Promise.resolve(); // Resolve the promise when the items are stored
//     } catch (err) {
//       console.error("Error storing order in database:", err);
//       return Promise.reject(err); // Reject the promise if there's an error storing the items
//     }
//   }

//   async sendTransactionRequest(channel, order) {
//     const messages = Object.entries(order).map(([itemId, { units }]) => ({
//       itemId,
//       quantity: units,
//     }));

//     try {
//       await channel.assertQueue(initiateTransactionQueue, {
//         durable: true,
//       });

//       await channel.sendToQueue(
//         initiateTransactionQueue,
//         Buffer.from(JSON.stringify(messages))
//       );

//       console.log(
//         `Sent item availability check message: ${JSON.stringify(messages)}`
//       );
//     } catch (error) {
//       console.error("Error sending transaction request:", error);
//     }
//   }

//   // async listenForTransactionResult(
//   //   channel,
//   //   order,
//   //   customerId,
//   //   providerId,
//   //   callback
//   // ) {
//   //   try {
//   //     await channel.assertQueue(transactionResultQueue, { durable: true });

//   //     channel.consume(transactionResultQueue, (message) => {
//   //       if (message !== null) {
//   //         const transactionResult = JSON.parse(message.content.toString());
//   //         console.log(
//   //           `Received transaction result: ${JSON.stringify(transactionResult)}`
//   //         );
//   //         channel.ack(message);
//   //         console.log("Acknowledged");

//   //         callback(order, customerId, providerId, transactionResult);
//   //       }
//   //     });
//   //   } catch (error) {
//   //     console.error("Error consuming transaction results:", error);
//   //     throw error;
//   //   }
//   // }

//   // async listenForTransactionResult(
//   //   channel,
//   //   order,
//   //   customerId,
//   //   providerId,
//   //   callback
//   // ) {
//   //   return new Promise(async (resolve, reject) => {
//   //     try {
//   //       await channel.assertQueue(transactionResultQueue, { durable: true });

//   //       channel.consume(transactionResultQueue, async (message) => {
//   //         if (message !== null) {
//   //           const transactionResult = JSON.parse(message.content.toString());
//   //           console.log(
//   //             `Received transaction result: ${JSON.stringify(
//   //               transactionResult
//   //             )}`
//   //           );
//   //           channel.ack(message);
//   //           console.log("Acknowledged");

//   //           try {
//   //             await callback(order, customerId, providerId, transactionResult);
//   //             console.log("Resolving");
//   //             resolve(); // Resolve the promise when the items are stored
//   //           } catch (error) {
//   //             console.log("Rejecting");
//   //             reject(error); // Reject the promise if there's an error storing the items
//   //           }
//   //         }
//   //       });
//   //     } catch (error) {
//   //       console.error("Error consuming transaction results:", error);
//   //       reject(error); // Reject the promise if there's an error consuming the results
//   //     }
//   //   });
//   // }

//   async listenForTransactionResult(
//     channel,
//     order,
//     customerId,
//     providerId,
//     callback
//   ) {
//     return new Promise(async (resolve, reject) => {
//       let messageProcessed = false; // Flag to track if a message has been processed
//       console.log("Message Processed ", messageProcessed);
//       try {
//         await channel.assertQueue(transactionResultQueue, { durable: true });

//         channel.consume(transactionResultQueue, async (message) => {
//           if (message !== null && !messageProcessed) {
//             messageProcessed = true; // Set the flag to true to stop consuming messages
//             console.log("Processed message ", messageProcessed);
//             const transactionResult = JSON.parse(message.content.toString());
//             console.log(
//               `Received transaction result: ${JSON.stringify(
//                 transactionResult
//               )}`
//             );
//             channel.ack(message);
//             console.log("Acknowledged");

//             try {
//               await callback(order, customerId, providerId, transactionResult);
//               console.log("Resolving");
//               resolve(); // Resolve the promise when the items are stored
//             } catch (error) {
//               console.log("Rejecting");
//               reject(error); // Reject the promise if there's an error storing the items
//             }
//           }
//         });
//       } catch (error) {
//         console.error("Error consuming transaction results:", error);
//         reject(error); // Reject the promise if there's an error consuming the results
//       }
//     });
//   }
// }

// module.exports = OrderController;
