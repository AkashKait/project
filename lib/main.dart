import 'dart:ui';

import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_music_player/songWidget.dart';
import 'package:flutter_music_player/widget.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupAudio();
  }

  void setupAudio() {
    audioManagerInstance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.start:
          _slider = 0;
          break;
        case AudioManagerEvents.seekComplete:
          _slider = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          setState(() {});
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = audioManagerInstance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _slider = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          audioManagerInstance.updateLrc(args["position"].toString());
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          audioManagerInstance.next();
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //drawer: Drawer(),
        appBar: AppBar(
          actions: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  showVol = !showVol;
                });
              },
              child: IconText(
                textColor: Colors.white,
                iconColor: Colors.white,
                string: "",
                iconSize: 30,
                iconData: Icons.volume_up,
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.black,
          title: showVol
              ? Container(
                  height: 50,
                  child: Slider(
                    activeColor: Colors.pink,
                    inactiveColor: Colors.grey[200],
                    value: audioManagerInstance.volume ?? 0,
                    onChanged: (value) {
                      setState(() {
                        audioManagerInstance.setVolume(value, showVolume: true);
                      });
                      Text("volume");
                    },
                  ),
                )
              : Row(
                children: [
                  Image.asset(
                      'assets/images/logo.png',
            height: 50,
            width: 50,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Hertz",
                      style: TextStyle(color: Colors.pink),
                    ),
                  )
                ],
              ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 15,
              child: Container(
                color: Colors.grey[900],
                child: FutureBuilder(
                  future: FlutterAudioQuery()
                      .getSongs(sortType: SongSortType.DEFAULT),
                  builder: (context, snapshot) {
                    List<SongInfo> songInfo = snapshot.data;
                    if (snapshot.hasData) return SongWidget(songList: songInfo);
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Loading....",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(flex: 3, child: bottomPanel()),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  Widget songProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          Text(
            _formatDuration(audioManagerInstance.position),
            style: TextStyle(color :Colors.white,backgroundColor: Colors.black,),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric( horizontal: 0),
              child: Stack(
                children: [
                  /*   Text(song.title,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700)),  */
                  Container(
                    color : Colors.black45,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbColor: Colors.pinkAccent,
                        overlayColor: Colors.pink,
                        thumbShape: RoundSliderThumbShape(
                          disabledThumbRadius: 5,
                          enabledThumbRadius: 5,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 10,
                        ),
                        activeTrackColor: Colors.pinkAccent,
                        inactiveTrackColor: Colors.grey,
                      ),
                      child: Slider(
                        value: _slider ?? 0,
                        onChanged: (value) {
                          setState(() {
                            _slider = value;
                          });
                        },
                        onChangeEnd: (value) {
                          if (audioManagerInstance.duration != null) {
                            Duration msec = Duration(
                                milliseconds:
                                    (audioManagerInstance.duration.inMilliseconds *
                                            value)
                                        .round());
                            audioManagerInstance.seekTo(msec);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(

            _formatDuration(audioManagerInstance.duration),
            style: TextStyle(color: Colors.white,backgroundColor: Colors.black,),
          ),
        ],
      ),
    );
  }

  Widget bottomPanel() {
    return Container(
      color: Colors.black,
      //height: 800,
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          //child: songProgress(context),
        ),
        Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                child: Center(
                  child: IconButton(
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.grey[100],
                      ),
                      onPressed: () => audioManagerInstance.previous()),
                ),
                backgroundColor: Colors.pinkAccent.withOpacity(0.3),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.pink,
                child: Center(
                  child: IconButton(
                    onPressed: () async {
                      audioManagerInstance.playOrPause();
                    },
                    padding: const EdgeInsets.all(0.0),
                    icon: Icon(
                      audioManagerInstance.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.pink[50],
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.pinkAccent.withOpacity(0.3),
                child: Center(
                  child: IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: Colors.grey[100],
                      ),
                      onPressed: () => audioManagerInstance.next()),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

var audioManagerInstance = AudioManager.instance;
bool showVol = false;
PlayMode playMode = audioManagerInstance.playMode;
bool isPlaying = false;
double _slider;
