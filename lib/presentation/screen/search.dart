import 'dart:core';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_playerr/models/songsmodel..dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'now_playing.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
final TextEditingController searchcontroller = TextEditingController();

class _SearchPageState extends State<SearchPage> {
  late List<Songs> dbsongs = [];
  List<Audio> allsongs = [];
  late List<Songs> searchlist = List.from(dbsongs);
  bool istaped = true;

  final box = SongBox.getInstance();

  @override
  void initState() {
    dbsongs = box.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: TextFormField(
              autofocus: true,
              controller: searchcontroller,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'search',
                fillColor: const Color.fromARGB(255, 0, 0, 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0), width: 5),
                ),
              ),
              onChanged: (value) {
                updateSearch(value);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: searchlist.length,
          itemBuilder: ((context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 5),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => NowPlayingPage(),
                      ),
                    );
                    player.open(
                      Audio.file(searchlist[index].songurl!,
                          metas: Metas(
                              title: searchlist[index].songname,
                              artist: searchlist[index].artist,
                              id: searchlist[index].id.toString())),
                      showNotification: true,
                    );
                  },
                  leading: QueryArtworkWidget(
                    keepOldArtwork: true,
                    artworkBorder: BorderRadius.circular(13),
                    id: searchlist[index].id!,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset(
                        'assets/images/playlist2.jpg',
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.14,
                      ),
                    ),
                  ),
                  title: Text(searchlist[index].songname!,
                      style: const TextStyle(color: Colors.black)),
                ),
              )),
        ),
      ),
    );
  }

  updateSearch(String value) {
    setState(() {
      searchlist = dbsongs
          .where((element) =>
              element.songname!.toLowerCase().contains(value.toLowerCase()))
          .toList();

      allsongs.clear();
      for (var item in searchlist) {
        allsongs.add(Audio.file(item.songurl.toString(),
            metas: Metas(title: item.songname, id: item.id.toString())));
      }
    });
  }

  Widget searchTextField({required BuildContext context}) {
    return TextFormField(
      autofocus: true,
      controller: searchcontroller,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(234, 236, 238, 2),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50)),
        hintText: 'search',
      ),
      onChanged: (value) {},
    );
  }
}
