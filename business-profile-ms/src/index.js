const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");
const multer = require("multer");

const businessProfileRoute = require("./routes/business-profile-route");

const rabbitmq = require("./rabbitmq");

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

async function startMicroservice() {
  try {
    const { channel } = await rabbitmq.establishConnectionAndChannel();

    await rabbitmq.consumeTransactionRequestMessages(channel);

    app.listen(port, () => {
      console.log(`Business profile microservice running on port ${port}`);
    });
  } catch (error) {
    console.error("Error starting the microservice:", error);
  }
}

startMicroservice();

process.on("exit", async () => {
  const channel = rabbitmq.getChannel();
  const connection = rabbitmq.getConnection();
  await rabbitmq.closeConnectionAndChannel(channel, connection);
});
