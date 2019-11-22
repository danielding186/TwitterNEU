const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

exports.users = functions.https.onRequest((req, res) => {
  var userRef = admin.database().ref('/users');
  userRef.on("value", function(snapshot) {
    console.log(snapshot.val());
    res.status(200).json(snapshot.val());

  }, function (errorObject) {
    console.log("The read failed: " + errorObject.code);
  });
});

exports.addTweet = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const {body, uid, author} = req.body;
  const post = {'body': body, 'author':author};

  admin.database().ref('/tweets/' + uid).push(post);

  res.sendStatus(200);
});

exports.follow = functions.https.onRequest((req, res) => {
  const {uid, follower, dateTime} = req.body;
  const relation = {'uid':follower, 'dateTime':dateTime};

  admin.database().ref('following/' + uid).push(relation);

  res.sendStatus(200);
});

exports.unfollow = functions.https.onRequest((req, res) => {
  const {uid, relationID} = req.body;

  var relationRef = admin.database().ref('following/' + uid + '/' + relationID);
  relationRef.remove();

  res.sendStatus(200);
});

