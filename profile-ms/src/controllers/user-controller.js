const admin = require("firebase-admin");

class UserController {
  async createUser(req, res) {
    const { userId, email, name, photoUrl } = req.body;

    try {
      const newUserRef = admin.firestore().collection("users").doc(userId);
      await newUserRef.set({
        email,
        name,
        ...(photoUrl && { photoUrl }),
      });
      console.log("Registration complete");
      res.status(201).json({ msg: "Registration complete" });
    } catch (err) {
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
        delete userData.userId;
        res.status(200).json(userData);
      }
    } catch (err) {
      res.status(500).send(err);
    }
  }

  async updateUser(req, res) {
    const userId = req.params.userId;
    try {
      const userDocRef = admin.firestore().collection("users").doc(userId);
      if (!(await userDocRef.get()).exists) {
        res.status(404).json({ msg: "User not found" });
      }
      let imageURL = null;
      const file = req.files[0];
      if (file) {
        const bucket = admin.storage().bucket();
        const fileName = `${Date.now()}_${file.originalname}`;
        const fileUpload = bucket.file(fileName);

        const blobStream = fileUpload.createWriteStream({
          metadata: {
            contentType: file.mimetype,
          },
        });

        blobStream.on("error", (error) => {
          res.status(500).send({ error: error });
        });

        blobStream.on("finish", () => {
          fileUpload.makePublic((err) => {
            if (err) {
              return res.status(500).send(err);
            }
            const publicUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
            imageURL = publicUrl;
            userDocRef.update({ photoUrl: imageURL, ...req.body });
            return res.status(200).json({
              message: "User successfully updated.",
            });
          });
        });

        blobStream.end(file.buffer);
      } else {
        await userDocRef.update(req.body);
        res.status(200).json("User successfully updated.");
      }
    } catch (err) {
      res.status(500).send(err);
    }
  }
}

module.exports = UserController;
