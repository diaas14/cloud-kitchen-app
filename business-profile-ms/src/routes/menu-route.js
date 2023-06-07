const express = require("express");
const MenuController = require("../controllers/menu-controller");

const router = express.Router();

const menuController = new MenuController();

router.get("/:userId", menuController.getMenuItems);

router.post("/:userId", menuController.addItemToMenu.bind(menuController));

router.put("/:itemId", menuController.editMenuItem.bind(menuController));

router.get(
  "/food-provider/:searchVal",
  menuController.fetchMenuItemsByProviderName.bind(menuController)
);

router.get(
  "/menu-item/:searchVal",
  menuController.fetchMenuItemsByItemName.bind(menuController)
);

router.get(
  "/category/:categoryId",
  menuController.fetchMenuItemsByCategory.bind(menuController)
);

module.exports = router;
