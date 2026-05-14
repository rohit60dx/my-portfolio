const admin = require('firebase-admin');
const serviceAccount = require("./service-account.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// ─── APNE SAARE PROJECTS YAHAN DALO ───────────────────────────
const projects = [

    // ── PROJECT 1 — LIVE ───────────────────────────────────────
    // {
    //     "title": "CurvUp",
    //     "description": "Globall is a comprehensive Sports mobile app for football clubs and teams. It helps players, parents, coaches, and managers stay connected through team chats, match schedules, training sessions, events, and club updates.",
    //     "category": "Sports",
    //     "technologies": ["Flutter", "Firebase"],
    //     "screenshots": [],
    //     "githubUrl": null,
    //     "liveUrl": "https://play.google.com/store/apps/details?id=app.globall.globallApp",
    //     "isProduction": true,
    //     "isFeatured": true,
    //     "order": 1
    // },

    // ── PROJECT 2 — LIVE ───────────────────────────────────────
    // {
    //     "title": "Doosra Project",
    //     "description": "Ye project kya karta hai uski description",
    //     "category": "Web App",
    //     "technologies": ["Flutter Web", "Firebase", "REST API"],
    //     "screenshots": [
    //         "https://your-screenshot-url.com/img.jpg"
    //     ],
    //     "githubUrl": "https://github.com/yourusername/project2",
    //     "liveUrl": "https://your-live-site.com",
    //     "isProduction": true,
    //     "isFeatured": false,
    //     "order": 2
    // },

    // ── PROJECT 3 — UPCOMING ───────────────────────────────────
    // {
    //     "title": "Upcoming Project Naam",
    //     "description": "Ye project abhi ban raha hai",
    //     "category": "Mobile App",
    //     "technologies": ["Flutter", "Dart", "Supabase"],
    //     "screenshots": [],               // khali rakho ya wireframe URL
    //     "githubUrl": null,
    //     "liveUrl": null,
    //     "isProduction": false,           // false = Upcoming badge
    //     "isFeatured": false,
    //     "order": 3
    // },





    {
        "title": "CurvUp",
        "description": "CurvUp is an AI-powered GPS navigation system for startups and scaleups. It acts as a personal AI guide (CINA) for founders, helping them navigate critical challenges in legal, finance, hiring, fundraising, marketing, and operations with sequenced recommendations, curated experts, and investors.",
        "category": "Web + Mobile App",
        "technologies": ["Next.js", "AI/ML", "Firebase", "Tailwind CSS"],
        "screenshots": [],
        "githubUrl": null,
        "liveUrl": "https://www.curvup.io",
        "isProduction": false,
        "isFeatured": false,
        "order": 2
    }
    // ── AUR PROJECTS ADD KARO SAME FORMAT ME ──────────────────

];

// ─── UPLOAD FUNCTION ───────────────────────────────────────────
async function uploadProjects() {
    console.log(`🚀 ${projects.length} projects upload ho rahe hain...`);

    for (const project of projects) {
        try {
            const res = await db.collection('projects').add(project);
            console.log(`✅ "${project.title}" uploaded — ID: ${res.id}`);
        } catch (error) {
            console.error(`❌ "${project.title}" upload failed:`, error.message);
        }
    }

    console.log('\n🎉 Sab ho gaya!');
    process.exit(0);
}

uploadProjects();