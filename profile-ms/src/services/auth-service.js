const admin = require("firebase-admin");

async function verifyToken(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    console.log("Unauthorized: No token provided");
    return res.status(401).send("Unauthorized: No token provided");
  }

  const token = authHeader.split(" ")[1];

  try {
    await admin.auth().verifyIdToken(token);
    next();
  } catch (err) {
    return res.status(401).send("Unauthorized: Invalid token");
  }
}

module.exports = {
  verifyToken,
};
