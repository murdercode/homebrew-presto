#!/bin/bash

# Script per automatizzare il rilascio e aggiornamento del Homebrew tap
# Uso: ./release-homebrew.sh <version>

set -e

VERSION=$1
if [ -z "$VERSION" ]; then
    echo "❌ Errore: Specifica una versione (es: ./release-homebrew.sh 0.1.15)"
    exit 1
fi

echo "🚀 Preparazione rilascio Homebrew per versione $VERSION"

# 1. Aggiorna la versione nel package.json
echo "📝 Aggiornamento package.json..."
sed -i '' "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" package.json

# 2. Aggiorna la versione in tauri.conf.json
echo "📝 Aggiornamento tauri.conf.json..."
sed -i '' "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" src-tauri/tauri.conf.json

# 3. Build dell'applicazione
echo "🔨 Build dell'applicazione..."
npm run build

# 4. Trova il file DMG generato
DMG_PATH=$(find src-tauri/target -name "*.dmg" -type f | head -1)
if [ -z "$DMG_PATH" ]; then
    echo "❌ Errore: File DMG non trovato"
    exit 1
fi

echo "📁 DMG trovato: $DMG_PATH"

# 5. Calcola SHA256
echo "🔐 Calcolo SHA256..."
SHA256=$(shasum -a 256 "$DMG_PATH" | cut -d' ' -f1)
echo "SHA256: $SHA256"

# 6. Aggiorna il Cask formula
echo "📝 Aggiornamento Formula/presto.rb..."
sed -i '' "s/version \".*\"/version \"$VERSION\"/" Formula/presto.rb
sed -i '' "s/sha256 .*/sha256 \"$SHA256\"/" Formula/presto.rb

echo "✅ Rilascio preparato!"
echo ""
echo "📋 Prossimi passi:"
echo "1. Commit e push delle modifiche"
echo "2. Crea un release su GitHub con tag v$VERSION"
echo "3. Carica il file DMG: $DMG_PATH"
echo "4. Pubblica il tap su GitHub"
echo ""
echo "📖 Per installare:"
echo "   brew tap YOUR_USERNAME/presto"
echo "   brew install --cask presto"
