/**
 * VIPER Dashboard — Cloudflare Worker Proxy
 *
 * Proxies GitHub and Codecov API requests with authentication.
 * Token is stored as an encrypted environment variable in Cloudflare.
 *
 * Setup:
 *   1. Create a Worker at workers.cloudflare.com
 *   2. Paste this code
 *   3. Add environment variable: GITHUB_TOKEN = <your fine-grained PAT>
 *   4. (Optional) Set ALLOWED_ORIGIN to your dashboard's domain
 *   5. Deploy
 *
 * Environment Variables:
 *   GITHUB_TOKEN    — Required. GitHub PAT with public_repo read scope.
 *   ALLOWED_ORIGIN  — Optional. CORS origin (default: "*").
 */

// ── Whitelist: only these path patterns are forwarded ──────────────
const GITHUB_PATH_PATTERNS = [
  // Actions workflow runs (landing + CI panel)
  /^\/repos\/casangi\/[a-zA-Z0-9._-]+\/actions\/workflows\/[a-zA-Z0-9._-]+\/runs/,
  // Actions runs (branch discovery + coverage CI row)
  /^\/repos\/casangi\/[a-zA-Z0-9._-]+\/actions\/runs/,
];

const CODECOV_PATH_PATTERNS = [
  // Repository-level coverage totals
  /^\/api\/v2\/github\/casangi\/repos\/[a-zA-Z0-9._-]+\/?$/,
];

// ── Handler ────────────────────────────────────────────────────────
export default {
  async fetch(request, env) {
    const origin = env.ALLOWED_ORIGIN || "*";
    const corsHeaders = {
      "Access-Control-Allow-Origin": origin,
      "Access-Control-Allow-Methods": "GET, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Expose-Headers":
        "X-RateLimit-Remaining, X-RateLimit-Limit, X-RateLimit-Reset",
    };

    // Handle CORS preflight
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: corsHeaders });
    }

    // Only GET allowed
    if (request.method !== "GET") {
      return jsonResponse(405, { error: "Method not allowed" }, corsHeaders);
    }

    const url = new URL(request.url);
    const path = url.pathname;

    // ── Route: /github/* → api.github.com ──────────────────────
    if (path.startsWith("/github/")) {
      const ghPath = path.replace(/^\/github/, "");
      const ghSearch = url.search;

      if (!GITHUB_PATH_PATTERNS.some((re) => re.test(ghPath))) {
        return jsonResponse(403, { error: "Path not allowed" }, corsHeaders);
      }

      if (!env.GITHUB_TOKEN) {
        return jsonResponse(500, { error: "GITHUB_TOKEN not configured" }, corsHeaders);
      }

      const upstream = `https://api.github.com${ghPath}${ghSearch}`;
      const resp = await fetch(upstream, {
        headers: {
          Authorization: `token ${env.GITHUB_TOKEN}`,
          Accept: "application/vnd.github.v3+json",
          "User-Agent": "viper-dashboard-proxy",
        },
      });

      const body = await resp.text();
      const headers = new Headers(corsHeaders);
      headers.set(
        "Content-Type",
        resp.headers.get("Content-Type") || "application/json"
      );

      // Pass through rate-limit headers
      for (const h of [
        "X-RateLimit-Remaining",
        "X-RateLimit-Limit",
        "X-RateLimit-Reset",
      ]) {
        if (resp.headers.has(h)) headers.set(h, resp.headers.get(h));
      }

      return new Response(body, { status: resp.status, headers });
    }

    // ── Route: /codecov/* → api.codecov.io ─────────────────────
    if (path.startsWith("/codecov/")) {
      const ccPath = path.replace(/^\/codecov/, "");

      if (!CODECOV_PATH_PATTERNS.some((re) => re.test(ccPath))) {
        return jsonResponse(403, { error: "Path not allowed" }, corsHeaders);
      }

      const upstream = `https://api.codecov.io${ccPath}${url.search}`;
      const resp = await fetch(upstream, {
        headers: {
          Accept: "application/json",
          "User-Agent": "viper-dashboard-proxy",
        },
      });

      const body = await resp.text();
      const headers = new Headers(corsHeaders);
      headers.set(
        "Content-Type",
        resp.headers.get("Content-Type") || "application/json"
      );

      return new Response(body, { status: resp.status, headers });
    }

    // ── Fallback ───────────────────────────────────────────────
    return jsonResponse(
      404,
      { error: "Unknown route. Use /github/* or /codecov/*" },
      corsHeaders
    );
  },
};

function jsonResponse(status, body, corsHeaders) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
