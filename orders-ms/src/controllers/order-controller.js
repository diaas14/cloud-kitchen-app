const amqp = require("amqplib");
const rabbitmq = require("../rabbitmq");

class OrderController {
  async createOrder(req, res) {
    try {
      const { customerId, cartItems } = req.body;
      const order = JSON.parse(cartItems);

      const channel = rabbitmq.getChannel();

      await this.checkItemAvailability(channel, order);

      res.status(201).send();
    } catch (error) {
      console.error("Error creating order:", error);
      res
        .status(500)
        .json({ error: "An error occurred while creating the order." });
    }
  }

  async checkItemAvailability(channel, order) {
    const queue = "itemAvailabilityCheck";
    await channel.assertQueue(queue);

    const messages = [];

    for (const itemId in order) {
      const message = {
        itemId,
        providerId: order[itemId]["providerId"],
        quantity: order[itemId]["units"],
      };
      messages.push(message);
    }

    channel.sendToQueue(queue, Buffer.from(JSON.stringify(messages)));
    console.log(
      `Sent item availability check message: ${JSON.stringify(messages)}`
    );

    console.log("checking avail status");
    const availabilityStatusQueue = "availabilityStatus";
    await channel.assertQueue(availabilityStatusQueue);
    const message = await new Promise((resolve) => {
      channel.consume(
        availabilityStatusQueue,
        (msg) => {
          resolve(msg);
        },
        { noAck: true }
      );
    });

    if (message) {
      const content = message.content.toString();
      const availabilityStatus = JSON.parse(content);
      console.log("Avail status", availabilityStatus);
    } else {
      console.log("No message.");
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
