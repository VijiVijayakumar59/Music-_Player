// ignore_for_file: avoid_print

import 'package:music_playerr/models/playlist.dart';
import 'package:music_playerr/models/songsmodel..dart';

newplaylist(String title) {
  final playlistbox = PlaylistSongsbox.getInstance();
  List<PlaylistSongs> dbplaylist = playlistbox.values.toList();
  bool isNotAvailable =
      dbplaylist.where((element) => element.playlistname == title).isEmpty;
  if (isNotAvailable) {
    List<Songs> playlistsongs = [];
    playlistbox.add(
      PlaylistSongs(playlistname: title, playlistssongs: playlistsongs),
    );
  }
}

list(Songs song, int index) {
  final playlistbox = PlaylistSongsbox.getInstance();
  List<PlaylistSongs> dbplaylist = playlistbox.values.toList();
  print(dbplaylist);
}

deleteplaylist(int index) {
  final playlistbox = PlaylistSongsbox.getInstance();
  playlistbox.deleteAt(index);
}

deletefromplaylist(int index) {
  final playlistbox = PlaylistSongsbox.getInstance();
  playlistbox.delete(index);
}
