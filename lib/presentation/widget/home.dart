import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_playerr/functions/dbfunctions.dart';
import 'package:music_playerr/models/recentplayed.dart';
import 'package:music_playerr/presentation/screen/recentlyplayed/recent_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
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
                height: MediaQuery.of(context).size.height * 0.05,
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
                    //height: 200,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: recentsongs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            NowPlayingPage.nowplayingindex.value = index;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const RecentPageView(),
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
                                id: recentsongs[index].id!,
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
                                // width: 130,
                                // height: 20,
                                height:
                                    MediaQuery.of(context).size.height * 0.027,
                                width: MediaQuery.of(context).size.width * 0.38,
                                child: Text(
                                  recentsongs[index].songname!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Text(
                                recentsongs[index].artist!,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w100),
                              ),
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

