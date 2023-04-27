const express = require("express");
const BusinessProfileController = require("../controllers/business-profile-controller");
const { verifyToken } = require("../services/auth-service.js");

const router = express.Router();

const businessProfileController = new BusinessProfileController();

router.post("/", verifyToken, businessProfileController.createProfile);

module.exports = router;
