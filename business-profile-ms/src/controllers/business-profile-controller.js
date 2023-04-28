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

  async updateProfile(req, res) {
    const userId = req.params.userId;
    const { businessName, locationData } = req.body;
    const { latitude, longitude } = JSON.parse(locationData);
    const geoPoint = new admin.firestore.GeoPoint(latitude, longitude);
    try {
      const newUserRef = admin.firestore().collection("businesses").doc(userId);
      await newUserRef.update({
        businessName,
        location: geoPoint,
      });
      res.status(200).json({ msg: "Update complete" });
    } catch (err) {
      console.error(err);
      res
        .status(500)
        .send({ err: "An error occurred while updating the profile" });
    }
  }
}

module.exports = BusinessProfileController;
