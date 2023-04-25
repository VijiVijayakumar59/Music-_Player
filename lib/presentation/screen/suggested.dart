import 'package:flutter/material.dart';

import 'package:music_playerr/models/songsmodel..dart';

import 'package:music_playerr/presentation/widget/home.dart';

import '../widget/mostplayed_widget.dart';

class SuggestedPage extends StatelessWidget {
  SuggestedPage({super.key});
  final box = SongBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      body: ListView(
        children: [
          const RecentPage(),
          // Artist(
          //   name: 'art',
          //   title: "Artists",
          //   borderradius: 100,
          //   artistname: const [
          //     'Selena Gomez',
          //     'JungKook',
          //     'Ariana Grande',
          //   ],
          //   photos: [img1, img2, img3],
          // ),
          const MostPlayedWidget(),
        ],
      ),
    );
  }
}
