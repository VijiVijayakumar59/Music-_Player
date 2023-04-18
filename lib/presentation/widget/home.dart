import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_playerr/functions/dbfunctions.dart';
import 'package:music_playerr/models/recentplayed.dart';
import 'package:music_playerr/presentation/screen/recentlyplayed/recent_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../screen/most_played.dart';
import '../screen/now_playing.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({
    super.key,
  });

  @override
  State<RecentPage> createState() => _RecentPageState();
}

final player = AssetsAudioPlayer.withId('0');

class _RecentPageState extends State<RecentPage> {
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
    return recsongs.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              SizedBox(
                height: 30,
                child: ListTile(
                  title: const Text(
                    'Recently Played',
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
                          builder: (ctx) => const RecentPageView(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: RecentlyPlayedbox.listenable(),
                builder: (context, dbrecent, child) {
                  List<RecentlyPlayedModel> recentsongs =
                      dbrecent.values.toList().reversed.toList();

                  return Container(
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        width: 15,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: recentsongs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            NowPlayingPage.nowplayingindex.value = index;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>const RecentPageView(),
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
                                    MediaQuery.of(context).size.height * 0.20,
                                keepOldArtwork: true,
                                artworkBorder: BorderRadius.circular(10),
                                id: recentsongs[index].id!,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/images/playlist2.jpg',
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                height: 20,
                                child: Text(
                                  recentsongs[index].songname!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(recentsongs[index].artist!),
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

class Artist extends StatelessWidget {
  final String title;
  final double borderradius;
  final String name;

  final List<String> photos;
  final List<String> artistname;

  const Artist({
    super.key,
    required this.title,
    required this.borderradius,
    required this.photos,
    required this.artistname,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          height: 200,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              width: 10,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 136, 1, 1),
                      image: DecorationImage(
                        image: AssetImage(photos[index]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(borderradius),
                      ),
                    ),
                    height: 150,
                    width: 150,
                  ),
                  Text(
                    artistname[index],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
