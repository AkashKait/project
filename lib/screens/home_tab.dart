import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

import '../songWidget.dart';
import '../widget.dart';

class HomeTab extends StatefulWidget {
  static final String id = "home_tab";
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
          backgroundColor: Colors.grey[900],
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                      child: Image.asset(
                        'assets/images/logo1.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Hertz",
                        style: TextStyle(color: Colors.pink[100]),
                      ),
                    ),
                  ],
                ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 20,
              child: Container(
                color: Colors.grey[600],
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
            Expanded(flex: 4, child: bottomPanel()),
          ],
        ),
      ),
    );
  }
}

Widget bottomPanel() {
  return Container(
    color: Colors.black,
    child: Column(children: <Widget>[
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 16),
      //   child: songProgress(context),
      // ),
      Expanded(
        flex: 3,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[500].withOpacity(1),

          ),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                child: Center(
                  child: IconButton(
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        color: Colors.grey[100],
                      ),
                      onPressed: () => audioManagerInstance.previous()),
                ),
                backgroundColor: Colors.pinkAccent.withOpacity(0.3),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.pink[300],
                child: Center(
                  child: IconButton(
                    onPressed: () async {
                      audioManagerInstance.playOrPause();
                    },
                    padding: const EdgeInsets.all(0.0),
                    icon: Icon(
                      audioManagerInstance.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow_rounded,
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
                        Icons.skip_next_rounded,
                        color: Colors.grey[100],
                      ),
                      onPressed: () => audioManagerInstance.next()),
                ),
              ),
            ],
          ),
        ),
      ),
    ]),
  );
}

var audioManagerInstance = AudioManager.instance;
bool showVol = false;
PlayMode playMode = audioManagerInstance.playMode;
bool isPlaying = false;
double _slider;
