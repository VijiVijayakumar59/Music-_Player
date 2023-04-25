import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_playerr/models/favouriteModel.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../screen/favourites/addtofav.dart';
import '../screen/now_playing.dart';

class FavWidget extends StatefulWidget {
  const FavWidget({
    super.key,
  });

  @override
  State<FavWidget> createState() => _FavWidgetState();
}

final player = AssetsAudioPlayer.withId('0');

class _FavWidgetState extends State<FavWidget> {
  final List<Favourites> likedsongs = [];
  final box = FavouriteBox.getInstance();
  late List<Favourites> liked = box.values.toList();
  List<Audio> favsong = [];

  @override
  void initState() {
    final List<Favourites> likedsongs = box.values.toList().reversed.toList();
    for (var i in likedsongs) {
      favsong.add(
        Audio.file(
          i.songurl.toString(),
          metas: Metas(
            artist: i.artist,
            title: i.songname,
            id: i.id.toString(),
          ),
        ),
      );
    }

    setState(() {
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder<Box<Favourites>>(
            valueListenable: box.listenable(),
            builder: (context, Box<Favourites> dbfavour, child) {
              List<Favourites> likedsongs =
                  dbfavour.values.toList().reversed.toList();
              log(likedsongs.toString());

              return Container(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 0),
                height: MediaQuery.of(context).size.height * 0.7,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            player.open(
                                Playlist(audios: favsong, startIndex: index),
                                showNotification: true,
                                headPhoneStrategy:
                                    HeadPhoneStrategy.pauseOnUnplug,
                                loopMode: LoopMode.playlist);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => NowPlayingPage()),
                              ),
                            );
                          },
                          child: QueryArtworkWidget(
                            keepOldArtwork: true,
                            artworkBorder: BorderRadius.circular(10),
                            id: likedsongs[index].id!,
                            artworkWidth:
                                MediaQuery.of(context).size.width * 0.37,
                            artworkHeight:
                                MediaQuery.of(context).size.height * 0.15,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/playlist2.jpg',
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.37,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.28,
                              child: Text(
                                likedsongs[index].songname!,
                                style: const TextStyle(
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (!checkfavour(index, BuildContext)) {
                                    removefavour(index);
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                ))
                          ],
                        )
                      ],
                    );
                  },
                  itemCount: likedsongs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
