// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_playerr/models/mostplayed.dart';
import 'package:music_playerr/models/songsmodel..dart';
import 'package:music_playerr/presentation/screen/home_screen.dart';

import 'package:on_audio_query/on_audio_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final OnAudioQuery audioquery = OnAudioQuery();
final box = SongBox.getInstance();
final mostbox = MostplayedBox.getInstance();
List<SongModel> fetchsongs = [];
List<SongModel> allsongs = [];

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    requestStoragePermission();

    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 1900), () {});

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/splash.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: Text(
              "TruBeat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> gotoHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => HomeScreen(),
      ),
    );
  }

  //request permission
  void requestStoragePermission() async {
    //only if platform is not web
    if (!kIsWeb) {
      //check if not permission status

      bool status = await audioquery.permissionsStatus();
      //request it if not given
      if (!status) {
        await audioquery.permissionsRequest();

        fetchsongs = await audioquery.querySongs();
        for (var element in fetchsongs) {
          if (element.fileExtension == 'mp3') {
            allsongs.add(element);
          }
        }

        for (var items in allsongs) {
          mostbox.add(MostPlayed(
              songname: items.title,
              songurl: items.uri!,
              duration: items.duration!,
              artist: items.artist!,
              count: 0,
              id: items.id));
        }

        for (var element in allsongs) {
          await box.add(Songs(
              songname: element.title,
              duration: element.duration,
              id: element.id,
              songurl: element.uri,
              artist: element.artist));
        }
      }
    }
  }
}
