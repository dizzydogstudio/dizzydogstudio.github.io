# Privacy Policy  
**App Name:** Node Expense: Track Together  
**Platform:** iOS  
**Last Updated:** 2026-03-17  
  
## 1. Overview  
Node Expense: Track Together (“we”, “our”) respects your privacy. This Privacy Policy explains what data Node Expense collects, how it is used, and what choices you have when using Node Expense.  
  
## 2. Data We Collect  
  
### 2.1 Information You Provide  
- Expense records (amounts, notes, categories)  
- Group data (group name, members, settings)  
- Group expenses and settlements  
- Display name (used to identify you in shared groups)  
- Optional location data (only if you enable it)  
- Calendar access (only to the calendars you select)  
  
### 2.2 Automatically Collected Data  
- Anonymous usage analytics (via Firebase Analytics)  
- Anonymous device identifier — used to maintain your subscription and app data across reinstalls  
- Crash logs and diagnostics  
- Device and app performance information  
- Push notification tokens — used to deliver group activity updates and personalized threshold alerts when enabled  
  
This data is used only to improve the stability, performance, and user experience of Node Expense.  
  
### 2.3 Subscriptions & Payments  
Purchases and subscriptions are processed by Apple and RevenueCat. We do not receive your credit card or payment details. RevenueCat stores anonymous subscriber identifiers to manage your subscription status, "Lifetime" access, and free trial period. This data is retained for as long as necessary to verify your access to PRO features across device reinstalls and is processed independently of your Group Expense cloud data.
  
## 3. Third-Party Services  
Node Expense uses the following third-party services:  
  
- RevenueCat — Subscription and in-app purchase management, including free trial tracking  
- Google AdMob — Banner, Rewarded and interstitial advertisements  
- Firebase Analytics — Anonymous usage analytics  
- Firebase Firestore — Group data syncing (expenses, members, settlements, deletion requests)  
- Firebase Authentication — Anonymous user identification for subscription continuity  
- Firebase Cloud Functions — Background tasks including group deletion and push notification delivery  
- Firebase Cloud Messaging (FCM) — Push notifications for group activity  
  
Firebase is used as a sync layer for group-related features only. Personal (non-group) expense data is not uploaded to cloud services.  
  
## 4. Ads  
Node Expense is supported by advertisements for users on the free tier. These may include banners, interstitial ads when reaching monthly limits, or optional rewarded ads to unlock additional expense slots.  

To provide a more personalized experience, we may ask for your permission to track your activity. This helps our ad partners serve more relevant ads and measure their effectiveness. If you choose not to be tracked, you will still see the same number of ads, but they may be less relevant to you. Your financial data remains private and is never shared with advertisers.  
  
## 5. Location Data  
Location data is optional and only collected if you explicitly enable it in Settings for expense tracking. When enabled, your location is recorded with new expenses. Location data is stored locally on your device and is not uploaded to cloud services. You can disable location access at any time in your iOS Settings.  
  
## 6. Calendar Access  
Node Expense only accesses the calendars you select. Calendar access is used solely to display and sync expense entries as calendar events. Calendar data is never shared with third parties.  
  
## 7. Data Storage, Retention & Encryption  
  
### 7.1 On-Device Storage  
The following data is stored locally on your device using SwiftData (Apple's secure local storage framework):  
- Personal (non-group) expense records  
- App settings and preferences  
- Local copies of group data for offline access  
- Cached group expenses for offline viewing  
  
Personal (non-group) expense data never leaves your device unless you explicitly export or back it up. Expenses from deleted groups are retained locally on your device with a 'deleted group' marker, so your records are preserved.  
  
### 7.2 Cloud Storage for Group Features  
For group features, selected data is synced to Firebase Firestore so all group members can see the same information:  
  
- Group documents (name, description, icon, members, permissions, share code)  
- Group expenses (amount, category, note, date, location if enabled, payer identity)  
- Group settlements (payment records between members)  
- Group deletion requests and member votes  
- Trial start dates (used for reinstall recovery)  
- Push notification tokens (FCM)  
  
Cloud sync is used only for group features. Individual personal expenses are never uploaded.  
  
### 7.3 Encryption & Backups  
- Users with feature access (PRO subscription or active free trial) may enable encrypted backups using AES-256-GCM encryption.  
- You control how long expense records are retained (all time or a limited number of years).  
- Backup files are exported to a location you choose (iCloud Drive, On My Device, or other iOS Files locations).  
- Backup encryption key is managed automatically and stored exclusively in your iCloud Keychain and is never transmitted to our servers or accessible to us as developers. The key is not visible in the Passwords app but syncs securely to your other devices via iCloud. Only your app, on devices signed into your Apple ID, can access the key to encrypt or restore your backups.  
  
## 8. Data Migration  
Users with feature access (PRO subscription or active free trial) may export and import their data in JSON format. Node Expense does not have access to your exported files. Exported files are exported to a location you choose (iCloud Drive, On My Device, or other iOS Files locations).  
  
## 9. Data Deletion  
You can delete your data in the following ways:  
- Delete individual or all personal expenses from within Node Expense  
- Leave or request deletion of a group — group data is removed from Firebase when all members agree  
- Group expenses marked as 'keep on deletion' remain on your device locally with a deleted-group marker; they are not re-uploaded  
- Uninstalling Node Expense removes all locally stored data from your device  
  
Note: Firebase group data (expenses, settlements, member records) may persist until the group is formally deleted through the in-app deletion flow.  
  
## 10. Children’s Privacy  
Node Expense is not intended for children under 13. We do not knowingly collect personal data from children under 13. If you believe a child has provided personal information, please contact us.  
  
## 11. Your Rights  
You can:  
- Disable location access in iOS Settings  
- Revoke calendar access in iOS Settings  
- Delete your local expense data within Node Expense  
- Export your data before deleting  
- Request group deletion (removes group data from Firebase for all members)  
- Cancel your subscription at any time through Apple App Store settings  
- Stop using backups or encrypted exports at any time  
  
## 12. Changes to This Policy  
We may update this Privacy Policy from time to time. Changes will be reflected by the "Last Updated" date at the top of this document. Continued use of Node Expense after changes constitutes acceptance of the updated policy.

## 13. Contact  
If you have questions about this Privacy Policy or your data, please contact:  
**Email:** thedizzydogstudio@gmail.com
