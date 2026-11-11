# Phase 12 — Missing Integrations & External Credentials Audit

## Pre-Launch Environment Credentials Checklist
To complete final cloud deployment in production environments, populate the following environment secret keys:

- `GEMINI_API_KEY`: API Key for Google Gemini 1.5 Pro AI completions.
- `JUDGE0_RAPIDAPI_KEY`: RapidAPI Key for Judge0 multi-language code execution.
- `PAYMENT_WEBHOOK_SECRET`: Secret key for HMAC SHA-256 webhook signature verification.
- `GOOGLE_OAUTH_CLIENT_ID`: Web/Android/iOS Client ID for Google Sign-In.
