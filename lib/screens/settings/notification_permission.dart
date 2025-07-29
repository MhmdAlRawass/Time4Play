import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen> {
  bool _isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final granted = OneSignal.Notifications.permission;
    setState(() {
      _isNotificationEnabled = granted;
    });
  }

  Future<void> _handleNotificationPermission() async {
    if (_isNotificationEnabled) {
      // If permission is already granted, guide the user to settings to disable
      openAppSettings();
    } else {
      // Request permission via OneSignal
      await OneSignal.Notifications.requestPermission(true);
      _checkNotificationPermission(); // Refresh UI based on new permission
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Permission'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isNotificationEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                _isNotificationEnabled
                    ? 'Notifications Enabled'
                    : 'Notifications Disabled',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _isNotificationEnabled
                    ? 'You are receiving important updates.'
                    : 'Enable notifications to stay updated!',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleNotificationPermission,
                  icon: Icon(
                    _isNotificationEnabled
                        ? Icons.settings
                        : Icons.notifications_active,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isNotificationEnabled
                        ? 'Manage in Settings'
                        : 'Enable Notifications',
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
