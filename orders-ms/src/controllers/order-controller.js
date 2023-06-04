const admin = require("firebase-admin");
const axios = require("axios");

class OrderController {
  async createOrder(req, res) {
    const {
      customerId,
      providerId,
      cartItems,
      price,
      userData,
      providerDetails,
    } = req.body;
    try {
      const parsedCartItems = JSON.parse(cartItems);
      const parsedCustomerData = JSON.parse(userData);
      const parsedProviderDetails = JSON.parse(providerDetails);
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
        price: parseFloat(price),
        customerData: parsedCustomerData,
        providerDetails: parsedProviderDetails,
      };

      await newOrderRef.set(newOrder);
      console.log("Order created successfully.");
      return res.status(201).json({ message: "Order created successfully." });
    } catch (error) {
      console.error("Error creating order:", error);
      return res.status(500).json({ message: "Internal server error." });
    }
  }

  async fetchOrdersOfUser(req, res) {
    const userId = req.params.userId;

    try {
      const ordersRef = admin.firestore().collection("orders");
      const querySnapshot = await ordersRef
        .where("customerId", "==", userId)
        .get();

      if (querySnapshot.empty) {
        return res
          .status(404)
          .json({ message: "No orders found for the user." });
      }

      const orders = [];
      querySnapshot.forEach((doc) => {
        const orderData = doc.data();
        orders.push(orderData);
      });

      return res.status(200).json(orders);
    } catch (error) {
      console.error("Error fetching orders:", error);
      return res.status(500).json({ message: "Internal server error." });
    }
  }

  async fetchOrdersOfProvider(req, res) {
    const providerId = req.params.providerId;
    try {
      const ordersRef = admin.firestore().collection("orders");
      const querySnapshot = await ordersRef
        .where("providerId", "==", providerId)
        .get();

      if (querySnapshot.empty) {
        return res
          .status(404)
          .json({ message: "No orders found for the user." });
      }

      const orders = [];
      querySnapshot.forEach((doc) => {
        const orderData = doc.data();
        orders.push(orderData);
      });

      return res.status(200).json(orders);
    } catch (error) {
      console.error("Error fetching orders:", error);
      return res.status(500).json({ message: "Internal server error." });
    }
  }
}

module.exports = OrderController;
