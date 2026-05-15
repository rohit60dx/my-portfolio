// api/fetch-app.js
import axios from 'axios';
import * as cheerio from 'cheerio';

export default async function handler(req, res) {
    // CORS Headers
    res.setHeader('Access-Control-Allow-Credentials', true);
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
    res.setHeader('Access-Control-Allow-Headers', '*');

    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    try {
        let playUrl = null;

        // Body parsing ke different tarike
        if (req.body) {
            if (typeof req.body === 'string') {
                const parsed = JSON.parse(req.body);
                playUrl = parsed.playUrl || parsed.playStoreUrl;
            } else {
                playUrl = req.body.playUrl || req.body.playStoreUrl;
            }
        }

        if (!playUrl) {
            return res.status(400).json({
                error: "playUrl is required",
                receivedBody: req.body
            });
        }

        console.log("Fetching:", playUrl);

        const { data } = await axios.get(playUrl, {
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            },
            timeout: 10000
        });

        const $ = cheerio.load(data);

        const name = $('h1').first().text().trim() || "Unknown App";
        const iconUrl = $('img[alt="Icon"]').attr('src') || $('img[src*="icon"]').first().attr('src') || "";
        const ratingText = $('div[aria-label*="star"]').first().text() || "0";
        const rating = parseFloat(ratingText.replace(',', '.')) || 0;

        const result = {
            name: name,
            shortDescription: $('meta[name="description"]').attr('content')?.trim() || "",
            description: "",
            iconUrl: iconUrl.startsWith('//') ? 'https:' + iconUrl : iconUrl,
            screenshots: [],
            googleRating: rating,
            rating: rating,
            totalRatings: 0,
            downloads: 0,
            version: "Latest",
            size: "Varies with device",
            category: "Mobile App",
            features: []
        };

        res.status(200).json(result);

    } catch (error) {
        console.error("Error:", error.message);
        res.status(200).json({
            name: "App",
            shortDescription: "Data fetch karne mein issue aa raha hai.",
            description: "",
            iconUrl: "",
            screenshots: [],
            rating: 0,
            totalRatings: 0,
            downloads: 0,
            version: "Latest",
            size: "",
            category: "Mobile App"
        });
    }
}