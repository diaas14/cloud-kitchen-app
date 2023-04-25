const express = require("express");
const UserController = require("../controllers/user-controller");
const { verifyToken } = require("../services/auth-service");

const router = express.Router();

const userController = new UserController();

router.post("/:userId", verifyToken, userController.updateUser);

router.post("/", verifyToken, userController.createUser);

router.get("/:userId", verifyToken, userController.fetchUser);

module.exports = router;
