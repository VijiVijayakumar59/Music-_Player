import 'package:hive_flutter/hive_flutter.dart';
part 'favouriteModel.g.dart';

@HiveType(typeId: 1)
class Favourites {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? songname;
  @HiveField(2)
  String? artist;
  @HiveField(3)
  int? duration;
  @HiveField(4)
  String? songurl;
  Favourites({
    required this.id,
    required this.songname,
    required this.artist,
    required this.duration,
    required this.songurl,
  });
}

String favourbox = 'Favourites';

class FavouriteBox {
  static Box<Favourites>? _box;
  static Box<Favourites> getInstance() {
    return _box ??= Hive.box(favourbox);
  }
}
