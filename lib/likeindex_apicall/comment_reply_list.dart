import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../audioManager.dart';

class PagemanagerCommentReply extends StatefulWidget {
  String url;

   PagemanagerCommentReply({Key? key,required this.url}) : super(key: key);

  @override
  State<PagemanagerCommentReply> createState() => _PagemanagerCommentReplyState();
}

class _PagemanagerCommentReplyState extends State<PagemanagerCommentReply> {
  late final PageManager _pageManager;
  bool checked=false;


  @override
  void initState() {
    _pageManager = PageManager(audioUrl: "${widget.url}");

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 33, top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder<ButtonState>(
            valueListenable: _pageManager.buttonNotifier,
            builder: (_, value, __) {
              switch (value) {
                case ButtonState.loading:
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 32.0,
                    height: 32.0,
                    child: const CircularProgressIndicator(),
                  );
                case ButtonState.paused:
                  return IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    iconSize: 32.0,
                    onPressed: _pageManager.play,
                  );
                case ButtonState.playing:
                  return IconButton(
                    icon: const Icon(
                      Icons.pause,
                      color: Colors.white,
                    ),
                    iconSize: 32.0,
                    onPressed: _pageManager.pause,
                  );
              }
            },
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 160,
            height: 20,
            child: ValueListenableBuilder<ProgressBarState>(
              valueListenable: _pageManager.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: _pageManager.seek,
                );
              },
            ),
          ),
          SizedBox(width: 10,),
          //  GestureDetector(
          //    onTap: () {
          //      setState(() {
          //         checked==true?
          //                  widget.likes+=1:
          //                widget.likes-=1;
          //      });
          //
          //
          //    },
          //    child: Icon(
          //                   Icons.favorite,
          //                   color: checked==true
          //                       ? Colors.redAccent
          //                       : Colors.white,
          //                   size: 28,
          //                 ),
          //  ),
          //
          // SizedBox(
          //   width: size.width / 85,
          // ),
          // Text(
          //  widget.likes.toString(),
          //   style: TextStyle(
          //       fontSize: 11,
          //       fontWeight: FontWeight.w400,
          //       color: Colors.grey),
          // )
        ],
      ),
    );
  }
}
