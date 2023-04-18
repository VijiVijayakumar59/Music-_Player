import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../functions/dbfunctions.dart';
import '../../models/mostplayed.dart';
import '../../models/recentplayed.dart';
import '../../models/songsmodel..dart';
import '../screen/now_playing.dart';
import '../screen/songs.dart';

listtile({
  RecentlyPlayedModel? recent,
  required List<MostPlayed> mostsong,
  required Songs songs,
  required int image,
  required String song,
  required String artist,
  required int index,
  required bool isadded,
  required List<Audio> assetAudio,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: InkWell(
      onTap: () {
        player.open(
            Playlist(
              audios: assetAudio,
              startIndex: index,
            ),
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
            showNotification: true);
        recent = RecentlyPlayedModel(
          id: songs.id,
          index: index,
          artist: songs.artist,
          songname: songs.songname,
          songurl: songs.songurl,
          duration: songs.duration,
        );
        log('i am list tile inkewell');
        addRecently(recent!);
        addMostplayed(index, mostsong[index]);
        NowPlayingPage.nowplayingindex.value = index;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NowPlayingPage(),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QueryArtworkWidget(
            quality: 100,
            artworkWidth: MediaQuery.of(context).size.width * 0.17,
            artworkHeight: MediaQuery.of(context).size.height * 0.08,
            keepOldArtwork: true,
            artworkBorder: BorderRadius.circular(10),
            id: image,
            nullArtworkWidget: ClipRRect(
              child: Image.asset(
                'assets/images/playlist2.jpg',
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.17,
              ),
            ),
            type: ArtworkType.AUDIO,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  song,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  artist,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.001,
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_filled),
            onPressed: () {},
            color: Colors.orange,
          ),
          IconButton(
            onPressed: () {
              showOptions(context, index);
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
