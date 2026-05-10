const express = require('express');
const cors = require('cors');
const gplay = require('google-play-scraper');

const app = express();
app.use(cors({ origin: '*' }));
app.use(express.json());

// Helper: Play Store app ID from URL or raw ID
function extractPlayId(input) {
    input = input.trim();
    try {
        const url = new URL(input);
        return url.searchParams.get('id') || input;
    } catch {
        return input;
    }
}

// Helper: App Store numeric ID from URL or raw ID
function extractAppleId(input) {
    input = input.trim();
    const match = input.match(/\/id(\d+)/);
    if (match) return match[1];
    return input;
}

// Helper: "1,000,000+" → 1000000
function parseDownloads(installs) {
    if (!installs) return 0;
    return parseInt(installs.replace(/[^0-9]/g, ''), 10) || 0;
}

// POST /fetch-app
// Body: { playUrl?, appleUrl? }
app.post('/fetch-app', async (req, res) => {
    const { playUrl, appleUrl } = req.body;

    if (!playUrl && !appleUrl) {
        return res.status(400).json({ error: 'playUrl ya appleUrl dono mein se ek do' });
    }

    let playData = null;
    let appleData = null;
    const errors = {};

    // Fetch from Play Store
    if (playUrl) {
        try {
            const appId = extractPlayId(playUrl);
            const raw = await gplay.app({ appId, lang: 'en', country: 'in' });
            playData = {
                name: raw.title,
                shortDescription: raw.summary || '',
                description: raw.description || '',
                iconUrl: raw.icon || '',
                screenshots: raw.screenshots || [],
                rating: raw.score || 0,
                totalRatings: raw.ratings || 0,
                downloads: parseDownloads(raw.installs),
                version: raw.version || '',
                size: raw.size || '',
                category: raw.genre || '',
                developer: raw.developer || '',
                playStoreUrl: raw.url || playUrl,
            };
        } catch (e) {
            errors.play = e.message;
        }
    }

    // Fetch from App Store
    if (appleUrl) {
        try {
            const appId = extractAppleId(appleUrl);
            const raw = await store.app({ id: appId, country: 'in' });
            appleData = {
                name: raw.title,
                shortDescription: raw.description?.slice(0, 120) || '',
                description: raw.description || '',
                iconUrl: raw.icon || '',
                screenshots: raw.screenshots || [],
                rating: raw.score || 0,
                totalRatings: raw.reviews || 0,
                version: raw.version || '',
                size: raw.size || '',
                category: raw.primaryGenre || '',
                developer: raw.developer || '',
                appStoreUrl: raw.url || appleUrl,
            };
        } catch (e) {
            errors.apple = e.message;
        }
    }

    // Merge (Play Store primary)
    const merged = {
        name: playData?.name || appleData?.name || '',
        shortDescription: playData?.shortDescription || appleData?.shortDescription || '',
        description: playData?.description || appleData?.description || '',
        iconUrl: playData?.iconUrl || appleData?.iconUrl || '',
        screenshots: playData?.screenshots?.length ? playData.screenshots : (appleData?.screenshots || []),
        rating: playData?.rating || appleData?.rating || 0,
        totalRatings: playData?.totalRatings || appleData?.totalRatings || 0,
        downloads: playData?.downloads || 0,
        version: playData?.version || appleData?.version || '',
        size: playData?.size || appleData?.size || '',
        category: playData?.category || appleData?.category || '',
        developer: playData?.developer || appleData?.developer || '',
        playStoreUrl: playData?.playStoreUrl || null,
        appStoreUrl: appleData?.appStoreUrl || null,
        ...(Object.keys(errors).length ? { errors } : {}),
    };

    return res.status(200).json(merged);
});

// Health check
app.get('/', (req, res) => res.json({ status: 'ok', message: 'Portfolio API running' }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));