import 'package:flutter/material.dart';

import 'data/kana_repository.dart';
import 'quiz/quiz_controller.dart';
import 'settings/settings_controller.dart';
import 'storage/settings_storage.dart';
import 'ui/quiz_page.dart';

class LearnKanaApp extends StatefulWidget {
  const LearnKanaApp({required this.settingsStorage, super.key});

  final SettingsStorage settingsStorage;

  @override
  State<LearnKanaApp> createState() => _LearnKanaAppState();
}

class _LearnKanaAppState extends State<LearnKanaApp> {
  final KanaRepository _repository = const KanaRepository();
  late final SettingsController _settingsController;
  late final QuizController _quizController;
  late final Future<void> _loadSettings;

  @override
  void initState() {
    super.initState();
    _settingsController = SettingsController(
      repository: _repository,
      storage: widget.settingsStorage,
    );
    _quizController = QuizController(repository: _repository);
    _settingsController.addListener(_syncQuiz);
    _loadSettings = _settingsController.load().then((_) {
      _quizController.updateEntries(_settingsController.state.enabledEntryIds);
    });
  }

  void _syncQuiz() {
    _quizController.updateEntries(_settingsController.state.enabledEntryIds);
  }

  @override
  void dispose() {
    _settingsController.removeListener(_syncQuiz);
    _settingsController.dispose();
    _quizController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0f766e),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfffcfcfc),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: _loadSettings,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(body: SizedBox.expand());
          }

          return QuizPage(
            quizController: _quizController,
            settingsController: _settingsController,
            repository: _repository,
          );
        },
      ),
    );
  }
}
