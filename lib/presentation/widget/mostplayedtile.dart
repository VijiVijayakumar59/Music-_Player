import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../screen/now_playing.dart';
import '../screen/songs.dart';

songtileMost({
  required String song,
  required int image,
  required int time,
  required AssetsAudioPlayer audioplayer,
  required int index,
  required String artist,
  required List<Audio> mostsongs,
  required BuildContext context,
}) {
  const EdgeInsets.all(6.0);
  return InkWell(
    onTap: () {
      audioplayer.open(Playlist(audios: mostsongs, startIndex: index),
          showNotification: true,
          headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
          loopMode: LoopMode.playlist);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => NowPlayingPage(),
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
          type: ArtworkType.AUDIO,
          nullArtworkWidget: ClipRRect(
            child: Image.asset(
              'assets/images/playlist2.jpg',
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.17,
            ),
          ),
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
            )
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.001,
        ),
        IconButton(
          icon: const Icon(Icons.play_circle_filled),
          onPressed: () {
            // NowPlayingPage.nowplayingindex.value = value;
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (ctx) => NowPlayingPage(),
            //   ),
            // );
          },
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
  );
}
