const admin = require("firebase-admin");

class MenuController {
  async uploadImageToStorage(file) {
    const bucket = admin.storage().bucket();
    const fileName = `${Date.now()}_${file.originalname}`;
    const fileUpload = bucket.file(fileName);

    const blobStream = fileUpload.createWriteStream({
      metadata: {
        contentType: file.mimetype,
      },
    });

    blobStream.on("error", (error) => {
      throw new Error(error);
    });

    await new Promise((resolve, reject) => {
      blobStream.on("finish", () => {
        fileUpload.makePublic((err) => {
          if (err) {
            return reject(err);
          }
          const publicUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
          resolve(publicUrl);
        });
      });

      blobStream.end(file.buffer);
    });

    return `https://storage.googleapis.com/${bucket.name}/${fileName}`;
  }

  async addItemToMenu(req, res) {
    console.log("Received by addItemToMenu");
    try {
      const {
        userId,
        itemName = null,
        itemDescription = null,
        itemPrice = null,
        itemQuantity = null,
        itemTags = null,
      } = req.body;

      console.log(itemTags);
      const itemTagsList = JSON.parse(itemTags);
      const menuRef = admin.firestore().collection("menu");
      const newItemRef = menuRef.doc();

      var imageUrl = null;
      if (req.files) {
        imageUrl = req.files[0]
          ? await this.uploadImageToStorage.call(this, req.files[0])
          : null;
      }

      const newItem = {
        itemId: newItemRef.id,
        providerId: userId,
        ...(imageUrl && { itemImgUrl: imageUrl }),
        ...(itemName && { itemName }),
        ...(itemDescription && { itemDescription }),
        ...(itemPrice && { itemPrice: parseFloat(itemPrice) }),
        ...(itemQuantity && { itemQuantity: parseInt(itemQuantity) }),
        ...(itemTags && { itemTags: itemTagsList }),
      };

      await newItemRef.set(newItem);

      res
        .status(200)
        .json({ success: true, message: "Item added to menu collection" });
    } catch (error) {
      console.error(error);
      res.status(500).json({
        success: false,
        message: "Error adding item to menu collection",
      });
    }
  }

  async getMenuItems(req, res) {
    try {
      var menuItems = [];
      const userId = req.params.userId;
      const menuRef = admin.firestore().collection("menu");
      const query = menuRef.where("providerId", "==", userId);

      const snapshot = await query.get();

      if (snapshot.empty) {
        console.log("No matching documents.");
      } else {
        snapshot.forEach((doc) => {
          const menuItem = doc.data();
          menuItems.push(menuItem);
        });
      }
      res.status(200).json({ success: true, menu: menuItems });
    } catch (error) {
      console.error(error);
      res
        .status(500)
        .json({ success: false, message: "Error fetching menu items" });
    }
  }

  async editMenuItem(req, res) {
    console.log("Received by editMenuItem");
    try {
      const itemId = req.params.itemId;
      console.log(itemId);

      const {
        itemName = null,
        itemDescription = null,
        itemPrice = null,
        itemQuantity = null,
      } = req.body;

      const menuRef = admin.firestore().collection("menu");
      const itemDoc = await menuRef.doc(itemId).get();

      if (!itemDoc.exists) {
        return res.status(404).json({ msg: "Item not found" });
      }

      var imageUrl = null;

      if (req.files) {
        imageUrl = req.files[0]
          ? await this.uploadImageToStorage.call(this, req.files[0])
          : null;
      }

      const updatedFields = {
        ...(imageUrl && { itemImgUrl: imageUrl }),
        ...(itemName && { itemName }),
        ...(itemDescription && { itemDescription }),
        ...(itemPrice && { itemPrice: parseFloat(itemPrice) }),
        ...(itemQuantity && { itemQuantity: parseInt(itemQuantity) }),
      };

      await itemDoc.ref.update(updatedFields);

      res
        .status(200)
        .json({ success: true, message: "Item updated in menu collection" });
    } catch (error) {
      console.error(error);
      res.status(500).json({
        success: false,
        message: "Error editing item in menu collection",
      });
    }
  }

  async fetchMenuItemsByCategory(req, res) {
    const category = req.params.category;
    try {
      const db = admin.firestore();
      const querySnapshot = await db
        .collection("menu")
        .where("itemTags", "array-contains", category)
        .get();

      const menuItems = [];

      querySnapshot.forEach((doc) => {
        const menuItem = doc.data();
        menuItems.push(menuItem);
      });

      res.status(200).json({ success: true, menu: menuItems });
    } catch (error) {
      console.error(error);
      res
        .status(500)
        .json({ success: false, message: "Error fetching menu items" });
    }
  }

  async fetchMenuItemsByProviderName(req, res) {
    console.log("fetchMenuItemsByProviderName executed");
    const businessName = req.params.searchVal;
    try {
      const db = admin.firestore();
      const querySnapshot = await db
        .collection("businesses")
        .where("businessName", ">=", businessName)
        .where("businessName", "<=", businessName + "\uf8ff")
        .get();

      const businesses = [];
      querySnapshot.forEach((doc) => {
        const business = doc.data();
        businesses.push(business);
      });

      res.status(200).json({ success: true, searchResult: businesses });
    } catch (error) {
      console.error(error);
      res
        .status(500)
        .json({ success: false, message: "Error fetching Food Providers." });
    }
  }

  async fetchMenuItemsByItemName(req, res) {
    console.log("fetchMenuItemsByItemName executed");
    const itemName = req.params.searchVal;
    try {
      const db = admin.firestore();
      const querySnapshot = await db
        .collection("menu")
        .where("itemName", ">=", itemName)
        .where("itemName", "<=", itemName + "\uf8ff")
        .get();

      const items = [];
      querySnapshot.forEach((doc) => {
        const item = doc.data();
        items.push(item);
      });

      res.status(200).json({ success: true, searchResult: items });
    } catch (error) {
      console.error(error);
      res
        .status(500)
        .json({ success: false, message: "Error fetching Food Providers." });
    }
  }

  async deleteMenuItem(req, res) {
    try {
      const itemId = req.params.itemId;

      const menuRef = admin.firestore().collection("menu");
      const itemDoc = await menuRef.doc(itemId).get();

      if (!itemDoc.exists) {
        return res.status(404).json({ msg: "Item not found" });
      }

      await menuRef.doc(itemId).delete();
      res
        .status(200)
        .json({ success: true, message: "Item deleted from menu collection" });
    } catch (error) {
      console.error(error);
      res.status(500).json({
        success: false,
        message: "Error deleting item from menu collection",
      });
    }
  }
}
module.exports = MenuController;
