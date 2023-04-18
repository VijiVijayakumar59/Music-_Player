import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_playerr/models/songsmodel..dart';
import 'package:music_playerr/presentation/screen/search.dart';
import 'package:music_playerr/presentation/screen/now_playing.dart';
import 'package:music_playerr/presentation/screen/playlist/playlist.dart';
import 'package:music_playerr/presentation/screen/songs.dart';
import 'package:music_playerr/presentation/screen/suggested.dart';
import 'package:music_playerr/presentation/widget/favourite_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  List<Songs>? songs;
  static int? indexvalue = 0;
  static ValueNotifier<int> nowplayingindex = ValueNotifier<int>(indexvalue!);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final _audioPlayer = AssetsAudioPlayer.withId('0');

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Audio> convertAudios = [];

  final box = SongBox.getInstance();

  @override
  void initState() {
    List<Songs> dbsongs = box.values.toList();
    for (var item in dbsongs) {
      convertAudios.add(Audio.file(item.songurl!,
          metas: Metas(
              title: item.songname,
              artist: item.artist,
              id: item.id.toString())));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              SettingsOption(
                  function: () {
                    log('hello privacy');
                  },
                  icon: Icons.key,
                  title: 'Privacy Policy'),
              SettingsOption(
                  function: () {},
                  icon: Icons.receipt_long_outlined,
                  title: 'Terms and Conditions'),
              SettingsOption(
                  function: () {},
                  icon: Icons.contact_mail,
                  title: 'Contact Us'),
              SettingsOption(
                  function: () {}, icon: Icons.share, title: 'Share App'),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Row(
            children: const [
              Icon(
                Icons.music_note,
                color: Colors.orange,
              ),
              Text(
                "TruBeat",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const SearchPage())));
              },
            )
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 16),
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: "Suggested",
              ),
              Tab(
                text: "Songs",
              ),
              Tab(
                text: "Favourites",
              ),
              Tab(
                text: "Playlists",
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          SuggestedPage(),
          const SongList(),
          const FavWidget(),
          const PlaylistView()
        ]),
        bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => NowPlayingPage()),
              ),
            );
          },
          child: ValueListenableBuilder(
            valueListenable: NowPlayingPage.nowplayingindex,
            builder: (BuildContext context, int value1, child) {
              return ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (BuildContext context, Box<Songs> allsongbox, child) {
                  List<Songs> allDbsongs = allsongbox.values.toList();
                  if (allDbsongs.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Expanded(
                    child: _audioPlayer.builderCurrent(
                      builder: (context, playing) {
                        return Container(
                          height: 70,
                          color: const Color.fromARGB(255, 250, 195, 128),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  child: QueryArtworkWidget(
                                    quality: 100,
                                    artworkWidth:
                                        MediaQuery.of(context).size.width *
                                            0.17,
                                    artworkHeight:
                                        MediaQuery.of(context).size.height *
                                            0.08,
                                    keepOldArtwork: true,
                                    artworkBorder: BorderRadius.circular(15),
                                    //id: allDbsongs[value1].id!,
                                    id: int.parse(
                                        playing.audio.audio.metas.id!),

                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: ClipRRect(
                                      child: Image.asset(
                                        'assets/images/playlist2.jpg',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.17,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        //allDbsongs[value1].songname!,
                                        _audioPlayer.getCurrentAudioTitle,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        _audioPlayer.getCurrentAudioArtist,
                                        //allDbsongs[value1].artist!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                PlayerBuilder.isPlaying(
                                  player: _audioPlayer,
                                  builder: ((context, isPlaying) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              // previousSong(_audioPlayer, value1,
                                              //     allDbsongs);
                                              await _audioPlayer.previous();
                                            },
                                            icon: const Icon(
                                              Icons.skip_previous,
                                              size: 25,
                                              color: Colors.black,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              if (isPlaying) {
                                                await _audioPlayer.pause();
                                              } else {
                                                await _audioPlayer.play();
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
                                                    size: 25,
                                                  ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await _audioPlayer.next();
                                            },
                                            icon: const Icon(
                                              Icons.skip_next,
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
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void skipMusic(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    // if (index == dbsongs.length) {
    //   for (var item in dbsongs) {
    //     alldbsongs.first;
    //   }
    // }
    _audioPlayer.open(Audio.file(dbsongs[index + 1].songurl!),
        showNotification: true);
    //await _audioPlayer.next();
    setState(() {
      NowPlayingPage.nowplayingindex.value++;
    });
    await _audioPlayer.stop();
  }

  void previousSong(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    _audioPlayer.open(Audio.file(dbsongs[index - 1].songurl!),
        showNotification: true);
    // await _audioPlayer.next();
    setState(() {
      NowPlayingPage.nowplayingindex.value--;
    });
    await _audioPlayer.stop();
  }
}

class SettingsOption extends StatelessWidget {
  String title;
  IconData icon;
  void function;
  SettingsOption({
    Key? key,
    required this.function,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20),
      child: GestureDetector(
        onTap: () {
          function;
        },
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
