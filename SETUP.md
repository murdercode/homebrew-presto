# Setup e Istruzioni per il Tap Homebrew di Presto

## Struttura del Progetto

Ora hai due repository separati:
- **presto**: Il progetto principale dell'applicazione
- **homebrew-presto**: Il tap Homebrew per la distribuzione

## Come Funziona

### 1. Repository principale (presto)
Quando esegui `./release.sh`, lo script:
1. Aggiorna la versione nei file di configurazione
2. Fa commit e tag della nuova versione
3. Fa il push su GitHub
4. Builda l'applicazione
5. **Automaticamente aggiorna il tap Homebrew** chiamando `update_homebrew_tap()`

### 2. Repository del tap (homebrew-presto)
Contiene:
- `Casks/presto.rb`: La formula Homebrew per l'installazione
- `update-homebrew-tap.sh`: Script per aggiornare la versione nel tap
- `trigger-update.sh`: Script per triggering remoto via webhook
- `.github/workflows/update-formula.yml`: Automazione GitHub Actions

## Installazione per gli Utenti

Gli utenti possono installare Presto in questi modi:

### Metodo 1: Aggiungere il tap e installare
```bash
brew tap murdercode/presto
brew install --cask presto
```

### Metodo 2: Installazione diretta
```bash
brew install --cask murdercode/presto/presto
```

### Aggiornamento
```bash
brew upgrade --cask presto
```

### Disinstallazione
```bash
brew uninstall --cask presto
```

## Processo di Release

### Release Automatico (Raccomandato)
Dal repository `presto`:
```bash
./release.sh --patch    # o --minor, --major
```

Lo script farà tutto automaticamente, incluso l'aggiornamento del tap.

### Release Manuale
Se devi aggiornare solo il tap Homebrew:
```bash
cd ../homebrew-presto
./update-homebrew-tap.sh 0.1.15
```

## Note Importanti

1. **Struttura delle cartelle**: I due repository devono essere nella stessa cartella padre per il funzionamento automatico

2. **SHA256**: Attualmente usando `:no_check` per saltare la verifica SHA256. Per la produzione, dovresti:
   - Calcolare l'SHA256 dei file .dmg
   - Aggiornare il cask con i valori corretti

3. **GitHub Releases**: Assicurati di:
   - Creare le release su GitHub con i file .dmg
   - Seguire il naming pattern: `presto_VERSION_aarch64.dmg` e `presto_VERSION_x86_64.dmg`

4. **Testing**: Prima di pubblicare, testa sempre:
   ```bash
   brew install --cask murdercode/presto/presto --verbose
   ```

## Risoluzione Problemi

### Il tap non viene aggiornato automaticamente
- Verifica che la cartella `../homebrew-presto` esista
- Controlla che lo script `update-homebrew-tap.sh` sia eseguibile
- Verifica i permessi Git nella cartella del tap

### Errori di installazione Homebrew
- Verifica che i file .dmg siano pubblicati su GitHub Releases
- Controlla che i nomi dei file corrispondano al pattern nel cask
- Testa con `brew audit --cask presto`

### Aggiornamento SHA256
Per aggiornare con SHA256 corretti:
```bash
# Calcola SHA256
shasum -a 256 presto_0.1.15_aarch64.dmg
shasum -a 256 presto_0.1.15_x86_64.dmg

# Aggiorna il cask sostituendo :no_check con i valori
```
