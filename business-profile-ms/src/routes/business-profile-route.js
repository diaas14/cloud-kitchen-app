const express = require("express");
const BusinessProfileController = require("../controllers/business-profile-controller");

const router = express.Router();

const businessProfileController = new BusinessProfileController();

router.get("/", businessProfileController.fetchAllProfiles);
router.post("/", businessProfileController.createProfile);

router.post(
  "/images/:userId",
  businessProfileController.uploadImages.bind(businessProfileController)
);

router.get("/:userId", businessProfileController.fetchProfile);

router.put("/transactions", businessProfileController.processTransaction);

router.put(
  "/:userId",
  businessProfileController.updateProfile.bind(businessProfileController)
);

module.exports = router;
