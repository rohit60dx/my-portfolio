const admin = require('firebase-admin');
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const appData = {
  "name": "Globall",
  "shortDescription": "Football team management app for players, parents, coaches & managers with chats, schedules & event updates.",
  "description": "Globall helps football clubs and teams stay organised and connected.\n\nWith Globall, players, parents, coaches, and team managers can:\n• Communicate through structured team chats\n• View match schedules, training sessions, and club events\n• Access detailed event and training camp information\n\nClub administration is handled via the web platform. Perfect for real-world football team coordination.",
  "iconUrl": "https://play-lh.googleusercontent.com/r3vHMktfMh82B1QG7aGs-xE5DieMX-WSAyqRJ5cTBpUOyrWd06gsZmCSq4-qGqrRNDy0vlmk-7jIvU1wtfyHTu0=w480-h960-rw",
  "screenshots": [
    "https://play-lh.googleusercontent.com/1-UUeJcRZjT94D8PZXd9RaFm8xk0NwGSJ19c8hRCXJAFWaXErcj6VPF8wg7Vt4NBRiruy8VAB0uYgoNi29--TbQ=w1052-h592-rw",
    "https://play-lh.googleusercontent.com/1-UUeJcRZjT94D8PZXd9RaFm8xk0NwGSJ19c8hRCXJAFWaXErcj6VPF8wg7Vt4NBRiruy8VAB0uYgoNi29--TbQ=w1052-h592-rw",
    "https://play-lh.googleusercontent.com/BmdOmkkGbG_apSJn7WK0wX2L2jgn6iN8U3GYYt3_QAQJqouURP3tLyW6UruKssDt7y4ovwjLnX-DYa2-D6Euvg=w1052-h592-rw"
  ],
  "rating": 4.5,
  "totalRatings": 100,
  "playStoreUrl": "https://play.google.com/store/apps/details?id=app.globall.globallApp",
  "appStoreUrl": null,
  "androidApkUrl": null,
  "version": "Latest",
  "size": "Varies with device",
  "category": "Sports",
  "features": [
    "Team Chat",
    "Match Schedules",
    "Training Sessions",
    "Event Management",
    "Club Communication",
    "Real-time Updates"
  ],
  "downloads": 5000,
  "isPublished": true,
  "order": 7
};

async function uploadAppData() {
  try {
    const res = await db.collection('apps').add(appData);
    console.log('✅ Document successfully added with ID:', res.id);
  } catch (error) {
    console.error('❌ Error adding document:', error);
  }
}

uploadAppData();