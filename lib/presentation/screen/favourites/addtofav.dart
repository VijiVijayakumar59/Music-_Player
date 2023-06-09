import 'dart:developer';
import 'package:music_playerr/functions/dbfunctions.dart';
import 'package:music_playerr/models/favouriteModel.dart';
import 'package:music_playerr/models/songsmodel..dart';

addfavour(int index) async {
  final box = SongBox.getInstance();
  List<Songs> allsongs = box.values.toList();
  List<Favourites> likedsongs = [];
  likedsongs = favouritedb.values.toList();

  bool isalready = likedsongs
      .where((element) => element.songname == allsongs[index].songname)
      .isEmpty;
  if (isalready) {
    favouritedb.add(
      Favourites(
          id: allsongs[index].id,
          songname: allsongs[index].songname,
          artist: allsongs[index].artist,
          duration: allsongs[index].duration,
          songurl: allsongs[index].songurl),
    );
  } else {
    likedsongs
        .where((element) => element.songname == allsongs[index].songname)
        .isEmpty;
    int currentidx =
        likedsongs.indexWhere((element) => element.id == allsongs[index].id);
    await favouritedb.deleteAt(currentidx);
    await favouritedb.deleteAt(index);
  }
  log(likedsongs[index].songname!);
}

removefavour(int index) async {
  final box = SongBox.getInstance();
  final box2 = FavouriteBox.getInstance();
  List<Favourites> favourite = box2.values.toList();
  List<Songs> songs = box.values.toList();
  int currentindex =
      favourite.indexWhere((element) => element.id == songs[index].id);
  await favouritedb.deleteAt(currentindex);
}

bool checkfavour(int index, BuildContext) {
  final box = SongBox.getInstance();
  List<Songs> allsongs = box.values.toList();
  List<Favourites> favouritesongs = [];
  Favourites value = Favourites(
      id: allsongs[index].id,
      songname: allsongs[index].songname,
      artist: allsongs[index].artist,
      duration: allsongs[index].duration,
      songurl: allsongs[index].artist);
  favouritesongs = favouritedb.values.toList();
  bool isAlready = favouritesongs
      .where((element) => element.songname == value.songname)
      .isEmpty;
  return isAlready ? true : false;
}
