const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");

const usersRoute = require("./routes/user-route");

const app = express();
const port = process.env.PORT || 4000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const serviceAccount = `${__dirname}/serviceAccountKey.json`;
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.DB_URL,
});

app.use("/api/profile", usersRoute);

app.listen(port, () => {
  console.log(`Profile microservice running on port ${port}`);
});
