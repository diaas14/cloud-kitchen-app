const admin = require("firebase-admin");
const express = require("express");

const app = express();

const serviceAccount1 = `${__dirname}/serviceAccountKey1.json`;
const app1 = admin.initializeApp(
  {
    credential: admin.credential.cert(serviceAccount1),
  },
  "app1"
);

const serviceAccount2 = `${__dirname}/serviceAccountKey2.json`;
const app2 = admin.initializeApp(
  {
    credential: admin.credential.cert(serviceAccount2),
  },
  "app2"
);

async function verifyToken(idToken, projectId) {
  try {
    const firebaseApp = admin.app(projectId);
    const decodedToken = await firebaseApp.auth().verifyIdToken(idToken);
    return decodedToken;
  } catch (error) {
    throw new Error("Invalid token");
  }
}

app.get("/", async (req, res) => {
  res.send("Authorization service reachable");
});

app.get("/api/*", async (req, res) => {
  try {
    console.log("Request received");

    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      console.log("Unauthorized: No token provided");
      return res
        .status(401)
        .send({ message: "Unauthorized: No token provided" });
    }

    const token = authHeader.split(" ")[1];

    let decodedToken;
    try {
      decodedToken = await app1.auth().verifyIdToken(token);
    } catch (error) {
      try {
        decodedToken = await app2.auth().verifyIdToken(token);
      } catch (error) {
        console.log("Token verification error:", error);
        return res.status(401).send({ message: "Unauthorized: Invalid token" });
      }
    }

    console.log("Token verified for UID:", decodedToken.uid);
    res.status(200).send({ message: "Token verified" });
  } catch (error) {
    console.log("Unexpected error:", error);
    res.status(500).send({ message: "Unexpected error" });
  }
});

// Start the server
const port = process.env.PORT || 4002;

app.listen(port, () => {
  console.log(`Authorization microservice listening on port ${port}`);
});
