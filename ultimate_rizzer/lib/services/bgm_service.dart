import 'package:audioplayers/audioplayers.dart';

class BgmService {
  static final BgmService _instance = BgmService._internal();
  factory BgmService() => _instance;
  BgmService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> play() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('sound/game_song.mp3'), volume: 0.5);
  }

  Future<void> stop() async {
    await _player.stop();
  }
}