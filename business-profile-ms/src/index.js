const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");

const businessProfileRoute = require("./routes/business-profile-route");

const app = express();
const port = process.env.PORT || 4001;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const serviceAccount = `${__dirname}/serviceAccountKey.json`;
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.DB_URL,
});

app.use("/api/business-profile", businessProfileRoute);

app.listen(port, () => {
  console.log(`Business profile microservice running on port ${port}`);
});
