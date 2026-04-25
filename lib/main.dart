import 'package:flutter/widgets.dart';

import 'app.dart';
import 'storage/settings_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LearnKanaApp(settingsStorage: SharedPreferencesSettingsStorage()));
}
