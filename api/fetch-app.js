// api/fetch-app.js
import axios from 'axios';
import * as cheerio from 'cheerio';

export default async function handler(req, res) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    try {
        const { playUrl, appleUrl } = req.body;

        let result = {
            name: "",
            shortDescription: "",
            description: "",
            iconUrl: "",
            screenshots: [],
            rating: 0,
            totalRatings: 0,
            downloads: 0,
            version: "",
            size: "",
            category: "",
            googleRating: 0,
            appleRating: 0,
            googleDownloads: 0,
            appleDownloads: 0
        };

        // Play Store Scraping
        if (playUrl) {
            try {
                const { data } = await axios.get(playUrl, {
                    headers: { 'User-Agent': 'Mozilla/5.0' }
                });
                const $ = cheerio.load(data);

                result.name = $('h1').first().text().trim() || "";
                result.shortDescription = $('meta[name="description"]').attr('content') || "";
                result.iconUrl = $('img[alt="Icon"]').attr('src') || $('img').first().attr('src') || "";

                // Rating
                const ratingText = $('div[aria-label*="star"]').text() || "";
                result.googleRating = parseFloat(ratingText) || 0;

                result.category = $('a[href*="category"]').last().text().trim() || "App";

            } catch (e) {
                console.log("Play Store error:", e.message);
            }
        }

        res.status(200).json(result);

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
}