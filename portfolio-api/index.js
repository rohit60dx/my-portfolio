const { onRequest } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const gplay = require("google-play-scraper");
const store = require("app-store-scraper");
const cors = require("cors")({ origin: true });

setGlobalOptions({ region: "us-central1" });

// ─────────────────────────────────────────────
// Helper: Play Store app ID from URL or raw ID
// e.g. "com.example.app"
// or   "https://play.google.com/store/apps/details?id=com.example.app"
// ─────────────────────────────────────────────
function extractPlayId(input) {
    input = input.trim();
    try {
        const url = new URL(input);
        return url.searchParams.get("id") || input;
    } catch {
        return input; // already a raw ID
    }
}

// Helper: App Store app ID from URL or raw numeric ID
// e.g. "123456789"
// or   "https://apps.apple.com/us/app/appname/id123456789"
function extractAppleId(input) {
    input = input.trim();
    const match = input.match(/\/id(\d+)/);
    if (match) return match[1];
    return input; // assume raw numeric id
}

// ─────────────────────────────────────────────
// Cloud Function: fetchAppDetails
// POST { playUrl?, appleUrl? }
// Returns merged app details
// ─────────────────────────────────────────────
exports.fetchAppDetails = onRequest(async (req, res) => {
    cors(req, res, async () => {
        if (req.method !== "POST") {
            return res.status(405).json({ error: "Method not allowed. Use POST." });
        }

        const { playUrl, appleUrl } = req.body;

        if (!playUrl && !appleUrl) {
            return res
                .status(400)
                .json({ error: "Provide at least playUrl or appleUrl in request body." });
        }

        let playData = null;
        let appleData = null;
        const errors = {};

        // ── Fetch from Play Store ──────────────────
        if (playUrl) {
            try {
                const appId = extractPlayId(playUrl);
                const raw = await gplay.app({
                    appId,
                    lang: "en",
                    country: "in",
                });

                playData = {
                    name: raw.title,
                    shortDescription: raw.summary || "",
                    description: raw.description || "",
                    iconUrl: raw.icon || "",
                    screenshots: raw.screenshots || [],
                    rating: raw.score || 0,
                    totalRatings: raw.ratings || 0,
                    downloads: parseDownloads(raw.installs),
                    version: raw.version || "",
                    size: raw.size || "",
                    category: raw.genre || "",
                    developer: raw.developer || "",
                    playStoreUrl: raw.url || playUrl,
                };
            } catch (e) {
                errors.play = e.message;
            }
        }

        // ── Fetch from App Store ───────────────────
        if (appleUrl) {
            try {
                const appId = extractAppleId(appleUrl);
                const raw = await store.app({ id: appId, country: "in" });

                appleData = {
                    name: raw.title,
                    shortDescription: raw.description?.slice(0, 120) || "",
                    description: raw.description || "",
                    iconUrl: raw.icon || "",
                    screenshots: raw.screenshots || [],
                    rating: raw.score || 0,
                    totalRatings: raw.reviews || 0,
                    version: raw.version || "",
                    size: raw.size || "",
                    category: raw.primaryGenre || "",
                    developer: raw.developer || "",
                    appStoreUrl: raw.url || appleUrl,
                };
            } catch (e) {
                errors.apple = e.message;
            }
        }

        // ── Merge: Play Store is primary, Apple fills gaps ──
        const merged = {
            ...(playData || {}),
            ...(appleData
                ? {
                    appStoreUrl: appleData.appStoreUrl,
                    // Fill empty fields from Apple if Play didn't provide
                    name: playData?.name || appleData.name,
                    shortDescription:
                        playData?.shortDescription || appleData.shortDescription,
                    description: playData?.description || appleData.description,
                    iconUrl: playData?.iconUrl || appleData.iconUrl,
                    screenshots:
                        playData?.screenshots?.length
                            ? playData.screenshots
                            : appleData.screenshots,
                    rating: playData?.rating || appleData.rating,
                    totalRatings: playData?.totalRatings || appleData.totalRatings,
                    category: playData?.category || appleData.category,
                    developer: playData?.developer || appleData.developer,
                }
                : {}),
            errors: Object.keys(errors).length ? errors : undefined,
        };

        return res.status(200).json(merged);
    });
});

// ─────────────────────────────────────────────
// Helper: "1,000,000+" → 1000000
// ─────────────────────────────────────────────
function parseDownloads(installs) {
    if (!installs) return 0;
    const clean = installs.replace(/[^0-9]/g, "");
    return parseInt(clean, 10) || 0;
}