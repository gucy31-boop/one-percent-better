import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/premium_provider.dart';
import '../../providers/settings_provider.dart';

/// Settings Screen – bewusst kurz: fünf Zeilen, keine Unterseiten-Flut.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isPremium = ref.watch(premiumProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          SwitchListTile(
            title: Text('Dark Mode', style: _titleStyle),
            value: settings.isDarkMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleDarkMode(value);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: Text('Tägliche Erinnerung', style: _titleStyle),
            subtitle: Text(
              settings.notificationsEnabled
                  ? 'Um ${_formatTime(settings.notificationHour, settings.notificationMinute)} Uhr'
                  : 'Ausgeschaltet',
            ),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleNotifications(value);
            },
          ),
          if (settings.notificationsEnabled)
            ListTile(
              title: Text('Uhrzeit ändern', style: _titleStyle),
              trailing: Text(
                _formatTime(
                  settings.notificationHour,
                  settings.notificationMinute,
                ),
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: settings.notificationHour,
                    minute: settings.notificationMinute,
                  ),
                );
                if (picked != null) {
                  await ref
                      .read(settingsProvider.notifier)
                      .setNotificationTime(picked.hour, picked.minute);
                }
              },
            ),
          const Divider(height: 1),
          ListTile(
            title: Text('Premium verwalten', style: _titleStyle),
            subtitle: Text(isPremium ? 'Aktiv' : 'Nicht aktiv'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/premium'),
          ),
          const Divider(height: 1),
          ListTile(
            title: Text('Datenschutz', style: _titleStyle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/privacy'),
          ),
          ListTile(
            title: Text('Impressum', style: _titleStyle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/impressum'),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '1% Better · Version 1.0.0',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  TextStyle get _titleStyle =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500);

  String _formatTime(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
