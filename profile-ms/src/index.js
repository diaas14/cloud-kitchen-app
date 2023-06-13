const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");
const multer = require("multer");
const rabbitmq = require("./rabbitmq");

const usersRoute = require("./routes/user-route");

const app = express();
const port = process.env.PORT || 4000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

app.use(upload.any());

const serviceAccount = `${__dirname}/serviceAccountKey.json`;
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.DB_URL,
  storageBucket: "cloud-kitchen-4d39e.appspot.com",
});

app.use("/api/profile", usersRoute);

app.get("/", async (req, res) => {
  res.send("Profile Microservice is Reachable.");
});

rabbitmq
  .connect()
  .then(() => {
    app.listen(port, () => {
      console.log(`Profile microservice running on port ${port}`);
    });
  })
  .catch((error) => {
    console.error("Error connecting to RabbitMQ:", error);
  });
