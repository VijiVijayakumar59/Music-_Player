// ignore_for_file: void_checks
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_playerr/models/songsmodel..dart';
import 'package:music_playerr/presentation/screen/search.dart';
import 'package:music_playerr/presentation/screen/now_playing.dart';
import 'package:music_playerr/presentation/screen/playlist/playlist.dart';
import 'package:music_playerr/presentation/screen/songs.dart';
import 'package:music_playerr/presentation/screen/suggested.dart';
import 'package:music_playerr/presentation/widget/favourite_widget.dart';
import 'package:music_playerr/presentation/widget/popup.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
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
              SettingsOption(icon: Icons.key, title: 'Privacy Policy'),
              SettingsOption(
                  icon: Icons.receipt_long_outlined,
                  title: 'Terms and Conditions'),
              SettingsOption(icon: Icons.contact_mail, title: 'Contact Us'),
              SettingsOption(icon: Icons.share, title: 'Share App'),
              SettingsOption(icon: Icons.exit_to_app, title: 'Exit'),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(
                Icons.music_note_sharp,
                size: 32,
                color: Colors.orange,
              ),
              Text(
                "TruBeat",
                // style:
                //     TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                style: GoogleFonts.dancingScript(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
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
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.orange,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: "Songs",
              ),
              Tab(
                text: "Suggested",
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
          const SongList(),
          SuggestedPage(),
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
                          height: MediaQuery.of(context).size.height * 0.08,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
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
}

// ignore: must_be_immutable
class SettingsOption extends StatelessWidget {
  String title;
  IconData icon;
  SettingsOption({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20),
      child: GestureDetector(
        onTap: () {
          if (title == 'Privacy Policy') {
            showDialog(
              context: context,
              builder: (context) {
                return settingmenupopup(mdFilename: 'privacypolicy.md');
              },
            );
          } else if (title == 'Terms and Conditions') {
            showDialog(
              context: context,
              builder: (context) {
                return settingmenupopup(mdFilename: 'termsandconditions.md');
              },
            );
          } else if (title == 'Exit') {
            return exit(context);
          }
        },
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
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

// alert box for exit application
void exit(context) {
  //alert dialog
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'CONFIRM',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(letterSpacing: .5, fontSize: 20),
            ),
          ),
          content: Text(
            'Are You Sure To Exit',
            style: GoogleFonts.comfortaa(
              textStyle: const TextStyle(
                  letterSpacing: .5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'NO',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      });
}
