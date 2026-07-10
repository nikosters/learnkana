import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:learnkana/data/kana_entry.dart';
import 'package:learnkana/data/kana_repository.dart';
import 'package:learnkana/settings/settings_controller.dart';
import 'package:learnkana/settings/settings_state.dart';
import 'package:learnkana/storage/settings_storage.dart';

void main() {
  const repository = KanaRepository();

  test('defaults enable hiragana and katakana without yoon', () async {
    final controller = SettingsController(
      repository: repository,
      storage: _MemorySettingsStorage(),
    );

    await controller.load();

    expect(controller.state.hiraganaEnabled, isTrue);
    expect(controller.state.katakanaEnabled, isTrue);
    expect(controller.state.yoonEnabled, isFalse);
    expect(
      controller.state.enabledEntryIds,
      isNot(contains('hiragana.yoon.nya')),
    );
  });

  test('disabled entry IDs are respected', () async {
    final storage = _MemorySettingsStorage(
      const SettingsSnapshot(
        hiraganaEnabled: true,
        katakanaEnabled: false,
        yoonEnabled: false,
        disabledEntryIds: {'hiragana.basic.a'},
      ),
    );
    final controller = SettingsController(
      repository: repository,
      storage: storage,
    );

    await controller.load();

    expect(
      controller.state.enabledEntryIds,
      isNot(contains('hiragana.basic.a')),
    );
    expect(controller.state.enabledEntryIds, contains('hiragana.basic.i'));
    expect(
      controller.state.enabledEntryIds,
      isNot(contains('katakana.basic.a')),
    );
  });

  test('prevents empty enabled set', () async {
    final controller = SettingsController(
      repository: repository,
      storage: _MemorySettingsStorage(),
    );

    await controller.load();
    await controller.setKatakanaEnabled(false);

    final hiraganaEntries = repository.allEntries.where(
      (entry) =>
          entry.script == KanaScript.hiragana && entry.group != KanaGroup.yoon,
    );
    for (final entry in hiraganaEntries) {
      await controller.setEntryEnabled(entry, false);
    }

    expect(controller.state.enabledEntryIds, hasLength(1));
  });

  test('falls back to defaults when stored settings enable nothing', () async {
    final storage = _MemorySettingsStorage(
      const SettingsSnapshot(
        hiraganaEnabled: false,
        katakanaEnabled: false,
        yoonEnabled: false,
        disabledEntryIds: {},
      ),
    );
    final controller = SettingsController(
      repository: repository,
      storage: storage,
    );

    await controller.load();

    expect(controller.state.hiraganaEnabled, isTrue);
    expect(controller.state.katakanaEnabled, isTrue);
    expect(controller.state.enabledEntryIds, isNotEmpty);
  });

  test('serializes saves so the newest settings are persisted last', () async {
    final storage = _ControlledSettingsStorage();
    final controller = SettingsController(
      repository: repository,
      storage: storage,
    );
    await controller.load();

    final firstChange = controller.setKatakanaEnabled(false);
    await storage.firstWriteStarted.future;
    final secondChange = controller.setYoonEnabled(true);

    await Future<void>.delayed(Duration.zero);
    expect(storage.startedWrites, 1);

    storage.allowFirstWrite.complete();
    await firstChange;
    await secondChange;

    expect(storage.startedWrites, 2);
    expect(storage.snapshot?.katakanaEnabled, isFalse);
    expect(storage.snapshot?.yoonEnabled, isTrue);
  });
}

class _MemorySettingsStorage implements SettingsStorage {
  _MemorySettingsStorage([this.snapshot]);

  SettingsSnapshot? snapshot;

  @override
  Future<SettingsSnapshot?> read() async => snapshot;

  @override
  Future<void> write(SettingsSnapshot snapshot) async {
    this.snapshot = snapshot;
  }
}

class _ControlledSettingsStorage implements SettingsStorage {
  final firstWriteStarted = Completer<void>();
  final allowFirstWrite = Completer<void>();
  SettingsSnapshot? snapshot;
  int startedWrites = 0;

  @override
  Future<SettingsSnapshot?> read() async => null;

  @override
  Future<void> write(SettingsSnapshot snapshot) async {
    startedWrites++;
    if (startedWrites == 1) {
      firstWriteStarted.complete();
      await allowFirstWrite.future;
    }
    this.snapshot = snapshot;
  }
}
