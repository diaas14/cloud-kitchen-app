const express = require("express");
const OrderController = require("../controllers/order-controller");

const router = express.Router();

const orderController = new OrderController();

router.post("/", orderController.createOrder.bind(orderController));

module.exports = router;
