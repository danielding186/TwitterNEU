const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

exports.users = functions.https.onRequest((req, res) => {
  var userRef = admin.database().ref('/users');
  userRef.once("value", function(snapshot) {
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

  console.log('addTweet::' + body + 'uid=' + uid + 'author=' + author)

  admin.database().ref('/tweets/' + uid).push(post);

  res.status(200).json({'success':1});
});

exports.myTweets = functions.https.onRequest((req, res) => {
  const {uid} = req.query;
  var ref = admin.database().ref('/tweets/' + uid);
  ref.once("value", (snapshot) => {
    res.status(200).json(snapshot.val());
  });
});

exports.relationship = functions.https.onRequest((req, res) => {
  const {uid, followerId} = req.query;
  console.log('relationship:' + uid + ' ' + followerId);

  var ref = admin.database().ref('/following/' + uid);
  ref.orderByChild("uid").equalTo(followerId).once("value", (snapshot) => {
    if (snapshot.val() === null) {
      res.status(200).json({'followed':0});
    } else {
      var items = {};
      items['followed'] = 1;
      snapshot.forEach(function(childSnapshot) {
        items['relationID'] = childSnapshot.key;
      });
      res.status(200).json(items);
    }});
});

exports.followers = functions.https.onRequest((req, res) => {
  const {uid} = req.query;
  console.log('followers:' + uid);

  var ref = admin.database().ref('/following/' + uid);
  ref.once("value", (snapshot) => {
    res.status(200).json(snapshot.val());
  });
});



exports.follow = functions.https.onRequest((req, res) => {
  const {uid, followerId} = req.body;
  const relation = {'uid':followerId, 'dateTime':admin.database.ServerValue.TIMESTAMP};
  var ref = admin.database().ref('following/' + uid);
  var followingRef = ref.push();
  followingRef.set(relation);
  console.log('followingRef:' + followingRef.key);
  res.status(200).json({"relationID":followingRef.key});
});

exports.unfollow = functions.https.onRequest((req, res) => {
  const {uid, relationID} = req.body;

  var relationRef = admin.database().ref('following/' + uid + '/' + relationID);
  relationRef.remove();

  res.status(200).json({'success':1});
});

