import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  AudioPlayer? _audioPlayer;
  double _currentPosition = 0.0;

  PageManager() {
    init();
  }

  void init({String? url}) async {
    print("url---------$url");
    _audioPlayer = AudioPlayer();
    // await _audioPlayer?.setUrl(url.toString());

    _audioPlayer?.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      await _audioPlayer?.setAudioSource(AudioSource.uri(Uri.parse(url ?? "")));
    } catch (e) {
      print("Error loading audio source: $e");
    }

    _audioPlayer?.playerStateStream.listen((playerState) {

      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer?.seek(Duration.zero);
        _audioPlayer?.pause();
      }
    });

    _audioPlayer?.positionStream.listen((position) {
      _currentPosition = progressNotifier.value.current.inSeconds.toDouble();
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer?.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer?.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer?.play();
  }

  void pause() {
    _audioPlayer?.pause();
  }

  void seek(Duration position) {
    print("position--$position");
    _audioPlayer?.seek(position);
  }

  void seekToNext(Duration position) {
    int currentPositionInSeconds = (_currentPosition + 10).round();
    _audioPlayer?.seek(Duration(seconds: currentPositionInSeconds));
  }
  void seekToBack(Duration position) {
    int currentPositionInSeconds = (_currentPosition - 10).round();
    _audioPlayer?.seek(Duration(seconds: currentPositionInSeconds));
  }

  void speedOne() {
    _audioPlayer?.setSpeed(1);
  }

  void speed1point25() {
    _audioPlayer?.setSpeed(1.25);
  }

  void speed1point50() {
    _audioPlayer?.setSpeed(1.50);
  }

  void speed0point75() {
    _audioPlayer?.setSpeed(0.75);
  }

  void speed1point75() {
    _audioPlayer?.setSpeed(1.75);
  }

  void speedTwo() {
    _audioPlayer?.setSpeed(2);
  }

  void dispose() {
    _audioPlayer?.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
