import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../core/app_constants.dart';

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  RadioAudioHandler() {
    mediaItem.add(
      const MediaItem(
        id: AppConstants.streamUrl,
        album: AppConstants.appName,
        title: 'Emisión en directo',
        artist: 'La voz de la sana doctrina',
      ),
    );

    _player.playbackEventStream.listen(
      _broadcastState,
      onError: (Object error, StackTrace stackTrace) {
        playbackState.add(
          playbackState.value.copyWith(
            processingState: AudioProcessingState.error,
            errorMessage: 'No se pudo reproducir la emisora.',
          ),
        );
      },
    );
  }

  final AudioPlayer _player = AudioPlayer(
    userAgent: 'DogmaYFeRadio/2.0 Android',
    useProxyForRequestHeaders: false,
  );

  bool _streamLoaded = false;

  @override
  Future<void> play() async {
    try {
      if (!_streamLoaded) {
        playbackState.add(
          playbackState.value.copyWith(
            processingState: AudioProcessingState.loading,
            errorMessage: null,
          ),
        );

        await _player
            .setUrl(
              AppConstants.streamUrl,
              headers: const {
                'Icy-MetaData': '1',
                'Accept': 'audio/mpeg,audio/*;q=0.9,*/*;q=0.8',
              },
            )
            .timeout(const Duration(seconds: 20));

        _streamLoaded = true;
      }

      unawaited(_player.play());
    } on TimeoutException {
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
          errorMessage: 'La emisora tardó demasiado en responder.',
        ),
      );
    } catch (_) {
      _streamLoaded = false;
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
          errorMessage: 'No se pudo conectar con la emisora.',
        ),
      );
    }
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    _streamLoaded = false;

    playbackState.add(
      playbackState.value.copyWith(
        controls: const [MediaControl.play],
        androidCompactActionIndices: const [0],
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero,
      ),
    );

    await super.stop();
  }

  void _broadcastState(PlaybackEvent event) {
    final state = switch (_player.processingState) {
      ProcessingState.idle => AudioProcessingState.idle,
      ProcessingState.loading => AudioProcessingState.loading,
      ProcessingState.buffering => AudioProcessingState.buffering,
      ProcessingState.ready => AudioProcessingState.ready,
      ProcessingState.completed => AudioProcessingState.completed,
    };

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          if (_player.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
        ],
        androidCompactActionIndices: const [0, 1],
        processingState: state,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: 0,
      ),
    );
  }
}
