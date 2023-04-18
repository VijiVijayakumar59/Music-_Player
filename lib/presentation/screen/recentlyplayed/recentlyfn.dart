// // ignore_for_file: unused_local_variable, avoid_print

// import 'package:hive/hive.dart';
// import 'package:music_playerr/models/recentplayed.dart';

// late Box<RecentlyPlayedModel> recentplaybox;
// addRecentPlay(RecentlyPlayedModel value) {
//   List<RecentlyPlayedModel> recentList = recentplaybox.values.toList();
//   bool isNot =
//       recentList.where((element) => element.songname == value.songname).isEmpty;
//   if (isNot = true) {
//     recentplaybox.add(value);
//   } else {
//     int position =
//         recentList.indexWhere((element) => element.songname == value.songname);
//     recentplaybox.deleteAt(position);
//     recentplaybox.add(value);
//     print(recentplaybox);
//   }

// }
