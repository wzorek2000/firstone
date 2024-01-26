const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.checkInactiveUsers = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
  const userActivityRef = admin.firestore().collection('userActivity');
  const sevenDaysAgo = admin.firestore.Timestamp.fromDate(new Date(Date.now() - 7 * 24 * 60 * 60 * 1000));

  const inactiveUsers = await userActivityRef.where('lastActive', '<=', sevenDaysAgo).get();

  inactiveUsers.forEach(async (userDoc) => {
    const userData = userDoc.data();
    const fcmToken = userData.fcmToken;
    if (fcmToken) {
      await sendNotification(fcmToken, "Pamiętasz jeszcze o nas>=?", "Nie używałeś naszej aplikacji od ponad tygodnia, jak się dzisiaj czujesz?");
    }
  });

  return null;
});

async function sendNotification(fcmToken, title, body) {
  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: fcmToken,
  };

  try {
    await admin.messaging().send(message);
  } catch (error) {
    console.error("Error sending notification:", error);
  }
}



