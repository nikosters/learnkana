import 'package:flutter/material.dart';

import '../data/kana_entry.dart';
import '../data/kana_repository.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.settingsController,
    required this.repository,
    super.key,
  });

  final SettingsController settingsController;
  final KanaRepository repository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        final state = settingsController.state;
        final entries = repository.allEntries.where((entry) {
          final scriptVisible = switch (entry.script) {
            KanaScript.hiragana => state.hiraganaEnabled,
            KanaScript.katakana => state.katakanaEnabled,
          };

          return scriptVisible &&
              (state.yoonEnabled || entry.group != KanaGroup.yoon);
        }).toList();

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Theme'),
                          trailing: DropdownButton<AppThemeMode>(
                            value: state.themeMode,
                            onChanged: (value) {
                              if (value != null) {
                                settingsController.setThemeMode(value);
                              }
                            },
                            items: const [
                              DropdownMenuItem(
                                value: AppThemeMode.system,
                                child: Text('System'),
                              ),
                              DropdownMenuItem(
                                value: AppThemeMode.light,
                                child: Text('Light'),
                              ),
                              DropdownMenuItem(
                                value: AppThemeMode.dark,
                                child: Text('Dark'),
                              ),
                            ],
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Hiragana'),
                          value: state.hiraganaEnabled,
                          onChanged: settingsController.setHiraganaEnabled,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Katakana'),
                          value: state.katakanaEnabled,
                          onChanged: settingsController.setKatakanaEnabled,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Combinations'),
                          value: state.yoonEnabled,
                          onChanged: settingsController.setYoonEnabled,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 64,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final enabled = settingsController.isEntryEnabled(entry);

                      return _KanaToggle(
                        entry: entry,
                        enabled: enabled,
                        onTap: () {
                          settingsController.setEntryEnabled(entry, !enabled);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KanaToggle extends StatelessWidget {
  const _KanaToggle({
    required this.entry,
    required this.enabled,
    required this.onTap,
  });

  final KanaEntry entry;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? colorScheme.outline : colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Opacity(
            opacity: enabled ? 1 : 0.32,
            child: Text(entry.kana, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }
}
