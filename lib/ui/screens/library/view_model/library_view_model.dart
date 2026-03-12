import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  List<Song>? _songs;
  bool _isLoading = true;
  String? _error;

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }
List<Song>? get songs => _songs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    // 1 - Fetch songs
    try {
      _isLoading = true;
      notifyListeners();

    // 2 - notify listeners
     _songs = await songRepository.fetchSongs();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _songs = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
