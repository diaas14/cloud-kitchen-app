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

  // async updateProfile(req, res) {
  //   const userId = req.params.userId;
  //   const { businessName, locationData, address } = req.body;
  //   const { latitude, longitude } = JSON.parse(locationData);
  //   const addressData = JSON.parse(address);
  //   const geoPoint = new admin.firestore.GeoPoint(latitude, longitude);
  //   try {
  //     const newUserRef = admin.firestore().collection("businesses").doc(userId);
  //     await newUserRef.update({
  //       businessName,
  //       location: geoPoint,
  //       address: addressData,
  //     });
  //     res.status(200).json({ msg: "Update complete" });
  //   } catch (err) {
  //     console.error(err);
  //     res
  //       .status(500)
  //       .send({ err: "An error occurred while updating the profile" });
  //   }
  // }

  getLocation(locationData) {
    const { latitude, longitude } = JSON.parse(locationData);
    return new admin.firestore.GeoPoint(latitude, longitude);
  }

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

  async updateProfile(req, res) {
    console.log(req.body);
    const userId = req.params.userId;
    const {
      businessName = null,
      locationData = null,
      address = null,
    } = req.body;
    console.log(req.params.userId);

    try {
      const userDocRef = admin.firestore().collection("businesses").doc(userId);
      const userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        return res.status(404).json({ msg: "Business User not found" });
      }

      var imageUrl = null;
      if (req.files) {
        imageUrl = req.files[0]
          ? await this.uploadImageToStorage.call(this, req.files[0])
          : null;
      }

      const data = {
        ...(imageUrl && { businessLogo: imageUrl }),
        ...(businessName && { businessName }),
        ...(locationData && {
          location: this.getLocation.call(this, locationData),
        }),
        ...(address && { address: JSON.parse(address) }),
      };
      console.log(data);
      await userDocRef.update(data);

      res.status(200).json("User successfully updated.");
    } catch (err) {
      console.log(err);
      res.status(500).send(err);
    }
  }

  async fetchProfile(req, res) {
    const userId = req.params.userId;
    try {
      const userDoc = await admin
        .firestore()
        .collection("businesses")
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

  async fetchAllProfiles(req, res) {
    console.log("Request receieved");
    try {
      const snapshot = await admin.firestore().collection("businesses").get();
      const profiles = [];
      snapshot.forEach((doc) => {
        profiles.push(doc.data());
      });
      res.status(200).json(profiles);
    } catch (err) {
      console.log(err);
      res.status(500).send(err);
    }
  }

  async uploadImages(req, res) {
    const files = req.files;
    const userId = req.params.userId;
    const userRef = admin.firestore().collection("businesses").doc(userId);
    var urls = await userRef.get().then((doc) => doc.data().businessPicsUrls);
    if (!urls) {
      urls = [];
    }
    try {
      for (const file of files) {
        const url = await this.uploadImageToStorage.call(this, file);
        urls.push(url);
      }
      await userRef.update({ businessPicsUrls: urls });
      res.send({ urls });
    } catch (error) {
      console.error(error);
      console.log(err);
      res.status(500).send({ error: "Failed to upload images" });
    }
  }
}

module.exports = BusinessProfileController;
