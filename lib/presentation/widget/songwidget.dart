import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_playerr/presentation/screen/now_playing.dart';
import 'package:music_playerr/presentation/screen/songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

songtile({
  required String song,
  required int image,
  required int time,
  required AssetsAudioPlayer audioplayer,
  required int index,
  required String artist,
  required BuildContext context,
  required List<Audio> recent,
}) {
  const EdgeInsets.all(6.0);
  return InkWell(
    onTap: () {
      player.open(Playlist(audios: recent, startIndex: index),
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
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/playlist2.jpg',
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.17,
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
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
              width: MediaQuery.of(context).size.width * 0.3,
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
          width: MediaQuery.of(context).size.width * 0.002,
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
