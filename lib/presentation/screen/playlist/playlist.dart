import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_playerr/models/playlist.dart';
import 'package:music_playerr/presentation/screen/songs.dart';
import 'package:music_playerr/presentation/widget/text_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../functions/addplaylist.dart';
import 'current_playlist.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({super.key});

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  final playlistbox = PlaylistSongsbox.getInstance();
  late List<PlaylistSongs> playlistsongs = playlistbox.values.toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
                commontext: " Playlist",
                selectcolor: Colors.black,
                textSize: 20,
                textweight: FontWeight.bold),
            SizedBox(height: MediaQuery.of(context).size.height * 0.009),
            ListTile(
              leading: FloatingActionButton(
                child: Icon(
                  Icons.playlist_add_circle_outlined,
                  size: 40,
                  //color: Colors.orange,
                ),
                backgroundColor: Colors.orange.shade200,
                onPressed: () {
                  showPlaylistOptionsadd(context);
                },
              ),
              title: const TextWidget(
                  commontext: "Add New Playlist",
                  selectcolor: Colors.black,
                  textSize: 18,
                  textweight: FontWeight.w500),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Expanded(
              child: ValueListenableBuilder<Box<PlaylistSongs>>(
                valueListenable: playlistbox.listenable(),
                builder: (context, Box<PlaylistSongs> playlistsongs, child) {
                  List<PlaylistSongs> playlistsong =
                      playlistsongs.values.toList();

                  return playlistsong.isNotEmpty
                      ? GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: List.generate(
                            playlistsong.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: SizedBox(
                                height: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    CurrentPlaylist(
                                                      index: index,
                                                      playlistname:
                                                          playlistsong[index]
                                                              .playlistname,
                                                    ))));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: playlistsong[index]
                                                .playlistssongs!
                                                .isNotEmpty
                                            ? QueryArtworkWidget(
                                                id: playlistsong[index]
                                                    .playlistssongs![0]
                                                    .id!,
                                                type: ArtworkType.AUDIO,
                                                keepOldArtwork: true,
                                                artworkHeight: 80,
                                                artworkWidth: 130,
                                                nullArtworkWidget: Image.asset(
                                                  "assets/images/playlist2.jpg",
                                                  height: 80,
                                                  width: 130,
                                                ),
                                                artworkBorder:
                                                    BorderRadius.circular(8),
                                              )
                                            // ? Image.asset(
                                            //     'assets/images/playlist2.png',
                                            //     height: 130,
                                            //     width: 130,
                                            //   )
                                            : Image.asset(
                                                "assets/images/playlist2.jpg",
                                                height: 80,
                                                width: 130,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            playlistsong[index].playlistname!,
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<int>(
                                          itemBuilder: (context) => [
                                            // PopupMenuItem 1
                                            PopupMenuItem(
                                              onTap: () {
                                                deleteplaylist(index);
                                              },
                                              value: 1,
                                              // row with 2 children
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.delete),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Delete")
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text('Playlist is empty'),
                        );

                  // return const ListTile(
                  //   leading: SizedBox(
                  //     height: 50,
                  //     width: 50,
                  //     child: Image(
                  //       image: NetworkImage(
                  //           "https://ik.imagekit.io/gdgtme/wp-content/uploads/2022/02/How-To-Create-A-Music-Playlist-For-Offline-Listening-In-2022.jpg"),
                  //       fit: BoxFit.fill,
                  //     ),
                  //   ),
                  //   title: TextWidget(
                  //       commontext: "Melodies",
                  //       selectcolor: Colors.black,
                  //       textSize: 18,
                  //       textweight: FontWeight.bold),
                  //   subtitle: TextWidget(
                  //       commontext: "5 Songs",
                  //       selectcolor: Colors.grey,
                  //       textSize: 16,
                  //       textweight: FontWeight.normal),
                  //   trailing: Icon(
                  //     Icons.more_vert,
                  //     color: Colors.black,
                  //   );
                  // );
                  // const ListTile(
                  //   leading: SizedBox(
                  //     height: 50,
                  //     width: 50,
                  //     child: Image(
                  //       image: NetworkImage(
                  //           "https://www.switchingtomac.com/wp-content/uploads/2021/11/apple-music.jpeg"),
                  //       fit: BoxFit.fill,
                  //     ),
                  //   ),
                  //   title: TextWidget(
                  //       commontext: "Legends",
                  //       selectcolor: Colors.black,
                  //       textSize: 18,
                  //       textweight: FontWeight.bold),
                  //   subtitle: TextWidget(
                  //       commontext: "6 Songs",
                  //       selectcolor: Colors.grey,
                  //       textSize: 16,
                  //       textweight: FontWeight.normal),
                  //   trailing: Icon(
                  //     Icons.more_vert,
                  //     color: Colors.black,
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
