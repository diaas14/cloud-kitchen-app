const express = require("express");
const UserController = require("../controllers/user-controller");

const router = express.Router();

const userController = new UserController();

router.post("/:userId", userController.updateUser);

router.post("/", userController.createUser);

router.get("/:userId", userController.fetchUser);

module.exports = router;
