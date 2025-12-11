# Testing Guide: Notification Performance & Connectivity

## Objective
Collect data to ensure notification reminders work properly under both online and offline network conditions.

## Prerequisites
- Android device or emulator with app installed
- Access to Firebase Console (for sending test notifications)
- Server access (to send notifications via API)
- ADB tools installed (optional, for viewing logs)

## Data Collection Template

### Test Summary Table
| Test # | Date | Scenario | Connection | Result | Notes |
|--------|------|----------|------------|--------|-------|
| 1 | | Online FCM | Online | ✅/❌ | |
| 2 | | Offline Local | Offline | ✅/❌ | |
| 3 | | Sync Test | Offline→Online | ✅/❌ | |
| 4 | | Network Interrupt | Online→Offline | ✅/❌ | |
| 5 | | Background | Terminated | ✅/❌ | |

---

## Test 1: Online Notification Reception (FCM)

**Purpose:** Verify notifications arrive when device is online

**Steps:**
1. Ensure device has active internet connection
2. Open app and note current time
3. Send test notification from Firebase Console:
   - Go to Firebase Console → Cloud Messaging
   - Click "Send test message"
   - Enter FCM token (check logs for token)
   - Send notification
4. Observe notification arrival
5. Check notification page in app
6. Verify database entry

**Verify Using ADB:**
```bash
adb logcat | grep -i "notification\|fcm"
```

**Expected Results:**
- ✅ Notification received within 5 seconds
- ✅ Notification appears in system tray
- ✅ Notification saved to SQLite database
- ✅ Notification visible in app's notification page
- ✅ Unread count updated

**Data to Record:**
```
Test #1 - Online FCM Notification
================================
Date/Time: _____________
Device Model: _____________
Connection Type: WiFi/4G/5G
Connection Speed: _____________

Server Send Time: _____________
Device Receive Time: _____________
Delay (seconds): _____________

Results:
□ Notification received
□ Displayed in notification tray
□ Saved to database (check DB)
□ Visible in app UI
□ Correct notification type parsed
□ Correct data payload received

Database Check:
- Notification ID: _____________
- Title: _____________
- Type: _____________
- is_read: false
- created_at: _____________

Issues/Errors: _____________
```

---

## Test 2: Offline Notification Scheduling

**Purpose:** Verify local notifications work without internet

**Steps:**
1. **Disable internet:**
   - Enable Airplane mode
   - Verify no connectivity (check connectivity indicator in app)
2. Open app → Go to Reminders
3. Create new medicine reminder:
   - Name: "Test Medicine Offline"
   - Time: 2 minutes from now
   - Frequency: Once
4. Save reminder
5. Wait for scheduled time
6. Observe if notification triggers

**Verify Local DB:**
```bash
# Connect to device and check SQLite
adb shell
cd /data/data/com.example.medicine_reminder/databases/
sqlite3 reminders.db
SELECT * FROM reminders WHERE name LIKE '%Test%';
.quit
```

**Expected Results:**
- ✅ Reminder saved to local database
- ✅ Local notification scheduled
- ✅ Notification triggers at exact scheduled time (offline)
- ✅ App shows reminder in list

**Data to Record:**
```
Test #2 - Offline Local Notification
====================================
Date/Time: _____________
Connection Status: Offline (Airplane Mode)

Reminder Details:
- Medicine Name: _____________
- Scheduled Time: _____________
- Actual Created Time: _____________

Results:
□ Reminder saved to local database
□ No network error shown
□ Reminder appears in app list
□ Notification scheduled (check Android settings)

Notification Trigger Test:
- Scheduled Time: _____________
- Actual Trigger Time: _____________
- Delay (seconds): _____________
□ Notification appeared
□ Correct title and message
□ Tap notification opens app

Issues/Errors: _____________
```

---

## Test 3: Offline-to-Online Sync

**Purpose:** Verify data syncs when connection restored

**Steps:**
1. **Start Offline:**
   - Enable Airplane mode
   - Verify offline status in app
2. **Create Multiple Items:**
   - Create 3 medication reminders
   - Create 1 appointment
   - Note down details
3. **Verify Local Storage:**
   - Check items appear in app
   - Note database IDs (local)
4. **Restore Connection:**
   - Disable Airplane mode
   - Watch for sync indicator
   - Wait 30 seconds
5. **Verify Sync:**
   - Check server database
   - Compare local vs server IDs

**Expected Results:**
- ✅ All items created offline
- ✅ Sync triggers automatically on reconnection
- ✅ All items uploaded to server
- ✅ Server IDs assigned to local items
- ✅ No duplicates created

**Data to Record:**
```
Test #3 - Offline-to-Online Sync
=================================
Date/Time: _____________

Items Created Offline:
1. Medicine: _____________ (Local ID: ___)
2. Medicine: _____________ (Local ID: ___)
3. Medicine: _____________ (Local ID: ___)
4. Appointment: _____________ (Local ID: ___)

Total Items Created Offline: 4

Connection Restored: _____________
Sync Triggered: □ Automatic □ Manual
Sync Start Time: _____________
Sync Complete Time: _____________
Sync Duration: _____________ seconds

Results:
Items Successfully Synced: ___/4
□ Medicine 1 synced (Server ID: ___)
□ Medicine 2 synced (Server ID: ___)
□ Medicine 3 synced (Server ID: ___)
□ Appointment synced (Server ID: ___)

Verification:
□ All items visible on server
□ No duplicates created
□ Local IDs updated with server IDs
□ Timestamps preserved

Issues/Errors: _____________
```

---

## Test 4: Network Interruption During Operation

**Purpose:** Verify app handles sudden network loss gracefully

**Steps:**
1. **Start Online:**
   - Ensure active internet connection
2. **Initiate Server Operation:**
   - Request to load notifications from server
3. **Interrupt Connection:**
   - Immediately disable WiFi/data
4. **Observe Behavior:**
   - Does app show error?
   - Does app fall back to local data?
   - Is user experience affected?
5. **Restore Connection:**
   - Enable internet again
   - Verify recovery

**Expected Results:**
- ✅ No app crash
- ✅ Graceful fallback to local data
- ✅ User-friendly error message (if any)
- ✅ Automatic retry when connection restored
- ✅ Data consistency maintained

**Data to Record:**
```
Test #4 - Network Interruption
===============================
Date/Time: _____________

Scenario:
Operation: Loading notifications
Connection Status: Online → Offline (interrupted)

Timeline:
- Operation Started: _____________
- Network Disabled: _____________
- Time Elapsed: _____________ ms

Results:
□ App continued working
□ No crash occurred
□ Error message shown (user-friendly)
□ Fallback to local data
□ Cached data displayed
□ Retry option available

Connection Restored: _____________
□ Automatic retry triggered
□ Operation completed successfully
□ Data synced properly

User Experience Rating: ___/5
Issues/Errors: _____________
```

---

## Test 5: Background Notification (App Terminated)

**Purpose:** Verify notifications work when app is completely closed

**Steps:**
1. **Close App Completely:**
   - Swipe app from recent apps
   - Verify app is not running (check Android settings)
2. **Send Notification:**
   - Use Firebase Console or server API
   - Send test notification
3. **Observe:**
   - Does notification appear in tray?
   - Open notification
   - Check if saved to database
4. **Open App Manually:**
   - Go to notification page
   - Verify notification is there

**Expected Results:**
- ✅ Notification received while app terminated
- ✅ Notification appears in system tray
- ✅ Saved to database via background handler
- ✅ Opening notification launches app
- ✅ Notification visible in app after opening

**Data to Record:**
```
Test #5 - Background Notification
==================================
Date/Time: _____________
App State: Terminated (not in recent apps)
Connection Status: Online

Notification Details:
- Sent From: Firebase/Server
- Send Time: _____________
- Notification Type: _____________

Results:
□ Notification received
□ Appeared in notification tray
□ Notification had correct title
□ Notification had correct message
□ Tap notification opened app

Receive Time: _____________
Delay: _____________ seconds

Open App and Verify:
□ Notification in database
□ Notification in app UI
□ Correct data payload
□ Correct unread status

Background Handler:
□ firebaseMessagingBackgroundHandler executed
□ Notification saved to SQLite
□ userId retrieved from SharedPreferences
□ No errors in logs

Issues/Errors: _____________
```

---

## Test 6: Multiple Notifications (Stress Test)

**Purpose:** Verify app handles multiple notifications properly

**Steps:**
1. Send 10 notifications rapidly (1 per second)
2. Observe:
   - All received?
   - All saved to database?
   - App performance affected?
   - Any duplicates?

**Data to Record:**
```
Test #6 - Multiple Notifications
=================================
Date/Time: _____________
Notifications Sent: 10
Time Window: 10 seconds

Results:
Notifications Received: ___/10
Notifications in Database: ___
Duplicates Found: ___
App Performance: Normal/Slow/Crashed

Missing Notifications (if any):
- #___ : _____________

Issues/Errors: _____________
```

---

## Viewing Debug Logs

### Android Studio Logcat
```bash
# Filter for notification-related logs
flutter: notification
flutter: FCM
flutter: sync
```

### ADB Command Line
```bash
# View real-time logs
adb logcat -s flutter

# Search for specific events
adb logcat | grep -i "notification"
adb logcat | grep -i "connection"
adb logcat | grep -i "sync"

# Save logs to file
adb logcat > test_logs.txt
```

### Check SQLite Database
```bash
# Connect to device
adb shell

# Navigate to app database
cd /data/data/com.example.medicine_reminder/databases/

# Open notifications database
sqlite3 notifications.db

# View all notifications
SELECT * FROM notifications;

# Count notifications
SELECT COUNT(*) FROM notifications;

# Check unread notifications
SELECT * FROM notifications WHERE is_read = 0;

# Exit
.quit
```

---

## Success Criteria

### Online Notifications
- ✅ 100% of notifications received within 5 seconds
- ✅ All notifications saved to database
- ✅ All notifications displayed in UI

### Offline Functionality
- ✅ Reminders created offline saved locally
- ✅ Local notifications trigger on time (±10 seconds tolerance)
- ✅ No crashes when offline

### Sync Performance
- ✅ Sync triggers automatically within 5 seconds of connection restore
- ✅ 100% of offline data synced to server
- ✅ No data loss or duplicates

### Background Handling
- ✅ Notifications received when app terminated
- ✅ Background handler saves to database
- ✅ Notifications visible after opening app

---

## Troubleshooting

### Issue: Notifications not received
**Check:**
- FCM token registered? (Check logs)
- Internet connection active?
- Notification permissions granted?
- Battery optimization disabled?

### Issue: Notifications not saving to database
**Check:**
- Database initialized? (Check logs for "Database initialized")
- userId available? (Check SharedPreferences)
- Any SQL errors in logs?

### Issue: Sync not working
**Check:**
- Connectivity service detecting online status?
- Network requests completing successfully?
- Any API errors in logs?

---

## Report Template

After completing all tests, summarize results:

```
NOTIFICATION PERFORMANCE & CONNECTIVITY TEST REPORT
===================================================

Test Date: _____________
Tester Name: _____________
App Version: _____________
Device: _____________
Android Version: _____________

Test Results Summary:
---------------------
Total Tests: 6
Passed: ___
Failed: ___
Success Rate: ___%

Detailed Results:
-----------------
Test 1 (Online FCM): ✅/❌ - _____________
Test 2 (Offline Local): ✅/❌ - _____________
Test 3 (Sync): ✅/❌ - _____________
Test 4 (Network Interrupt): ✅/❌ - _____________
Test 5 (Background): ✅/❌ - _____________
Test 6 (Multiple): ✅/❌ - _____________

Performance Metrics:
--------------------
Average Notification Delay: ______ seconds
Sync Success Rate: _____%
Local Notification Accuracy: ±______ seconds
Background Reception Rate: _____%

Critical Issues Found:
----------------------
1. _____________
2. _____________

Recommendations:
----------------
1. _____________
2. _____________

Conclusion:
-----------
□ System ready for production
□ Minor improvements needed
□ Major issues require fixing

Tested by: _____________
Date: _____________
Signature: _____________
```

---

## Automated Testing Script (Optional)

For more advanced testing, you can create an automated test script. Let me know if you need help creating Flutter integration tests or widget tests for these scenarios.
