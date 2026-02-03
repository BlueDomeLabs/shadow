# Shadow CI/CD Pipeline

**Version:** 1.0
**Last Updated:** January 30, 2026
**Platform:** GitHub Actions
**Purpose:** Automated build, test, and deployment pipeline

---

## Overview

Shadow uses GitHub Actions for continuous integration and deployment. All code changes must pass automated checks before merging, and releases are automated through the pipeline.

---

## 1. Pipeline Architecture

### 1.1 Pipeline Stages

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CI/CD Pipeline                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Pull Request                                                       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  │
│  │  Lint   │→ │  Test   │→ │  Build  │→ │ Analyze │→ │ Preview │  │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘  │
│                                                                     │
│  Main Branch (merge)                                                │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────────────────┐    │
│  │  Test   │→ │  Build  │→ │ Sign    │→ │ Deploy to TestFlight │   │
│  └─────────┘  └─────────┘  └─────────┘  │ & Internal Track      │   │
│                                         └─────────────────────┘    │
│                                                                     │
│  Release Tag (v*)                                                   │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────────────────┐    │
│  │  Test   │→ │  Build  │→ │  Sign   │→ │ Deploy to App Store  │   │
│  └─────────┘  └─────────┘  └─────────┘  │ & Play Store          │   │
│                                         └─────────────────────┘    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.2 Trigger Rules

| Trigger | Workflow | Actions |
|---------|----------|---------|
| Pull Request (opened/sync) | `pr-checks.yml` | Lint, Test, Build, Analyze |
| Push to `main` | `deploy-beta.yml` | Test, Build, Deploy to TestFlight/Internal |
| Tag `v*` | `deploy-production.yml` | Test, Build, Deploy to stores |
| Manual | `deploy-manual.yml` | Selective deployment |
| Schedule (daily) | `nightly.yml` | Full test suite, dependency audit |

---

## 2. Pull Request Workflow

### 2.1 PR Checks Configuration

```yaml
# .github/workflows/pr-checks.yml

name: PR Checks

on:
  pull_request:
    branches: [main, develop]
    types: [opened, synchronize, reopened]

concurrency:
  group: pr-${{ github.event.pull_request.number }}
  cancel-in-progress: true

jobs:
  lint:
    name: Lint & Format
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Check formatting
        run: dart format --set-exit-if-changed .

      - name: Analyze code
        run: flutter analyze --fatal-infos

      - name: Check for unused code
        run: dart run dart_code_metrics:metrics analyze lib

  test:
    name: Test
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests with coverage
        run: flutter test --coverage --reporter=github

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | awk '{print $2}' | tr -d '%')
          if (( $(echo "$COVERAGE < 100" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 100% threshold"
            exit 1
          fi

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info

  build-android:
    name: Build Android
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Build APK
        run: flutter build apk --debug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: debug-apk
          path: build/app/outputs/flutter-apk/app-debug.apk

  build-ios:
    name: Build iOS
    runs-on: macos-14
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Build iOS (no signing)
        run: flutter build ios --debug --no-codesign

  accessibility:
    name: Accessibility Audit
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Run accessibility tests
        run: flutter test test/accessibility/

  localization:
    name: Localization Check
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Check for missing translations
        run: |
          flutter gen-l10n
          git diff --exit-code lib/l10n/
```

### 2.2 Required Checks

All PRs require:

| Check | Requirement | Blocking |
|-------|-------------|----------|
| `lint` | Zero warnings | Yes |
| `test` | 100% pass | Yes |
| `coverage` | 100% lines | Yes |
| `build-android` | Successful | Yes |
| `build-ios` | Successful | Yes |
| `accessibility` | Zero failures | Yes |
| `localization` | No missing keys | Yes |
| Review | 1 approval | Yes |

---

## 3. Beta Deployment Workflow

### 3.1 Deploy to TestFlight & Internal Track

```yaml
# .github/workflows/deploy-beta.yml

name: Deploy Beta

on:
  push:
    branches: [main]

jobs:
  test:
    name: Test Suite
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true
      - run: flutter test

  build-and-deploy-ios:
    name: iOS TestFlight
    runs-on: macos-14
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Install Apple Certificate
        env:
          P12_CERTIFICATE: ${{ secrets.APPLE_P12_CERTIFICATE }}
          P12_PASSWORD: ${{ secrets.APPLE_P12_PASSWORD }}
          KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD }}
        run: |
          # Create keychain
          security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          security default-keychain -s build.keychain
          security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain

          # Import certificate
          echo "$P12_CERTIFICATE" | base64 --decode > certificate.p12
          security import certificate.p12 -k build.keychain -P "$P12_PASSWORD" -T /usr/bin/codesign
          security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" build.keychain

      - name: Install Provisioning Profile
        env:
          PROVISIONING_PROFILE: ${{ secrets.APPLE_PROVISIONING_PROFILE }}
        run: |
          mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
          echo "$PROVISIONING_PROFILE" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/shadow_beta.mobileprovision

      - name: Build iOS
        run: |
          flutter build ipa \
            --release \
            --export-options-plist=ios/ExportOptions.plist \
            --build-number=${{ github.run_number }}

      - name: Upload to TestFlight
        env:
          APP_STORE_CONNECT_API_KEY: ${{ secrets.APP_STORE_CONNECT_API_KEY }}
        run: |
          xcrun altool --upload-app \
            --type ios \
            --file build/ios/ipa/Shadow.ipa \
            --apiKey $APP_STORE_CONNECT_API_KEY \
            --apiIssuer ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}

  build-and-deploy-android:
    name: Android Internal Track
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Decode keystore
        env:
          KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
        run: |
          echo "$KEYSTORE_BASE64" | base64 --decode > android/app/keystore.jks

      - name: Build App Bundle
        env:
          KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
          KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
        run: |
          flutter build appbundle \
            --release \
            --build-number=${{ github.run_number }}

      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.bluedomecolorado.shadow
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
          status: completed
```

---

## 4. Production Deployment Workflow

### 4.1 Release Process

```yaml
# .github/workflows/deploy-production.yml

name: Deploy Production

on:
  push:
    tags:
      - 'v*'

jobs:
  validate-tag:
    name: Validate Release Tag
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate semver
        run: |
          TAG=${GITHUB_REF#refs/tags/}
          if [[ ! $TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "Invalid tag format: $TAG"
            exit 1
          fi

      - name: Check changelog
        run: |
          TAG=${GITHUB_REF#refs/tags/}
          if ! grep -q "## $TAG" CHANGELOG.md; then
            echo "No changelog entry for $TAG"
            exit 1
          fi

  test:
    name: Full Test Suite
    runs-on: ubuntu-latest
    needs: validate-tag
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true
      - run: flutter test --coverage
      - name: Integration tests
        run: flutter test integration_test/

  build-ios-production:
    name: iOS App Store
    runs-on: macos-14
    needs: test
    steps:
      # ... (similar to beta, with production provisioning)

      - name: Upload to App Store Connect
        run: |
          xcrun altool --upload-app \
            --type ios \
            --file build/ios/ipa/Shadow.ipa \
            --apiKey $APP_STORE_CONNECT_API_KEY \
            --apiIssuer $APP_STORE_CONNECT_ISSUER_ID

  build-android-production:
    name: Android Play Store
    runs-on: ubuntu-latest
    needs: test
    steps:
      # ... (similar to beta)

      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.bluedomecolorado.shadow
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production
          status: draft  # Requires manual release

  create-github-release:
    name: GitHub Release
    runs-on: ubuntu-latest
    needs: [build-ios-production, build-android-production]
    steps:
      - uses: actions/checkout@v4

      - name: Extract changelog
        id: changelog
        run: |
          TAG=${GITHUB_REF#refs/tags/}
          CHANGELOG=$(sed -n "/## $TAG/,/## v/p" CHANGELOG.md | head -n -1)
          echo "changelog<<EOF" >> $GITHUB_OUTPUT
          echo "$CHANGELOG" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          body: ${{ steps.changelog.outputs.changelog }}
          draft: false
          prerelease: false
```

---

## 5. Version Management

### 5.1 Versioning Scheme

```
MAJOR.MINOR.PATCH+BUILD

Example: 1.2.3+456

MAJOR: Breaking changes, major features
MINOR: New features, non-breaking
PATCH: Bug fixes
BUILD: CI build number (auto-incremented)
```

### 5.2 Version Bump Script

```bash
#!/bin/bash
# scripts/bump-version.sh

BUMP_TYPE=$1  # major, minor, patch

# Read current version
CURRENT=$(grep 'version:' pubspec.yaml | sed 's/version: //' | cut -d'+' -f1)
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case $BUMP_TYPE in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Update pubspec.yaml
sed -i "s/version: .*/version: $NEW_VERSION+\$BUILD_NUMBER/" pubspec.yaml

echo "Version bumped to $NEW_VERSION"
```

---

## 6. Environment Configuration

### 6.1 Secrets Required

| Secret | Purpose | Rotation |
|--------|---------|----------|
| `APPLE_P12_CERTIFICATE` | iOS code signing | Annual |
| `APPLE_P12_PASSWORD` | Certificate password | With cert |
| `APPLE_PROVISIONING_PROFILE` | iOS provisioning | Annual |
| `APP_STORE_CONNECT_API_KEY` | App Store upload | 2 years |
| `APP_STORE_CONNECT_ISSUER_ID` | API authentication | N/A |
| `ANDROID_KEYSTORE_BASE64` | Android signing | Never |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password | Never |
| `ANDROID_KEY_ALIAS` | Key alias | Never |
| `ANDROID_KEY_PASSWORD` | Key password | Never |
| `GOOGLE_PLAY_SERVICE_ACCOUNT` | Play Store upload | 2 years |
| `GOOGLE_OAUTH_CLIENT_ID` | OAuth config | N/A |
| `CODECOV_TOKEN` | Coverage upload | N/A |

### 6.2 Build Arguments

```yaml
# Passed via --dart-define
GOOGLE_OAUTH_CLIENT_ID: OAuth client ID
GOOGLE_OAUTH_PROXY_URL: Token exchange proxy URL
ENVIRONMENT: development | staging | production
```

---

## 7. Monitoring & Alerts

### 7.1 Pipeline Notifications

| Event | Channel | Recipients |
|-------|---------|------------|
| PR check failed | GitHub | PR author |
| Main build failed | Slack #ci-alerts | Team |
| Production deploy | Slack #releases | Team |
| Deploy failed | Slack #ci-alerts + PagerDuty | On-call |

### 7.2 Slack Integration

```yaml
- name: Notify Slack
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    channel-id: 'C0123456789'
    slack-message: |
      :x: Build failed for ${{ github.repository }}
      Branch: ${{ github.ref }}
      Commit: ${{ github.sha }}
      Author: ${{ github.actor }}
      <${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}|View Run>
  env:
    SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
```

---

## 8. Rollback Procedures

### 8.1 Quick Rollback

```bash
# Revert to previous version on TestFlight/Internal Track
# (Previous builds remain available)

# For App Store:
# 1. Remove current version from sale
# 2. Previous version automatically becomes available

# For Play Store:
# 1. Halt staged rollout
# 2. Rollback to previous release
```

### 8.2 Hotfix Process

```
1. Create branch from release tag
   git checkout -b hotfix/v1.2.4 v1.2.3

2. Apply fix

3. Bump patch version
   ./scripts/bump-version.sh patch

4. Create PR to main

5. After merge, tag release
   git tag v1.2.4
   git push origin v1.2.4

6. Pipeline deploys automatically
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
