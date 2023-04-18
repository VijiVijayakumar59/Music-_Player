import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_playerr/models/mostplayed.dart';
import '../widget/mostplayedtile.dart';

class MostPlayedPage extends StatefulWidget {
  const MostPlayedPage({super.key});

  @override
  State<MostPlayedPage> createState() => _MostPlayedPageState();
}

class _MostPlayedPageState extends State<MostPlayedPage> {
  var orientation, size, height, width;
  final box = MostplayedBox.getInstance();
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  List<Audio> songs = [];

  @override
  void initState() {
    List<MostPlayed> mostsong = box.values.toList();
    int i = 0;
    for (var element in mostsong) {
      if (element.count > 3) {
        mostplayedsongs.insert(i, element);
        i++;
      }
    }
    for (var items in mostplayedsongs) {
      songs.add(
        Audio.file(
          items.songurl,
          metas: Metas(
            title: items.songname,
            artist: items.artist,
            id: items.id.toString(),
          ),
        ),
      );
    }

    super.initState();
  }

  List<MostPlayed> mostplayedsongs = [];

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
          "Most Played",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(children: [
        ValueListenableBuilder<Box<MostPlayed>>(
          valueListenable: box.listenable(),
          builder: ((context, value, child) {
            return mostplayedsongs.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: mostplayedsongs.length,
                      itemBuilder: (context, index) {
                        return songtileMost(
                          mostsongs: songs,
                          song: mostplayedsongs[index].songname,
                          image: mostplayedsongs[index].id,
                          time: mostplayedsongs[index].duration,
                          audioplayer: audioPlayer,
                          index: index,
                          artist: mostplayedsongs[index].artist,
                          context: context,
                        );
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text("your most played songs will appear here "),
                      ),
                    ],
                  );
          }),
        )
      ]),
    );
  }
}
