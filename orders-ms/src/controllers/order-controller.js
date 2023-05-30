const admin = require("firebase-admin");
const axios = require("axios");

class OrderController {
  async createOrder(req, res) {
    const { customerId, providerId, cartItems } = req.body;
    try {
      const parsedCartItems = JSON.parse(cartItems);
      console.log(cartItems);
      const result = await axios.put(
        "http://business-profile-serv:4001/api/business-profile/transactions/",
        {
          cartItems: Object.entries(parsedCartItems).map(
            ([itemId, { units }]) => ({
              itemId,
              units,
            })
          ),
        }
      );

      console.log(result.status);
      if (result.status !== 200) {
        throw Error(result.data);
      }

      const ordersRef = admin.firestore().collection("orders");
      const newOrderRef = ordersRef.doc();

      const newOrder = {
        orderId: newOrderRef.id,
        customerId: customerId,
        providerId: providerId,
        items: Object.values(parsedCartItems),
      };

      await newOrderRef.set(newOrder);
      console.log("Order created successfully.");
      return res.status(201).json({ message: "Order created successfully." });
    } catch (error) {
      console.error("Error creating order:", error.message);
      return res.status(500).json({ message: "Internal server error." });
    }
  }
}

module.exports = OrderController;
