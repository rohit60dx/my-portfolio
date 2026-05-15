// api/fetch-app.js
import axios from 'axios';
import * as cheerio from 'cheerio';

export default async function handler(req, res) {
    res.setHeader('Access-Control-Allow-Credentials', true);
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', '*');

    if (req.method === 'OPTIONS') return res.status(200).end();

    try {
        let body = req.body;
        if (typeof body === 'string') body = JSON.parse(body);

        const playUrl = body?.playUrl || body?.playStoreUrl;

        if (!playUrl) {
            return res.status(400).json({ error: "playUrl is required" });
        }

        const { data } = await axios.get(playUrl, {
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36'
            },
            timeout: 15000
        });

        const $ = cheerio.load(data);

        const name = $('h1').first().text().trim() || "Unknown App";

        // Better Icon extraction
        let iconUrl = $('img[alt="Icon"]').attr('src') ||
            $('img[src*="icon"]').first().attr('src') ||
            $('meta[property="og:image"]').attr('content') || "";

        if (iconUrl.startsWith('//')) iconUrl = 'https:' + iconUrl;

        // Better Rating extraction
        const ratingText = $('div[aria-label*="star"]').first().text() ||
            $('.wVqUob').first().text() || "0";
        const rating = parseFloat(ratingText) || 0;

        // Category
        const category = $('a[href*="category"]').last().text().trim() || "Mobile App";

        const result = {
            name: name,
            shortDescription: $('meta[name="description"]').attr('content')?.trim() || "",
            description: "",
            iconUrl: iconUrl,
            screenshots: [],
            googleRating: rating,
            rating: rating,
            totalRatings: 0,
            downloads: 50,                    // temporary
            version: "Latest",
            size: "Varies with device",
            category: category,
            features: []
        };

        console.log("✅ Scraped:", name, "| Rating:", rating);
        return res.status(200).json(result);

    } catch (error) {
        console.error("Scraper Error:", error.message);
        return res.status(200).json({
            name: "App",
            shortDescription: "Data fetched but with limited info.",
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