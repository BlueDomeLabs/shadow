# Google Drive Sync Setup Guide

To enable Google Drive sync in Shadow App, you need to configure Google Sign-In with your own OAuth 2.0 credentials.

## Prerequisites

- A Google account
- Access to Google Cloud Console

## Step-by-Step Instructions

### 1. Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Click "Select a project" → "New Project"
3. Enter a project name (e.g., "Shadow App")
4. Click "Create"

### 2. Enable Google Drive API

1. In your project, go to "APIs & Services" → "Library"
2. Search for "Google Drive API"
3. Click on it and press "Enable"

### 3. Configure OAuth Consent Screen

1. Go to "APIs & Services" → "OAuth consent screen"
2. Select "External" user type
3. Click "Create"
4. Fill in the required fields:
   - App name: "Shadow App"
   - User support email: Your email
   - Developer contact email: Your email
5. Click "Save and Continue"
6. On the Scopes page, click "Save and Continue" (default scopes are fine)
7. On the Test users page, add your Google account email
8. Click "Save and Continue"

### 4. Create OAuth 2.0 Credentials

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth client ID"
3. Select "macOS" as application type
4. Enter a name (e.g., "Shadow App macOS")
5. Bundle ID: `com.example.shadowApp` (or your actual bundle ID)
6. Click "Create"
7. You'll see a dialog with your Client ID - **copy this!**

### 5. Update Info.plist

1. Open `macos/Runner/Info.plist`
2. Find the line with `YOUR_CLIENT_ID.apps.googleusercontent.com`
3. Replace `YOUR_CLIENT_ID` with your actual Client ID (e.g., `1234567890-abcdefgh.apps.googleusercontent.com`)
4. Find the line with `YOUR_REVERSED_CLIENT_ID`
5. Replace it with the reversed client ID:
   - If your Client ID is `1234567890-abcdefgh.apps.googleusercontent.com`
   - The reversed ID is: `com.googleusercontent.apps.1234567890-abcdefgh`

### Example Configuration

If your Client ID is: `123456789-abc123.apps.googleusercontent.com`

Your Info.plist should look like:

```xml
<key>GIDClientID</key>
<string>123456789-abc123.apps.googleusercontent.com</string>

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.123456789-abc123</string>
        </array>
    </dict>
</array>
```

### 6. Rebuild the App

After updating Info.plist, rebuild the app:

```bash
flutter clean
flutter build macos
flutter run -d macos
```

### 7. Test Google Drive Sync

1. Open Shadow App
2. Go to Settings → Cloud Sync
3. Select "Google Drive"
4. Sign in with your Google account
5. Grant permissions when prompted

## Troubleshooting

### "Failed to Connect" Error

- Make sure you've replaced `YOUR_CLIENT_ID` and `YOUR_REVERSED_CLIENT_ID` with your actual credentials
- Ensure the Google Drive API is enabled in your Google Cloud Project
- Check that your Google account email is added as a test user in the OAuth consent screen
- Rebuild the app after changing Info.plist

### "Access Denied" Error

- Add your Google account email to the test users list in OAuth consent screen
- Make sure you're signing in with the same Google account that's listed as a test user

### Still Having Issues?

- Double-check that the reversed client ID is correct
- Verify your bundle ID matches what you configured in Google Cloud Console
- Check the Flutter console for detailed error messages

## Alternative: Use iCloud

If you're on macOS and prefer not to set up Google Drive, you can use iCloud sync instead:

1. Go to Settings → Cloud Sync
2. Select "iCloud"
3. Sign in with your Apple ID

iCloud sync works automatically on macOS without additional configuration.
