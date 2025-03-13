import 'dart:io';
import 'package:flutter/material.dart';
import 'package:time4play/screens/edit_profile.dart';
import 'package:time4play/screens/settings/how_to_use.dart';
import 'package:time4play/widgets/gradient_border.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.switchScreen,
  });

  final void Function(int) switchScreen;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _settingsController;
  late Animation<double> _settingsFadeAnimation;

  @override
  void initState() {
    super.initState();
    _settingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _settingsFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _settingsController, curve: Curves.easeIn),
    );
    _settingsController.forward();
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            widget.switchScreen(0);
          },
          icon: Icon(isIos ? Icons.arrow_back_ios_new : Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _settingsFadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSettingsSection("Account", [
                  _buildSettingsTile(
                    Icons.person,
                    "Edit Profile",
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsTile(Icons.lock, "Change Password", () {}),
                  _buildSettingsTile(
                      Icons.credit_card, "Payment Methods", () {}),
                ]),
                _buildSettingsSection("Notifications", [
                  _buildSettingsTile(
                      Icons.notifications, "Booking Alerts", () {}),
                  _buildSettingsTile(
                      Icons.campaign, "Promotional Offers", () {}),
                ]),
                _buildSettingsSection("Preferences", [
                  _buildSettingsTile(Icons.sports, "Preferred Sport", () {}),
                  _buildSettingsTile(Icons.favorite, "Favorite Venues", () {}),
                  _buildSettingsTile(Icons.access_time, "Time Format", () {}),
                ]),
                _buildSettingsSection("Privacy & Security", [
                  _buildSettingsTile(
                      Icons.location_on, "Location Permissions", () {}),
                  _buildSettingsTile(Icons.history, "Activity History", () {}),
                ]),
                _buildSettingsSection("Support & Legal", [
                  _buildSettingsTile(Icons.help, "How It Works", () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => HowToUsePage(),
                      ),
                    );
                  }),
                  _buildSettingsTile(Icons.help, "Contact Support", () {}),
                  _buildSettingsTile(
                      Icons.article, "Terms & Conditions", () {}),
                  _buildSettingsTile(
                      Icons.privacy_tip, "Privacy Policy", () {}),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> tiles) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GradientBorderContainer(
        leftColor: Colors.grey.withOpacity(0.5),
        rightColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        borderWidth: 1,
        child: Card(
          elevation: 2,
          // margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide.none,
          ),
          color: Theme.of(context).cardColor.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...tiles,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
