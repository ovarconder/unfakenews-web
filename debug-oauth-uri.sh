#!/bin/bash

# Test Google OAuth flow
echo "🔍 Testing Google OAuth redirect_uri..."
echo ""

# Get the Google OAuth URL
echo "1. Getting Google OAuth URL from NextAuth..."
RESPONSE=$(curl -s -L "https://www.unfakenews.asia/api/auth/signin/google")

# Extract redirect_uri if present in the response
echo "$RESPONSE" | grep -o "redirect_uri=[^&]*" | head -1 | sed 's/redirect_uri=//' | python3 -c "import sys; from urllib.parse import unquote; print('   redirect_uri:', unquote(sys.stdin.read().strip()))"

echo ""
echo "2. Expected redirect URIs in Google Console:"
echo "   ✓ https://unfakenews.asia/api/auth/callback/google"
echo "   ✓ https://www.unfakenews.asia/api/auth/callback/google"
echo ""

# Check NEXTAUTH_URL
echo "3. Current NEXTAUTH_URL should be:"
echo "   https://www.unfakenews.asia"
echo ""
echo "💡 If redirect_uri doesn't match, update NEXTAUTH_URL in Vercel"
