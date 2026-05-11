const admin = require('firebase-admin');
const serviceAccount = require("./service-account.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const appData = {
  "name": "Notifly App",
  "shortDescription": "Student Parent Alerts & Reports for Teachers & Schools",
  "description": "Notifly is a communication app that helps teachers and schools save time while keeping families and coworkers informed.\n\nSend quick, personalized updates to parents through text or email in seconds. Whether it’s a parent reminder, student praise, or behavior comment, Notifly works instantly.\n\n• Send real-time updates in seconds\n• Use message templates for common messages\n• Deliver messages by text and email simultaneously\n• Engage more families in less time",
  "iconUrl": "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/b5/88/26/b58826fc-052a-8ed1-51e5-c3a00cefa6df/Placeholder.mill/400x400bb-75.webp",
  "screenshots": [
    "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/40/fe/c6/40fec62e-50c0-e9b5-4e0c-6674bc813556/IPHONE7-1.png/314x680bb.webp",
    "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/11/d5/e3/11d5e3d9-c744-6357-6391-16e4300faf89/IPHONE7-4.png/314x680bb.webp",
    "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/f4/51/58/f4515872-fad4-8498-7aa9-93de3d79ae27/IPHONE7-2.png/314x680bb.webp",
    "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/b7/1d/2b/b71d2b69-4c43-cdf4-9461-43fc266c2876/IPHONE7-3.png/314x680bb.webp",
    "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/5e/8b/76/5e8b7618-df2a-8bee-3c22-7590ec39b7b5/IPHONE7-5.png/314x680bb.webp"
  ],
  "rating": 5.0,
  "totalRatings": 2,
  "playStoreUrl": "",
  "appStoreUrl": "https://apps.apple.com/us/app/notifly-app/id6745785595",
  "androidApkUrl": "",
  "version": "1.0.1",
  "size": "",
  "category": "Education",
  "features": [
    "Parent Alerts",
    "Student Reports",
    "Quick Text & Email",
    "Message Templates",
    "Real-time Updates",
    "Teacher Communication"
  ],
  "downloads": null,
  "isPublished": true,
  "order": 8
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