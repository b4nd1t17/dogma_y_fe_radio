import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'services/radio_audio_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final session = await AudioSession.instance;
  await session.configure(
    const AudioSessionConfiguration.music(),
  );

  final audioHandler = await AudioService.init(
    builder: RadioAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId:
      'org.dogmayfe.radio.playback',
      androidNotificationChannelName:
      'Dogma y Fe Radio',
      androidNotificationChannelDescription:
      'Reproducción en segundo plano de Dogma y Fe Radio',
      androidStopForegroundOnPause: false,
      androidNotificationOngoing: false,
      androidResumeOnClick: true,
      notificationColor: Color(0xFF0D47A1),
    ),
  );

  runApp(
    DogmaYFeRadioApp(
      audioHandler: audioHandler,
    ),
  );
}
