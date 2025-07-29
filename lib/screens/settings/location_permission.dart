import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isLocationGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      _isLocationGranted = status.isGranted;
    });
  }

  Future<void> _handleLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      
      openAppSettings();
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        setState(() {
          _isLocationGranted = true;
        });
      }
    } else if (status.isPermanentlyDenied) {
      
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Permission'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isLocationGranted ? Icons.location_on : Icons.location_off,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                _isLocationGranted
                    ? 'Location Enabled'
                    : 'Location Disabled',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _isLocationGranted
                    ? 'You have access to location-based features.'
                    : 'Enable location to improve your experience!',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleLocationPermission,
                  icon: Icon(
                    _isLocationGranted
                        ? Icons.settings
                        : Icons.location_searching,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isLocationGranted
                        ? 'Manage in Settings'
                        : 'Enable Location',
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
