# Foley Property Tracker — Deployment Guide
## PWA on GitHub Pages + Supabase real-time sync

This guide takes about 30–45 minutes total, most of which is waiting for things to load.

---

## STEP 1 — Set up Supabase (the database)

1. Go to **https://supabase.com** and click "Start your project"
2. Sign in with GitHub or create a free account
3. Click **"New project"**
   - Organization: your personal org
   - Project name: `foley-property`
   - Database password: pick something strong and **save it**
   - Region: **US East (N. Virginia)** — closest to Foley, MN
   - Click **Create new project** (takes ~2 minutes to spin up)

4. Once your project is ready, go to **SQL Editor** (left sidebar)
5. Click **"New query"**
6. Open `supabase_setup.sql` from this folder and **paste the entire contents** into the editor
7. Click **Run** — you should see "Success. No rows returned"

8. Go to **Settings → API** (left sidebar)
9. Copy two things:
   - **Project URL** — looks like `https://abcdefgh.supabase.co`
   - **anon public key** — a long string starting with `eyJ...`

---

## STEP 2 — Configure the app with your Supabase credentials

1. Open `index.html` in a text editor (TextEdit on Mac, Notepad on Windows)
2. Find these two lines near the top of the `<script>` section:
   ```
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Replace the placeholder values with your actual values:
   ```
   const SUPABASE_URL = 'https://abcdefgh.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
   ```
4. Save the file

---

## STEP 3 — Generate your app icons

Option A — Quick (recommended):
1. Go to **https://svgtopng.com/**
2. Upload `icon.svg` from this folder
3. Download as PNG
4. Resize to 192×192 and save as `icon-192.png`
5. Resize to 512×512 and save as `icon-512.png`
6. Place both files in the same folder as `index.html`

Option B — Use any image you want:
- Just use a 512×512 PNG of your choice (photo of the property, etc.)
- Save two copies: `icon-192.png` and `icon-512.png`
- Smaller one can be a resized version

---

## STEP 4 — Put it on GitHub Pages

### Create the repository
1. Go to **https://github.com** — sign in or create a free account
2. Click the **+** button → **New repository**
   - Repository name: `foley-property` (or anything you like)
   - Set to **Public** (required for free GitHub Pages)
   - Click **Create repository**

### Upload your files
3. On the new repo page, click **"uploading an existing file"**
4. Drag and drop ALL of these files from your folder:
   - `index.html`
   - `manifest.json`
   - `sw.js`
   - `icon-192.png`
   - `icon-512.png`
5. Scroll down, add a commit message like "Initial upload", click **Commit changes**

### Enable GitHub Pages
6. Go to **Settings** (tab at the top of your repo)
7. Scroll down to **Pages** (left sidebar)
8. Under "Source", select **Deploy from a branch**
9. Branch: **main**, Folder: **/ (root)**
10. Click **Save**
11. Wait 2–3 minutes, then your site will be live at:
    `https://YOUR-GITHUB-USERNAME.github.io/foley-property/`

---

## STEP 5 — Create your accounts

1. Open the site URL on your phone
2. You'll see the sign-in screen
3. Click **"Create Account"**
   - Ivan creates his account: name = `Ivan`, your email, password
   - Michaela creates her account: name = `Michaela`, her email, password
4. Check your email and click the confirmation link Supabase sends
5. Sign back in — you're in!

> **Note:** Both of you need to create accounts from the sign-in screen.
> After that you just sign in normally every time.

---

## STEP 6 — Install on your phones as a PWA

### iPhone (Safari only — must use Safari, not Chrome)
1. Open Safari and go to your GitHub Pages URL
2. Tap the **Share** button (the box with an arrow pointing up)
3. Scroll down and tap **"Add to Home Screen"**
4. Name it "Foley Property" and tap **Add**
5. It will appear on your home screen like a native app

### Android
1. Open Chrome and go to your URL
2. Tap the three-dot menu → **"Add to Home screen"** or **"Install app"**
3. Confirm — it installs like an app

### iPad / Mac
- Same process as iPhone for iPad (use Safari)
- On Mac: open in Chrome or Edge → three-dot menu → "Install Foley Property"

---

## STEP 7 — Migrate your existing data

If you have data in your local version of the tracker:

1. Open your **old local HTML file** in a browser
2. Go to **Settings → Data Backup & Restore**
3. Click **Export Backup** — saves a JSON file to your Downloads
4. Open the **new online version** (your GitHub Pages URL)
5. Sign in, then go to **Settings → Data Backup & Restore**
6. Click **Import Backup** and select the JSON file
7. The page will reload with all your existing data, now synced to Supabase

---

## How the sync works

- **Any change you make** (adding a task, checking something off, adding a calendar event) saves instantly to Supabase
- **The other person's device** receives the update in about 1–2 seconds via Supabase Realtime — no refresh needed
- **If you're offline**, changes save locally and sync automatically when you reconnect
- **Presence avatars** — you'll see a colored dot with the other person's initial when they're also using the app, showing which page they're on

---

## Keeping the app updated

When you want to update the app (after getting a new version of `index.html`):

1. Go to your GitHub repository
2. Click on `index.html`
3. Click the pencil (edit) icon
4. Delete all the content and paste the new file contents
5. Commit — GitHub Pages redeploys in about 60 seconds

Or drag and drop the new file onto the repository's file list and commit.

---

## Supabase free tier limits (you won't hit these)

- 500 MB database storage
- 2 GB bandwidth per month
- 50,000 monthly active users
- Unlimited API calls

For a household tracker used by 2 people, you'll use less than 5 MB of storage.

---

## Troubleshooting

**"Supabase not configured yet"** — You haven't replaced the placeholder values in Step 2

**Sign-in says "Email not confirmed"** — Check your email and click the confirmation link

**App isn't updating in real-time** — Make sure both devices are online; check that realtime is enabled in Supabase (Dashboard → Database → Replication)

**Can't install to home screen on iPhone** — Must use Safari, not Chrome or Firefox

**Service worker issues** — In Safari, go to Settings → Safari → Advanced → Website Data → find your site → delete data, then reload

---

## Files in this folder

```
foley-property/
├── index.html          ← The main app (upload this to GitHub)
├── manifest.json       ← Makes it installable as PWA
├── sw.js               ← Service worker (offline support)
├── icon-192.png        ← App icon (you generate this)
├── icon-512.png        ← App icon large (you generate this)
├── icon.svg            ← Source icon (convert to PNG)
├── supabase_setup.sql  ← Run this in Supabase SQL editor
├── generate_icons.py   ← Optional: auto-generates icons
└── DEPLOY.md           ← This file
```
