const express = require("express");
const BusinessProfileController = require("../controllers/business-profile-controller");

const router = express.Router();

const businessProfileController = new BusinessProfileController();

router.get("/", businessProfileController.fetchAllProfiles);
router.post("/", businessProfileController.createProfile);

router.get("/menu/:userId", businessProfileController.getMenuItems);

router.post(
  "/menu/:userId",
  businessProfileController.addItemToMenu.bind(businessProfileController)
);

// TODO
// use to edit menu item
router.put(
  "/menu/:itemId",
  businessProfileController.editMenuItem.bind(businessProfileController)
);

router.post(
  "/images/:userId",
  businessProfileController.uploadImages.bind(businessProfileController)
);

router.get("/:userId", businessProfileController.fetchProfile);
router.post(
  "/:userId",
  businessProfileController.updateProfile.bind(businessProfileController)
);

router.put("/transactions", businessProfileController.processTransaction);

module.exports = router;
