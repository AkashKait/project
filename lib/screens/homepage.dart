import 'dart:ui';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_music_player/songWidget.dart';
import 'package:flutter_music_player/widget.dart';
import 'package:flutter/services.dart';

import 'equilizer_tab.dart';
import 'genre_tab.dart';
import 'home_tab.dart';

class Homepage extends StatefulWidget {
  static final String id = "homepage";
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  final tabs = [HomeTab(), EquilizerTab(), GenreTab()];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: tabs[_currentIndex],
      // backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_music),
            title: Text("Home"),
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer_rounded),
            title: Text("Equalizer"),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_rounded),
            title: Text("Genre"),
            backgroundColor: Colors.black,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

// String _formatDuration(Duration d) {
//   if (d == null) return "--:--";
//   int minute = d.inMinutes;
//   int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
//   String format = ((minute < 10) ? "0$minute" : "$minute") +
//       ":" +
//       ((second < 10) ? "0$second" : "$second");
//   return format;
// }

// Widget songProgress(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(0),
//     child: Row(
//       children: <Widget>[
//         Text(
//           _formatDuration(audioManagerInstance.position),
//           style: TextStyle(
//             color: Colors.white,
//             backgroundColor: Colors.black,
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 0),
//             child: Stack(
//               children: [
//                 /*   Text(song.title,
//                                       style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w700)),  */
//                 Container(
//                   color: Colors.black45,
//                   child: SliderTheme(
//                     data: SliderTheme.of(context).copyWith(
//                       trackHeight: 1,
//                       thumbColor: Colors.pinkAccent,
//                       overlayColor: Colors.pink,
//                       thumbShape: RoundSliderThumbShape(
//                         disabledThumbRadius: 5,
//                         enabledThumbRadius: 5,
//                       ),
//                       overlayShape: RoundSliderOverlayShape(
//                         overlayRadius: 10,
//                       ),
//                       activeTrackColor: Colors.pinkAccent,
//                       inactiveTrackColor: Colors.grey,
//                     ),
//                     child: Slider(
//                       value: _slider ?? 0,
//                       onChanged: (value) {
//                         setState(() {
//                           _slider = value;
//                         });
//                       },
//                       onChangeEnd: (value) {
//                         if (audioManagerInstance.duration != null) {
//                           Duration msec = Duration(
//                               milliseconds: (audioManagerInstance
//                                           .duration.inMilliseconds *
//                                       value)
//                                   .round());
//                           audioManagerInstance.seekTo(msec);
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Text(
//           _formatDuration(audioManagerInstance.duration),
//           style: TextStyle(
//             color: Colors.white,
//             backgroundColor: Colors.black,
//           ),
//         ),
//       ],
//     ),
//   );
// }

}
