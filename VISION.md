# Shadow - Product Vision

**Last Updated: 2026-02-14**
**This document is written for Reid, not for Claude instances. Keep it in plain language.**

---

## What Is Shadow?

Shadow is a personal health tracking app. It helps people keep track of their health conditions, supplements, food, sleep, fluids, activities, and more - all in one private, secure place. Think of it as a health journal that's always with you.

Everything stays on the user's device by default (encrypted so nobody can read it). Users can optionally sync to Google Drive or iCloud so their data is backed up and available on other devices.

---

## Who Is It For?

1. **People managing chronic conditions** - Someone with eczema who wants to figure out what foods trigger flare-ups, or someone tracking which supplements help their symptoms.
2. **Health counselors** - A nutritional counselor who manages supplement plans for multiple clients. They can switch between client profiles.
3. **Families** - A parent tracking health data for family members.

---

## What Can Users Do?

### Home Screen
When users open the app, they see a home screen with:
- Their current profile name and avatar at the top
- A cloud sync button to manage backup settings
- Quick action buttons for common tasks (report a flare-up, log supplements, log food, log fluids, start a photo round, log sleep, write a journal entry)
- A bottom navigation bar with 9 tabs to get to any section

### Track Health Conditions
- Create conditions (like "Eczema" or "Migraines")
- Log how bad it is each day (1-10 severity scale)
- Take photos to document changes over time
- Record what triggered it
- Mark conditions as resolved when they get better

### Manage Supplements
- Add supplements with details (name, form like capsule/tablet/powder, dosage, ingredients)
- Set up schedules (daily, specific days, with meals, etc.)
- Log whether you took them, missed them, or snoozed the reminder
- See your compliance percentage over time

### Log Food
- Build a personal food library
- Log meals with timestamps
- Choose from 20+ diet types (keto, paleo, intermittent fasting, etc.)
- Track diet compliance with real-time percentages
- Get warnings before logging foods that break your diet rules

### Track Sleep
- Log when you go to bed and when you wake up
- Rate sleep quality
- Record how you feel when waking up
- Track dream types
- See sleep patterns over time

### Track Fluids
- Log water intake with quick-add buttons (8oz, 12oz, 16oz, etc.)
- Track daily progress toward a hydration goal
- Log bowel movements with type and condition
- Track urination patterns
- Track menstrual flow for women
- Record basal body temperature for cycle tracking
- Track any other bodily fluid with custom entries

### Photo Documentation
- Define body areas to photograph regularly
- Take photos and maintain a timeline
- Compare photos side-by-side to see changes over time

### Journal
- Write free-form health notes
- Add titles and tags for organization
- Search through past entries

### Generate Reports
- Create PDF reports for doctor visits
- Select date ranges and categories
- Include photos and charts

### Notifications
- Set reminders for supplements, meals, water, sleep, and more
- 25 different reminder types
- Customize times and days for each reminder

### Profile Management
- Create and manage profiles
- Switch between profiles
- Welcome screen for first-time users

### Cloud Sync (Coming Soon)
- Back up data to Google Drive or iCloud
- Sync across multiple devices
- Everything encrypted before leaving the device
- Pair devices using QR codes

---

## What Does It Look Like Today?

### Working and Usable
- The app launches with a welcome screen for new users
- Profile creation and management works
- Home screen with all 9 tabs and quick action buttons
- All data entry screens exist (supplements, conditions, food, sleep, fluids, activities, journal, photos)
- Data saves to the encrypted local database
- 1986 automated tests verify everything works correctly

### Still Being Built
- Cloud sync (the screens exist but the actual sync doesn't work yet)
- Some screens are basic and need polish (supplement editing, condition lists, food lists, sleep lists)
- Report generation
- Notifications system
- Diet compliance tracking
- Intelligence features (pattern detection, trigger analysis)
- Wearable device integration (Apple Watch, Fitbit, etc.)

---

## The Big Picture Phases

### Phase 1: Core Features - DONE
All the basic tracking features work locally.

### Phase 2: Enhanced Features - IN PROGRESS
Multi-profile support, cloud sync, notifications, diet tracking, report generation.

### Phase 3: Intelligence - PLANNED
The app learns from your data: detects patterns, identifies triggers, predicts flare-ups, and gives personalized insights.

### Phase 4: Health Data Integration - PLANNED
Connect to Apple Health, Google Fit, Fitbit, Oura Ring, etc. Export data in medical formats for doctors.

### Phase 5: Platform Expansion - FUTURE
Windows, Linux, and web versions of the app.

---

## How to Check What's Working

To see the app yourself:

1. Open Terminal
2. Navigate to the Shadow folder: `cd ~/Development/Shadow`
3. Run: `flutter run -d macos`
4. The app will launch on your Mac

**Things to look for:**
- Does the welcome screen appear on first launch?
- Can you create a profile and see the home screen?
- Do the navigation tabs work?
- Can you tap into each section and see its screen?
- Does data save when you enter it?

If anything looks broken or wrong, tell your Claude instance what you saw and they can investigate.
