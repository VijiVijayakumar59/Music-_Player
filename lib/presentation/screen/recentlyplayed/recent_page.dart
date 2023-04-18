// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_playerr/functions/dbfunctions.dart';
import 'package:music_playerr/models/recentplayed.dart';
import '../../widget/songwidget.dart';

class RecentPageView extends StatefulWidget {
  const RecentPageView({super.key});
  

  @override
  State<RecentPageView> createState() => _RecentPageViewState();
}

final player = AssetsAudioPlayer.withId('0');

class _RecentPageViewState extends State<RecentPageView> {
  var orientation, size, height, width;
  final List<RecentlyPlayedModel> recentsongs = [];
  final box = RecentlyPlayedBox.getInstance();
  late List<RecentlyPlayedModel> recent = box.values.toList();
  List<Audio> recsongs = [];

  @override
  void initState() {
    final List<RecentlyPlayedModel> recentsong =
        box.values.toList().reversed.toList();
    for (var i in recentsong) {
      recsongs.add(Audio.file(i.songurl.toString(),
          metas: Metas(
            artist: i.artist,
            title: i.songname,
            id: i.id.toString(),
          )));
    }
    setState(() {
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Recently Played",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.search,
        //       color: Colors.black,
        //     ),
        //   ),
        // ],
      ),
      body: ValueListenableBuilder(
        valueListenable: RecentlyPlayedbox.listenable(),
        builder: ((context, dbrecent, child) {
          List<RecentlyPlayedModel> recentsongs =
              dbrecent.values.toList().reversed.toList();

          return ListView.builder(
              itemCount: recentsongs.length,
              itemBuilder: (context, index) => 
              songtile(
                song: recentsongs[index].songname!,
                image: recentsongs[index].id!,
                time: recentsongs[index].duration!,
                audioplayer: player,
                index: index,
                artist: recentsongs[index].artist!,
                context: context,
                recent: recsongs,
              ),
              );
        }),
      ),
    );
  }
}
