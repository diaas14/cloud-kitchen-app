const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");
const multer = require("multer");

const businessProfileRoute = require("./routes/business-profile-route");

const app = express();
const port = process.env.PORT || 4001;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

app.use(upload.any());

const serviceAccount = `${__dirname}/serviceAccountKey.json`;
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.DB_URL,
  storageBucket: "business-profile-cb5ad.appspot.com",
});

app.use("/api/business-profile", businessProfileRoute);

app.listen(port, () => {
  console.log(`Business profile microservice running on port ${port}`);
});
