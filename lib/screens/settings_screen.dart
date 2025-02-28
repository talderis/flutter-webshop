import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beállítások'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Értesítések'),
            subtitle: const Text('Értesítések engedélyezése vagy tiltása'),
            trailing: Switch(
              value: settingsService.notificationsEnabled,
              onChanged: (value) {
                settingsService.setNotificationsEnabled(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Értesítések bekapcsolva'
                          : 'Értesítések kikapcsolva',
                    ),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Sötét mód'),
            subtitle: const Text('Alkalmazás megjelenésének beállítása'),
            trailing: Switch(
              value: settingsService.darkModeEnabled,
              onChanged: (value) {
                settingsService.setDarkModeEnabled(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Sötét mód bekapcsolva'
                          : 'Sötét mód kikapcsolva',
                    ),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Nyelv'),
            subtitle: Text('Jelenlegi nyelv: ${settingsService.selectedLanguage}'),
            trailing: DropdownButton<String>(
              value: settingsService.selectedLanguage,
              items: const [
                DropdownMenuItem(
                  value: 'Magyar',
                  child: Text('Magyar'),
                ),
                DropdownMenuItem(
                  value: 'English',
                  child: Text('English'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settingsService.setSelectedLanguage(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nyelv beállítva: $value'),
                    ),
                  );
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Az alkalmazásról'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Modern Webshop',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 Modern Webshop',
              );
            },
          ),
        ],
      ),
    );
  }
} 