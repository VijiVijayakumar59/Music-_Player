import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:music_playerr/models/favouriteModel.dart';
import 'package:music_playerr/models/mostplayed.dart';
import 'package:music_playerr/models/recentplayed.dart';

late Box<Favourites> favouritedb;

openfavourite() async {
  favouritedb = await Hive.openBox<Favourites>(favourbox);
}

late Box<MostPlayed> mostplayedsongs;

openmostplayeddb() async {
  mostplayedsongs = await Hive.openBox("Mostplayed");
}

late Box<RecentlyPlayedModel> RecentlyPlayedbox;

openrecentlyplayeddb() async {
  RecentlyPlayedbox = await Hive.openBox("Recentlyplayed");
}

addRecently(RecentlyPlayedModel value) {
  List<RecentlyPlayedModel> list = RecentlyPlayedbox.values.toList();
  bool isNot =
      list.where((element) => element.songname == value.songname).isEmpty;
  if (isNot == true) {
    RecentlyPlayedbox.add(value);
  } else {
    int index =
        list.indexWhere((element) => element.songname == value.songname);
    RecentlyPlayedbox.deleteAt(index);
    // RecentlyPlayedbox.delete(value);
    RecentlyPlayedbox.add(value);
  }
  log('Added recent');
  log('${RecentlyPlayedbox.length}');
}

addMostplayed(int index, MostPlayed value) {
  final box = MostplayedBox.getInstance();
  List<MostPlayed> list = box.values.toList();
  bool isNot =
      list.where((element) => element.songname == value.songname).isEmpty;
  if (isNot == true) {
    box.add(value);
  } else {
    int index =
        list.indexWhere((element) => element.songname == value.songname);
    box.deleteAt(index);
    box.put(index, value);
  }
  int count = value.count;
  value.count = count + 1;
  log('i am most');
  log('${value.count}');
}
