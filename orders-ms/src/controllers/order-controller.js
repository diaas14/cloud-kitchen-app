const amqp = require("amqplib");
const rabbitmq = require("../rabbitmq");

const itemAvailabilityCheckQueue = "itemAvailabilityCheck";
const itemAvailabilityStatusQueue = "itemAvailabilityStatus";

class OrderController {
  async createOrder(req, res) {
    try {
      const { customerId, cartItems } = req.body;
      const order = JSON.parse(cartItems);

      const channel = rabbitmq.getChannel();

      await this.checkItemAvailability(channel, order, (availabilityStatus) => {
        console.log("It returned!!! ", availabilityStatus);
      });

      res.status(201).send();
    } catch (error) {
      console.error("Error creating order:", error);
      res
        .status(500)
        .json({ error: "An error occurred while creating the order." });
    }
  }

  async checkItemAvailability(channel, order, callback) {
    try {
      await channel.assertQueue(itemAvailabilityCheckQueue, { durable: true });

      const messages = Object.entries(order).map(([itemId, { units }]) => ({
        itemId,
        quantity: units,
      }));

      await channel.sendToQueue(
        itemAvailabilityCheckQueue,
        Buffer.from(JSON.stringify(messages))
      );
      console.log(
        `Sent item availability check message: ${JSON.stringify(messages)}`
      );

      console.log("Checking availability status");

      await channel.assertQueue(itemAvailabilityStatusQueue, { durable: true });

      const consumerTag = channel.consume(
        itemAvailabilityStatusQueue,
        (msg) => {
          const content = msg.content.toString();
          const availabilityStatus = JSON.parse(content);
          console.log("Availability status", availabilityStatus);
          channel.ack(msg);
          callback(availabilityStatus);
        },
        { noAck: false }
      );

      if (!consumerTag) {
        console.log("No message.");
        callback(false);
      }
    } catch (error) {
      console.error("Error checking item availability:", error);
      callback(false);
    }
  }
}

module.exports = OrderController;
