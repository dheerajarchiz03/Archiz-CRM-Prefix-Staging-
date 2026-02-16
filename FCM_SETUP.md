# Firebase Cloud Messaging (FCM) Setup Guide

## Overview
This project is now configured to receive push notifications using Firebase Cloud Messaging (FCM). The FCM token is automatically retrieved and stored when the app starts.

## Features Implemented

### ✅ FCM Token Management
- Automatic token retrieval on app startup
- Token storage in SharedPreferences
- Token refresh handling
- Easy token access via `FCMService`

### ✅ Notification Handling
- **Foreground notifications**: Displayed when app is open
- **Background notifications**: Handled when app is in background
- **Terminated notifications**: Handled when app is closed

### ✅ Notification Display
- Shows notification with title and message
- High priority notifications with sound
- Notification channel configured for Android

## How to Get FCM Token

### Method 1: Check Logs
When the app starts, the FCM token is automatically logged to the console:
```
🎯 FCM Token obtained: [YOUR_TOKEN_HERE]
💾 Token stored in SharedPreferences
```

### Method 2: Use FCMService Helper
```dart
import 'package:archiz_staging_admin/core/service/fcm_service.dart';

// Get stored token
String? token = await FCMService.getToken();

// Get fresh token (requests new token from Firebase)
String? freshToken = await FCMService.getFreshToken();

// Print token to console
await FCMService.printToken();
```

### Method 3: Access from NotificationService
```dart
import 'package:archiz_staging_admin/core/service/NotificationService.dart';

// Get stored token
String? token = await NotificationService.getStoredFCMToken();

// Get fresh token
String? freshToken = await NotificationService.getFCMToken();
```

## Sending Push Notifications

### Using Firebase Console
1. Go to Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Enter notification title and message
4. Select your app
5. Click "Send test message" and enter the FCM token

### Using FCM REST API
```bash
POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send
Headers:
  Authorization: Bearer YOUR_ACCESS_TOKEN
  Content-Type: application/json

Body:
{
  "message": {
    "token": "FCM_TOKEN_HERE",
    "notification": {
      "title": "Notification Title",
      "body": "Notification Message"
    }
  }
}
```

### Using cURL
```bash
curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "FCM_TOKEN_HERE",
      "notification": {
        "title": "Test Notification",
        "body": "This is a test message"
      }
    }
  }'
```

## Notification Payload Format

### Basic Notification
```json
{
  "message": {
    "token": "FCM_TOKEN",
    "notification": {
      "title": "Notification Title",
      "body": "Notification Message"
    }
  }
}
```

### Notification with Data
```json
{
  "message": {
    "token": "FCM_TOKEN",
    "notification": {
      "title": "Notification Title",
      "body": "Notification Message"
    },
    "data": {
      "key1": "value1",
      "key2": "value2"
    }
  }
}
```

## Sending Token to Your Backend (Optional)

To send the FCM token to your backend server, uncomment and modify the `sendTokenToServer` method in `NotificationService.dart`:

```dart
// In NotificationService.dart
static Future<void> sendTokenToServer(String token) async {
  try {
    // Example API call
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT/fcm-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_AUTH_TOKEN',
      },
      body: jsonEncode({
        'token': token,
        'user_id': userId, // Add user ID if available
      }),
    );
    
    if (response.statusCode == 200) {
      log('Token sent to server successfully');
    }
  } catch (e) {
    log('Error sending token to server: $e');
  }
}
```

Then call it after getting the token:
```dart
String? token = await NotificationService.getFCMToken();
if (token != null) {
  await NotificationService.sendTokenToServer(token);
}
```

## Testing Notifications

### Test from Firebase Console
1. Get your FCM token from app logs
2. Go to Firebase Console → Cloud Messaging
3. Click "Send test message"
4. Paste your FCM token
5. Enter title and message
6. Click "Test"

### Test from Code
You can test notifications locally using the Firebase Admin SDK or FCM REST API.

## Important Notes

1. **Token Refresh**: The token automatically refreshes when needed. The app listens for token refresh events and updates SharedPreferences.

2. **Permissions**: The app requests notification permissions on Android 13+. Make sure to grant permissions when prompted.

3. **Background Messages**: Background messages are handled in a separate isolate. Make sure the background handler is a top-level function.

4. **Notification Channels**: Android requires notification channels. The app creates a "High Importance Notifications" channel automatically.

5. **Token Storage**: The FCM token is stored in SharedPreferences with the key `fcm_token_key`.

## Troubleshooting

### Token Not Received
- Check internet connection
- Verify Firebase configuration (google-services.json)
- Check Firebase Console for project setup
- Review app logs for error messages

### Notifications Not Showing
- Check notification permissions
- Verify notification channel is created
- Check if app is in Do Not Disturb mode
- Review Android notification settings

### Background Notifications Not Working
- Ensure background message handler is registered before `runApp()`
- Check if handler is a top-level function
- Verify Firebase is initialized in background handler

## Files Modified

1. `lib/core/service/NotificationService.dart` - Enhanced with FCM token management
2. `lib/main.dart` - Added FCM initialization and token retrieval
3. `lib/core/helper/shared_preference_helper.dart` - Added FCM token key
4. `android/app/src/main/AndroidManifest.xml` - Added notification permissions
5. `lib/core/service/fcm_service.dart` - New helper service for easy token access

## Next Steps

1. Get your FCM token from app logs
2. Test sending notifications from Firebase Console
3. (Optional) Integrate token sending to your backend
4. Customize notification handling based on your needs

