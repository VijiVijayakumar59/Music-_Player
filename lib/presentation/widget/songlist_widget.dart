// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:music_playerr/models/recentplayed.dart';
// import 'package:music_playerr/models/songsmodel..dart';
// import 'package:music_playerr/presentation/screen/now_playing.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import '../../functions/dbfunctions.dart';
// import '../../models/mostplayed.dart';
// import '../screen/songs.dart';

// // ignore: must_be_immutable
// class SongTile extends StatefulWidget {
//   final int pictures;
//   final String songname;
//   final String artists;

//   final int index;
//   RecentlyPlayedModel? recent;
//   int value;
//   SongTile({
//     super.key,
//     required this.pictures,
//     required this.songname,
//     required this.artists,
//     required this.value,
//     required this.index,
//     this.recent,
//   });

//   @override
//   State<SongTile> createState() => _SongTileState();
// }

// final allDbmusics = SongBox.getInstance();
// List<Songs> alldbsongs = allDbmusics.values.toList();
// //final OnAudioQuery _audioQuery = OnAudioQuery();
// final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId("0");
// final songbox = SongBox.getInstance();

// // final mostbox = MostplayedBox.getInstance();
// // final List<MostPlayed> mostplayed = mostbox.values.toList();

// class _SongTileState extends State<SongTile> {
//   List<Audio> convertAudios = [];

//   @override
//   void initState() {
//     List<Songs> dbsongs = songbox.values.toList();
//     for (var item in dbsongs) {
//       convertAudios.add(
//         Audio.file(
//           item.songurl!,
//           metas: Metas(
//               title: item.songname,
//               artist: item.artist,
//               id: item.id.toString()),
//         ),
//       );
//     }

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(6.0),
//       child: InkWell(
//         onTap: () {
//           // HomeScreen.nowplayingindex.value = widget.value;
//           widget.recent = RecentlyPlayedModel(
//             id: widget.index,
//             index: widget.index,
//             artist: widget.artists,
//             songname: widget.songname,
//           );
//           NowPlayingPage.nowplayingindex.value = widget.index;
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (ctx) => NowPlayingPage(),
//             ),
//           );
//           print('i am list tile inkewell');
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             QueryArtworkWidget(
//               quality: 100,
//               artworkWidth: MediaQuery.of(context).size.width * 0.17,
//               artworkHeight: MediaQuery.of(context).size.height * 0.08,
//               keepOldArtwork: true,
//               artworkBorder: BorderRadius.circular(10),
//               id: widget.pictures,
//               type: ArtworkType.AUDIO,
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.01,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: 150,
//                   child: Text(
//                     widget.songname,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 150,
//                   child: Text(
//                     widget.artists,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 16,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.001,
//             ),
//             IconButton(
//               icon: const Icon(Icons.play_circle_filled),
//               onPressed: () {
//                 // NowPlayingPage.nowplayingindex.value = widget.value;
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (ctx) => NowPlayingPage(),
//                 //   ),
//                 // );
//               },
//               color: Colors.orange,
//             ),
//             // SpeedDial(
//             //   animatedIcon: AnimatedIcons.ellipsis_search,
//             //   backgroundColor: Colors.transparent,
//             //   foregroundColor: Colors.orange,
//             //   activeForegroundColor: Colors.transparent,
//             //   activeBackgroundColor: Colors.transparent,
//             //   elevation: 0.0,
//             //   buttonSize: const Size(35, 35),
//             //   direction: SpeedDialDirection.down,
//             //   children: [
//             //     SpeedDialChild(
//             //       child: IconButton(
//             //         onPressed: () {},
//             //         icon: const Icon(Icons.favorite_outline),
//             //       ),
//             //     ),
//             //     SpeedDialChild(
//             //       child: IconButton(
//             //         onPressed: () {},
//             //         icon: const Icon(Icons.playlist_add),
//             //       ),
//             //     )
//             //   ],
//             // ),
//             IconButton(
//               onPressed: () {
//                 showOptions(context, widget.index);
//               },
//               icon: const Icon(
//                 Icons.more_vert,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
