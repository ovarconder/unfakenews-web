#!/bin/bash

# Test NextAuth endpoints
echo "🧪 Testing NextAuth API endpoints..."
echo ""

BASE_URL="${1:-https://unfakenews.asia}"

echo "1. Testing /api/auth/providers"
echo "   URL: $BASE_URL/api/auth/providers"
curl -s -w "\n   Status: %{http_code}\n" "$BASE_URL/api/auth/providers" | head -5
echo ""

echo "2. Testing /api/auth/csrf"
echo "   URL: $BASE_URL/api/auth/csrf"
curl -s -w "\n   Status: %{http_code}\n" "$BASE_URL/api/auth/csrf"
echo ""

echo "3. Testing /auth/signin (HEAD request)"
echo "   URL: $BASE_URL/auth/signin"
curl -I -s "$BASE_URL/auth/signin" | grep -E "HTTP|Location|Content-Type"
echo ""

echo "✅ Done! Check the results above."
echo ""
echo "Expected results:"
echo "  - /api/auth/providers should return JSON (200)"
echo "  - /api/auth/csrf should return JSON with csrfToken (200)"
echo "  - /auth/signin should return HTML (200), not redirect (301/302)"
