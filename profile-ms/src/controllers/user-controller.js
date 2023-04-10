const admin = require("firebase-admin");

class UserController {
  async createUser(req, res) {
    const { userId, email, name } = req.body;
    console.log(req.body);
    try {
      const newUserRef = admin.firestore().collection("users").doc(userId);
      await newUserRef.set({
        userId: userId,
        name: name,
        email: email,
      });
      res.status(201).json({ msg: "Registration complete" });
    } catch (err) {
      console.log(err);
      res.status(500).send(err);
    }
  }
}

module.exports = UserController;
