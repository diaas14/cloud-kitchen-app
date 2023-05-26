const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");
const multer = require("multer");

const ordersRoute = require("./routes/order-route");

const app = express();
const port = process.env.PORT || 4003;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

app.use(upload.any());

const serviceAccount = `${__dirname}/serviceAccountKey.json`;
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

app.use("/api/orders", ordersRoute);

app.listen(port, () => {
  console.log(`Orders microservice running on port ${port}`);
});
