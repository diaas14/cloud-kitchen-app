const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");
const multer = require("multer");
const rabbitmq = require("./rabbitmq");
const ordersRoute = require("./routes/order-route");
const OrderController = require("./controllers/order-controller");

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
  databaseURL: process.env.DB_URL,
});

app.use("/api/orders", ordersRoute);

rabbitmq
  .connect()
  .then(() => {
    const orderController = new OrderController();
    rabbitmq.consumeMessages(
      ["providerProfileUpdated", "customerProfileUpdated"],
      [
        orderController.updateProviderDataInOrder,
        orderController.updateCustomerDataInOrder,
      ]
    );

    app.listen(port, () => {
      console.log(`Orders microservice running on port ${port}`);
    });
  })
  .catch((error) => {
    console.error("Error connecting to RabbitMQ:", error);
  });
