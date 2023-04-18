// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_playerr/functions/addplaylist.dart';
import 'package:music_playerr/models/playlist.dart';
import 'package:music_playerr/models/recentplayed.dart';
import 'package:music_playerr/models/songsmodel..dart';
import 'package:music_playerr/presentation/screen/favourites/addtofav.dart';
import 'package:music_playerr/presentation/widget/songtile.dart';
import 'package:music_playerr/presentation/widget/text_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../models/mostplayed.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

final OnAudioQuery audioQuery = OnAudioQuery();
final AssetsAudioPlayer Player = AssetsAudioPlayer();
final box = SongBox.getInstance();
final mostbox = MostplayedBox.getInstance();
final List<MostPlayed> mostplayed = mostbox.values.toList();

class _SongListState extends State<SongList> {
  List<Audio> importSongs = [];
  bool isadded = true;

  @override
  void initState() {
    List<Songs> databasesongs = box.values.toList();
    for (var i in databasesongs) {
      importSongs.add(
        Audio.file(
          i.songurl!,
          metas: Metas(
            title: i.songname,
            artist: i.artist,
            id: i.id.toString(),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 10),
              child: TextWidget(
                  commontext: "All songs",
                  selectcolor: Colors.black,
                  textSize: 18,
                  textweight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            Expanded(
              child: ValueListenableBuilder<Box<Songs>>(
                  valueListenable: box.listenable(),
                  builder: (context, Box<Songs> allsongbox, child) {
                    List<Songs> databasesongs = allsongbox.values.toList();
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            RecentlyPlayedModel? recentsong;
                            return listtile(
                                assetAudio: importSongs,
                                recent: recentsong,
                                mostsong: mostplayed,
                                songs: databasesongs[index],
                                image: databasesongs[index].id!,
                                song: databasesongs[index].songname!,
                                artist: databasesongs[index].artist!,
                                index: index,
                                isadded: isadded,
                                context: context);
                          },
                          itemCount: databasesongs.length),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

showOptions(BuildContext context, int index) {
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.orange,
        alignment: Alignment.bottomCenter,
        content: SizedBox(
          height: 150,
          width: vwidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    showPlaylistOptionsadd(context);
                  },
                  icon: const Icon(
                    Icons.playlist_add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Create new playlist',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    showPlaylistOptions(context, index);
                  },
                  icon: const Icon(
                    Icons.playlist_add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add to Playlist',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (checkfavour(index, BuildContext)) {
                      addfavour(index);
                    } else if (!checkfavour(index, BuildContext)) {
                      removefavour(index);
                    }
                    setState(() {});
                  },
                  icon: checkfavour(index, BuildContext)
                      ? const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                  label: checkfavour(index, BuildContext)
                      ? const Text(
                          'Add to Favourites',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )
                      : const Text(
                          'Remove froms Favourites',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                )
              ],
            ),
          ),
        ),
      );
    }),
  );
}

showPlaylistOptions(BuildContext context, int songindex) {
  final box = PlaylistSongsbox.getInstance();
  final songbox = SongBox.getInstance();
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: ((context) => StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              backgroundColor: Colors.orange,
              alignment: Alignment.bottomCenter,
              content: SizedBox(
                height: 200,
                width: vwidth,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<Box<PlaylistSongs>>(
                          valueListenable: box.listenable(),
                          builder: ((context, Box<PlaylistSongs> playlistsongs,
                              child) {
                            List<PlaylistSongs> playlistsong =
                                playlistsongs.values.toList();
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: playlistsong.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    PlaylistSongs? playsongs =
                                        playlistsongs.getAt(index);
                                    List<Songs> playsongdb =
                                        playsongs!.playlistssongs!;
                                    List<Songs> songdb =
                                        songbox.values.toList();
                                    bool isAlreadyAdded = playsongdb.any(
                                        (element) =>
                                            element.id == songdb[songindex].id);
                                    if (!isAlreadyAdded) {
                                      playsongdb.add(
                                        Songs(
                                          id: songdb[songindex].id,
                                          songname: songdb[songindex].songname,
                                          artist: songdb[songindex].artist,
                                          duration: songdb[songindex].duration,
                                          songurl: songdb[songindex].songurl,
                                        ),
                                      );
                                    }
                                    playlistsongs.putAt(
                                      index,
                                      PlaylistSongs(
                                          playlistname:
                                              playlistsong[index].playlistname,
                                          playlistssongs: playsongdb),
                                    );
                                    log('song added to${playlistsong[index].playlistname}');
                                    Navigator.pop(context);
                                  },
                                  title: Text(
                                    playlistsong[index].playlistname!,
                                    style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            );
                          }))
                    ],
                  )),
                ),
              ),
            );
          }),
        )),
  );
}

showPlaylistOptionsadd(BuildContext context) {
  final myController = TextEditingController();
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.orange.shade600,
      alignment: Alignment.bottomCenter,
      content: SizedBox(
        height: 250,
        width: vwidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'New Playlist',
                    style:
                        GoogleFonts.raleway(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: vwidth * 0.90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: myController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white10,
                          label: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Enter Playlist Name:',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, color: Colors.black),
                            ),
                          ),
                          // alignLabelWithHint: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: vwidth * 0.43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: Text(
                          'Cancel',
                          style: GoogleFonts.raleway(
                              fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: vwidth * 0.43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.done,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          newplaylist(myController.text);
                          Navigator.pop(context);
                        },
                        label: Text(
                          'Done',
                          style: GoogleFonts.raleway(
                              fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
