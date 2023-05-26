const admin = require("firebase-admin");
const amqp = require("amqplib");

const rabbitmqUrl = "amqp://rabbitmq-serv:5672";

// const username = process.env.RABBITMQ_USERNAME;
// const password = process.env.RABBITMQ_PASSWORD;
const username = "default";
const password = "default";

class OrderController {
  async createOrder(req, res) {
    try {
      const { customerId, cartItems } = req.body;
      const order = JSON.parse(cartItems);

      const connection = await amqp.connect(rabbitmqUrl, {
        credentials: amqp.credentials.plain(username, password),
      });
      const channel = await connection.createChannel();

      await this.reduceItemQuantity(channel, order);

      // TO DO
      // const processedOrder = await processOrder(order);

      await channel.close();
      await connection.close();

      res.status(201).send();
    } catch (error) {
      console.error("Error creating order:", error);
      res
        .status(500)
        .json({ error: "An error occurred while creating the order." });
    }
  }

  async reduceItemQuantity(channel, order) {
    const queue = "itemQuantityReduction";

    await channel.assertQueue(queue);
    console.log(order);
    for (const itemId in order) {
      const message = {
        itemId,
        providerId: order[itemId]["providerId"],
        quantity: order[itemId]["units"],
      };

      channel.sendToQueue(queue, Buffer.from(JSON.stringify(message)));
      console.log(
        `Sent item quantity reduction message: ${JSON.stringify(message)}`
      );
    }
  }
}

module.exports = OrderController;
