const admin = require("firebase-admin");

class UserController {
  async createUser(req, res) {
    const { userId, email, name, photoUrl } = req.body;
    try {
      const newUserRef = admin.firestore().collection("users").doc(userId);
      await newUserRef.set({
        userId,
        email,
        name,
        ...(photoUrl && { photoUrl }),
      });
      res.status(201).json({ msg: "Registration complete" });
    } catch (err) {
      console.log(err);
      res.status(500).send(err);
    }
  }

  async fetchUser(req, res) {
    const userId = req.params.userId;
    try {
      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .get();
      if (!userDoc.exists) {
        res.status(404).json({ msg: "User not found" });
      } else {
        const userData = userDoc.data();
        res.status(200).json(userData);
      }
    } catch (err) {
      console.log(err);
      res.status(500).send(err);
    }
  }
}

module.exports = UserController;
