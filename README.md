<p align="center">
  <img src="media/banner.png" alt="Hephaistos-Kit Search — Sherlock suit les pistes" width="100%" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-blue.svg" alt="Platform" />
  <img src="https://img.shields.io/badge/Backend-Hephaistos%20Rust%20(MFT%20%2B%20USN)-orange.svg" alt="Backend" />
  <img src="https://img.shields.io/badge/Search-%3C50ms-brightgreen.svg" alt="Speed" />
  <img src="https://img.shields.io/badge/Index-Zero%20redondance-success.svg" alt="Index" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License" />
</p>

---

## 🔍 Présentation

> *« Élémentaire, mon cher Watson : le fichier que vous cherchez est déjà indexé. »*

**Hephaistos-Kit Search** transforme votre IDE en poste de détection : un panneau de recherche de fichiers **instantané**, branché directement sur le moteur **Hephaistos** (Rust) — index NTFS maison alimenté par la lecture directe du **$MFT** et le suivi du **journal USN**, sans `Everything.exe` ni service externe.

Pas d'index Windows, pas de scan récursif : l'extension interroge le démon Hephaistos via son pipe nommé (`\\.\pipe\hphe-index`), et retrouve ses racines dans la base Everything de la v1. **Une seule base, vivante — zéro redondance.**

- ⚡ **Vitesse $MFT** : résultats en <50 ms sur des millions de fichiers, tous disques NTFS confondus — plus rapide que l'index Windows natif.
- 🧭 **Explorateur intégré** : vue « PC » (tous les lecteurs + cloud détectés), navigation par breadcrumbs, historique ◀ ▶.
- 🕵️ **Recherche plein-texte** : Tantivy sur le contenu + requêtes instantanées sur le nom/chemin via l'index USN.
- 📁 **Outils filesystem complets** : lecture, écriture, déplacement, suppression, création — les capacités du MCP filesystem officiel, servies à la vitesse d'Hephaistos.
- 🤖 **Soumission à l'agent** : fichiers et dossiers injectés dans le chat Devin via `fileMention` natif, avec chemin absolu.
- 🌍 **Multilingue** : FR / EN / ES / DE.

---

## ✨ Fonctionnalités

### 1. Recherche instantanée
- Résultats live pendant la frappe, triables par nom / chemin / taille / date / extension.
- Filtres rapides (dossier, fichier, audio, vidéo, document, exécutable, image, archive…).
- En-tête fixe, colonnes **redimensionnables et réordonnables** par glisser-déposer.
- Multi-sélection (Ctrl/Shift), ouverture, révélation dans l'explorateur, copie de chemin.

### 2. Navigateur de fichiers
- Écran d'accueil **PC** : tous les lecteurs locaux + racines cloud détectées (OneDrive, Google Drive, Dropbox, iCloud).
- Descente dans les dossiers, retour par breadcrumbs, historique avant/arrière type navigateur.
- Champ vide = retour automatique à la vue PC — « tant qu'on n'a pas cherché, on est là ».

### 3. Aperçu universel
- Preview texte pour **tout fichier** (détection binaire automatique) — `.env`, logs, scripts, configs sans extension.
- Aperçu images (PNG, JPG, GIF, BMP, WebP, ICO, SVG).
- Panneau redimensionnable, dépliable/repliable.

### 4. Favoris & productivité
- Dossiers favoris en tuiles dans la barre de navigation, fichiers favoris en liste déroulante.
- Glisser-déposer direct depuis les résultats pour épingler.
- Création de fichiers/dossiers in-place, suppression, renommage.

### 5. Intégration agent
- Sélection → **Submit to agent** : puces `fileMention` natives dans le chat Devin (même mécanisme que le drag-to-Cascade du workbench), chaque mention précédée du chemin absolu exact — aucune ambiguïté entre homonymes sur des lecteurs différents.
- Le MCP sous-jacent expose aussi `everything_search`, `everything_count`, `fs_*` pour les autres agents via stdio.

---

## 🏗️ Architecture

```text
┌──────────────────────────┐
│ Hephaistos-Kit Search    │   panneau webview — UI uniquement
│  extension/media/panel.* │
└───────────┬──────────────┘
            │ postMessage
┌───────────▼──────────────┐
│  searchView.js + fs natif│   ops fichiers hôtes (preview, favs, injection)
└───────────┬──────────────┘
            │ stdio JSON-RPC
┌───────────▼──────────────┐
│  hphe-mcp.exe (Rust)     │   serveur MCP stdio unifié — aucun port réseau
│  (profil default = user) │
└───────────┬──────────────┘
            │ named pipe \\.\pipe\hphe-index
┌───────────▼──────────────┐
│  hphe-indexd (démon)     │   index $MFT NTFS + journal USN temps réel
│  data\ntfs-index         │   — UNE seule DB, aucune dépendance externe
└──────────────────────────┘
```

**Plus rien à installer** : `hphe-indexd` lit la **$MFT** directement et suit les changements via le **journal USN** — l'index vit sans `Everything.exe` ni service Windows. Le démon est livré avec le kit (`servers\hephaistos2-kit\extension\server\`).

---

## 🔐 Sécurité

- **stdio uniquement** : le serveur MCP n'ouvre aucun socket, aucun port — pas de surface réseau.
- **`.mcp-access`** : politique d'accès par agent externe (whitelist gitignore-style) ; l'extension locale tourne en profil `default` — vos fichiers, vos droits.
- Le REST local optionnel (`hphe-rest`, `127.0.0.1:8792`) est **loopback only** — aucune exposition réseau.

---

## 🙏 Crédits

La v1 s'appuyait sur **Everything** © [voidtools](https://www.voidtools.com/) — David Carpenter — via son protocole IPC officiel. La v2 est autonome (Rust, $MFT/USN) : merci à voidtools pour l'inspiration et les années de service.

---

<p align="center">
  <img src="media/hephaistos-kit_banderole.jpg" alt="Hephaistos2-Kit — The Developer's Forge" width="70%" />
</p>

**Hephaistos-Kit Search** est un module du **[Hephaistos2-Kit](https://github.com/art-qalam-fr/hephaistos2-kit)** — le forgeron des environnements de développement agentiques — développé par l'organisation **art-qalam-fr**.

### ☕ Offrir un café

Le projet est gratuit et open source (MIT). S'il vous fait gagner du temps :

<p align="center">
  <img src="media/paypal-qr.png" alt="QR Code PayPal — offrir un café" width="180"/>
  <br/><sub>Scannez pour offrir un café via PayPal</sub>
</p>
