import 'package:flutter/material.dart';

import '../data/kana_repository.dart';
import '../quiz/quiz_controller.dart';
import '../settings/settings_controller.dart';
import 'settings_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    required this.quizController,
    required this.settingsController,
    required this.repository,
    super.key,
  });

  final QuizController quizController;
  final SettingsController settingsController;
  final KanaRepository repository;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _revealedEntryId;

  @override
  void initState() {
    super.initState();
    widget.quizController.addListener(_syncInput);
  }

  void _syncInput() {
    final currentEntryId = widget.quizController.state.currentEntry.id;
    if (_revealedEntryId != null && _revealedEntryId != currentEntryId) {
      setState(() {
        _revealedEntryId = null;
      });
    }

    final input = widget.quizController.state.input;
    if (_textController.text == input) {
      return;
    }

    _textController.value = TextEditingValue(
      text: input,
      selection: TextSelection.collapsed(offset: input.length),
    );
  }

  @override
  void dispose() {
    widget.quizController.removeListener(_syncInput);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.quizController,
      builder: (context, _) {
        final state = widget.quizController.state;

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => SettingsPage(
                              settingsController: widget.settingsController,
                              repository: widget.repository,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkResponse(
                          onTap: () {
                            setState(() {
                              _revealedEntryId =
                                  _revealedEntryId == state.currentEntry.id
                                  ? null
                                  : state.currentEntry.id;
                            });
                          },
                          child: Text(
                            state.currentEntry.kana,
                            key: const Key('kanaGlyph'),
                            style: const TextStyle(
                              fontSize: 96,
                              height: 1,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                          child: Center(
                            child: Text(
                              _revealedEntryId == state.currentEntry.id
                                  ? state.currentEntry.romaji
                                  : '',
                              key: const Key('kanaRomajiHint'),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          key: const Key('romajiInput'),
                          controller: _textController,
                          focusNode: _focusNode,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: widget.quizController.updateInput,
                          onSubmitted: (_) => widget.quizController.submit(),
                        ),
                      ],
                    ),
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
