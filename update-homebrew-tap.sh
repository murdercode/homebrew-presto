#!/bin/bash

# Script per aggiornare il tap Homebrew con una nuova versione di Presto
# Uso: ./update-homebrew-tap.sh <version>

set -e

if [ $# -eq 0 ]; then
    echo "Uso: $0 <version>"
    echo "Esempio: $0 0.1.15"
    exit 1
fi

VERSION=$1
CASK_FILE="Casks/presto.rb"

echo "🔄 Aggiornamento del tap Homebrew per Presto v$VERSION..."

# Verifica che il file cask esista
if [ ! -f "$CASK_FILE" ]; then
    echo "❌ File cask non trovato: $CASK_FILE"
    exit 1
fi

# Backup del file originale
cp "$CASK_FILE" "$CASK_FILE.backup"

# Aggiorna la versione nel file cask
sed -i '' "s/version \".*\"/version \"$VERSION\"/" "$CASK_FILE"

echo "✅ Versione aggiornata a $VERSION nel file cask"

# Verifica che ci siano cambiamenti
if git diff --quiet "$CASK_FILE"; then
    echo "⚠️  Nessun cambiamento rilevato nel file cask"
    rm "$CASK_FILE.backup"
    exit 0
fi

# Mostra le modifiche
echo "📝 Modifiche apportate:"
git diff "$CASK_FILE"

# Commit e push
git add "$CASK_FILE"
git commit -m "Update Presto to version $VERSION"
git push origin main

# Cleanup
rm "$CASK_FILE.backup"

echo "🎉 Tap Homebrew aggiornato con successo!"
echo ""
echo "Gli utenti possono ora aggiornare con:"
echo "  brew upgrade --cask presto"