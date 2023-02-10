import 'package:flutter/material.dart';

import '../audioManager.dart';

class Privateechoprivatemanager extends StatefulWidget {
  final String url;



  const Privateechoprivatemanager({Key? key,required this.url}) : super(key: key);

  @override
  State<Privateechoprivatemanager> createState() => _PrivateechoprivatemanagerState();
}

class _PrivateechoprivatemanagerState extends State<Privateechoprivatemanager> {
  late final PageManager _pageManager;

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
    return Container(

      child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 20.0,
                      height: 32.0,
                      child: const CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.redAccent,
                      ),
                      iconSize: 32.0,
                      onPressed:_pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: const Icon(
                        Icons.pause,
                        color: Colors.redAccent,
                      ),
                      iconSize: 32.0,
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
