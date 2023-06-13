const express = require("express");
const OrderController = require("../controllers/order-controller");

const router = express.Router();

const orderController = new OrderController();

router.post("/", orderController.createOrder.bind(orderController));

router.get(
  "/user/:userId",
  orderController.fetchOrdersOfUser.bind(orderController)
);

router.get(
  "/provider/placed/:providerId",
  orderController.fetchPlacedOrdersOfProvider.bind(orderController)
);
router.get(
  "/provider/prepared/:providerId",
  orderController.fetchPreparedOrdersOfProvider.bind(orderController)
);
router.get(
  "/provider/resolved/:providerId",
  orderController.fetchResolvedOrdersOfProvider.bind(orderController)
);

router.put(
  "/status/:orderId",
  orderController.changeOrderStatus.bind(orderController)
);

// router.get(
//   "/provider/:providerId",
//   orderController.fetchOrdersOfProvider.bind(orderController)
// );

module.exports = router;
