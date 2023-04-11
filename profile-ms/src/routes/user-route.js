const express = require("express");
const UserController = require("../controllers/user-controller");
const { verifyToken } = require("../services/auth-service");

const router = express.Router();

const userController = new UserController();

// router.post("/", verifyToken, userController.createUser);
router.post("/", userController.createUser);

router.get("/:userId", userController.fetchUser);

module.exports = router;
