const admin = require("firebase-admin");

class BusinessProfileController {
  async createProfile(req, res) {
    const { userId, email, name, photoUrl } = req.body;
    try {
      const newUserRef = admin.firestore().collection("businesses").doc(userId);
      await newUserRef.set({
        email,
        name,
        ...(photoUrl && { photoUrl }),
      });
      res.status(201).json({ msg: "Registration complete" });
    } catch (err) {
      console.error(err);
      res
        .status(500)
        .send({ err: "An error occurred while creating the profile" });
    }
  }
}

module.exports = BusinessProfileController;
