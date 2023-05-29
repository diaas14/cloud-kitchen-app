const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");
const multer = require("multer");

const ordersRoute = require("./routes/order-route");

const rabbitmq = require("./rabbitmq");

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

async function startApp() {
  try {
    const { connection, channel } =
      await rabbitmq.establishConnectionAndChannel();

    app.listen(port, () => {
      console.log(`Orders microservice running on port ${port}`);
    });
  } catch (error) {
    console.error("Failed to start the app:", error);
    process.exit(1);
  }
}

startApp();

process.on("exit", async () => {
  const channel = rabbitmq.getChannel();
  const connection = rabbitmq.getConnection();
  await rabbitmq.closeConnectionAndChannel(channel, connection);
});
