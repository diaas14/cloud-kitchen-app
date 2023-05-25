const express = require("express");
const OrderController = require("../controllers/order-controller");

const router = express.Router();

const orderController = new OrderController();

router.post("/", userController.createOrder);

module.exports = router;
