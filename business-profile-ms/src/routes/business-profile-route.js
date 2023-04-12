const express = require("express");
const BusinessProfileController = require("../controllers/business-profile-controller");

const router = express.Router();

const businessProfileController = new BusinessProfileController();

router.post("/", businessProfileController.createProfile);

router.get("/:userId", businessProfileController.fetchProfile);

module.exports = router;
