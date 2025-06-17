#!/bin/bash

# Script per triggerare l'aggiornamento del tap Homebrew da un'altra repository
# Questo script può essere chiamato dal repository principale dopo un nuovo release

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Uso: $0 <version>"
    echo "Esempio: $0 0.1.15"
    exit 1
fi

echo "🔄 Triggering Homebrew tap update for version $VERSION..."

# Trigger repository dispatch event (richiede GITHUB_TOKEN)
if [ ! -z "$GITHUB_TOKEN" ]; then
    curl -X POST \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/murdercode/homebrew-presto/dispatches \
      -d '{"event_type":"new-release","client_payload":{"version":"'$VERSION'"}}'
    
    echo "✅ Webhook sent to update Homebrew tap"
else
    echo "⚠️  GITHUB_TOKEN not found, using local update instead"
    # Fallback to local update
    ./update-homebrew-tap.sh "$VERSION"
fi
