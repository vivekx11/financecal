import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../utils/theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        final isDark = themeManager.isDarkMode;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.paddingM,
            AppConstants.paddingL,
            AppConstants.paddingM,
            120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: AppTheme.getHeadingLarge(isDark: isDark).copyWith(
                color: isDark ? AppTheme.getTextPrimary(isDark) : Colors.black,
              )),
              const SizedBox(height: 8),
              Text(
                'Customize your experience',
                style: AppTheme.getBodyMedium(isDark: isDark),
              ),
              const SizedBox(height: 32),
              
              // Preferences Section
              _buildSectionTitle('Preferences', isDark),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.palette_rounded,
                title: 'Theme',
                subtitle: isDark ? 'Dark mode enabled' : 'Light mode enabled',
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    themeManager.toggleTheme();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(!value ? 'Switched to light mode' : 'Switched to dark mode'),
                        backgroundColor: AppTheme.getSurface(!value),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  activeColor: AppTheme.primaryBlue,
                  inactiveThumbColor: AppTheme.getTextMuted(isDark),
                  inactiveTrackColor: AppTheme.getSurface(isDark),
                ),
                isDark: isDark,
              ),
              _buildSettingsTile(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                subtitle: 'Enable push notifications',
                trailing: Switch(
                  value: _notifications,
                  onChanged: (value) {
                    setState(() => _notifications = value);
                  },
                  activeColor: AppTheme.primaryBlue,
                  inactiveThumbColor: AppTheme.getTextMuted(isDark),
                  inactiveTrackColor: AppTheme.getSurface(isDark),
                ),
                isDark: isDark,
              ),
              _buildSettingsTile(
                icon: Icons.currency_rupee_rounded,
                title: 'Currency',
                subtitle: 'Indian Rupee (₹)',
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.getTextMuted(isDark),
                  size: 16,
                ),
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Currency selection coming soon'),
                        backgroundColor: AppTheme.getSurface(isDark),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                },
                isDark: isDark,
              ),
              
              const SizedBox(height: 32),
              
              // About Section
              _buildSectionTitle('About', isDark),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.info_rounded,
                title: 'About App',
                subtitle: 'Version 1.0.0',
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.getTextMuted(isDark),
                  size: 16,
                ),
                isDark: isDark,
              ),
              _buildSettingsTile(
                icon: Icons.star_rounded,
                title: 'Rate App',
                subtitle: 'Share your feedback',
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.getTextMuted(isDark),
                  size: 16,
                ),
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Thank you for rating us!'),
                        backgroundColor: AppTheme.getSurface(isDark),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                },
                isDark: isDark,
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.getTextMuted(isDark),
                  size: 16,
                ),
                isDark: isDark,
              ),
              
              const SizedBox(height: 40),
              
              // App Info Card
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryBlue.withValues(alpha: 0.15),
                          AppTheme.primaryBlueDark.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.calculate_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Finance Calculator',
                          style: AppTheme.getHeadingSmall(isDark: isDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Smart calculations for smart decisions',
                          style: AppTheme.getBodySmall(isDark: isDark),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Made with ❤️',
                          style: AppTheme.getBodySmall(isDark: isDark).copyWith(
                            color: AppTheme.getTextMuted(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: AppTheme.getBodyMedium(isDark: isDark).copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.primaryBlue,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.getCardDecoration(isDark: isDark),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.getBodyLarge(isDark: isDark).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTheme.getBodySmall(isDark: isDark),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}