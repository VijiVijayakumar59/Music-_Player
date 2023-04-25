import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_playerr/models/mostplayed.dart';
import 'package:music_playerr/presentation/screen/most_played.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostPlayedWidget extends StatefulWidget {
  const MostPlayedWidget({super.key});

  @override
  State<MostPlayedWidget> createState() => _MostPlayedWidgetState();
}

final player = AssetsAudioPlayer.withId('0');

class _MostPlayedWidgetState extends State<MostPlayedWidget> {
  final box = MostplayedBox.getInstance();
  List<Audio> songs = [];
  @override
  void initState() {
    final List<MostPlayed> mostsong = box.values.toList();

    int i = 0;
    for (var element in mostsong) {
      if (element.count > 3) {
        mostplayedsongs.insert(i, element);
        i++;
      }
    }

    for (var i in mostsong) {
      songs.add(Audio.file(i.songurl.toString(),
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

  List<MostPlayed> mostplayedsongs = [];

  @override
  Widget build(BuildContext context) {
    return songs.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: ListTile(
                  title: const Text(
                    'Mostly Played',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  trailing: TextButton(
                    child: const Text(
                      "see all",
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const MostPlayedPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              ValueListenableBuilder<Box<MostPlayed>>(
                valueListenable: box.listenable(),
                builder: (context, value, child) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: mostplayedsongs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const MostPlayedPage(),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              QueryArtworkWidget(
                                quality: 100,
                                artworkWidth:
                                    MediaQuery.of(context).size.width * 0.40,
                                artworkHeight:
                                    MediaQuery.of(context).size.height * 0.15,
                                keepOldArtwork: true,
                                artworkBorder: BorderRadius.circular(10),
                                id: mostplayedsongs[index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/images/playlist2.jpg',
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.027,
                                width: MediaQuery.of(context).size.width * 0.38,
                                child: Text(
                                  mostplayedsongs[index].songname,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Text(
                                mostplayedsongs[index].artist,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w100),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
  }
}
