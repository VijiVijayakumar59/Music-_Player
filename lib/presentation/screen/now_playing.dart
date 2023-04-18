// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names, must_be_immutable

import 'dart:developer';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_playerr/models/songsmodel..dart';
import 'package:music_playerr/presentation/screen/favourites/addtofav.dart';
import 'package:music_playerr/presentation/screen/songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlayingPage extends StatefulWidget {
  NowPlayingPage({super.key});

  List<Songs>? songs;
  static int? indexvalue = 0;
  static ValueNotifier<int> nowplayingindex = ValueNotifier<int>(indexvalue!);

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

final player = AssetsAudioPlayer.withId("0");

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  final box = SongBox.getInstance();

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration.zero;
    Duration position = Duration.zero;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: NowPlayingPage.nowplayingindex,
          builder: (BuildContext context, int value1, child) {
            return ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: ((context, Box<Songs> allsongbox, child) {
                return player.builderCurrent(
                  builder: (context, playing) {
                    return Column(
                      children: [
                        Center(
                          child: QueryArtworkWidget(
                            quality: 100,
                            artworkWidth:
                                MediaQuery.of(context).size.width * 0.80,
                            artworkHeight:
                                MediaQuery.of(context).size.height * 0.40,
                            keepOldArtwork: true,
                            artworkBorder: BorderRadius.circular(30),
                            id: int.parse(playing.audio.audio.metas.id!),
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                              child: Image.asset(
                                'assets/images/playlist2.jpg',
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                                width: MediaQuery.of(context).size.width * 0.80,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          //   allDbsongs[value1].songname!,
                          player.getCurrentAudioTitle,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          // allDbsongs[value1].artist!,
                          player.getCurrentAudioArtist,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Column(
                          children: [
                            PlayerBuilder.realtimePlayingInfos(
                              player: player,
                              builder: (context, RealtimePlayingInfos) {
                                duration = RealtimePlayingInfos
                                    .current!.audio.duration;
                                position = RealtimePlayingInfos.currentPosition;

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ProgressBar(
                                    baseBarColor:
                                        const Color.fromARGB(255, 227, 149, 107)
                                            .withOpacity(0.5),
                                    progressBarColor:
                                        const Color.fromARGB(255, 243, 126, 59),
                                    thumbColor:
                                        const Color.fromARGB(255, 253, 108, 46),
                                    thumbRadius: 6,
                                    timeLabelPadding: 5,
                                    progress: position,
                                    timeLabelTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 235, 126, 42),
                                    ),
                                    total: duration,
                                    onSeek: (duration) async {
                                      await player.seek(duration);
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            PlayerBuilder.isPlaying(
                              player: player,
                              builder: ((context, isPlaying) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          // previousSong(
                                          //     Player, value1, allDbsongs);
                                          await player.previous();
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.skip_previous,
                                          size: 35,
                                          color: Colors.black,
                                        ),
                                      ),
                                      InkWell(
                                        child: const Icon(Icons.replay_10),
                                        onTap: () {
                                          player.seekBy(
                                              const Duration(seconds: -10));
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (isPlaying) {
                                            await player.pause();
                                          } else {
                                            await player.play();
                                            //playbutton(player,
                                            //  value, allDbdongs);
                                          }

                                          setState(
                                            () {
                                              isPlaying = !isPlaying;
                                            },
                                          );
                                        },
                                        icon: (isPlaying)
                                            ? const Icon(Icons.pause)
                                            : const Icon(
                                                Icons.play_arrow,
                                                color: Colors.black,
                                                size: 40,
                                              ),
                                      ),
                                      InkWell(
                                        child: const Icon(Icons.forward_10),
                                        onTap: () {
                                          player.seekBy(
                                              const Duration(seconds: 10));
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          // skipMusic(Player, value1, allDbsongs);
                                          // setState(() {});
                                          await player.next();
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.skip_next,
                                          size: 35,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (checkfavour(value1, BuildContext)) {
                                        addfavour(value1);
                                      } else if (!checkfavour(
                                          value1, BuildContext)) {
                                        removefavour(value1);
                                      }
                                      setState(() {});
                                    },
                                    icon: (checkfavour(value1, BuildContext))
                                        ? const Icon(
                                            Icons.favorite_border_outlined,
                                            color: Colors.orange,
                                          )
                                        : const Icon(
                                            Icons.favorite,
                                            color: Colors.orange,
                                          )),
                                const Text('Add to Favourites'),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      log('songs added to playlist');
                                      showOptions(context, value1);
                                    },
                                    icon: const Icon(
                                      Icons.playlist_add,
                                      color: Colors.orange,
                                    )),
                                const Text("Add to Playlist")
                              ],
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
