import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../audioManager.dart';
import '../model/fetch_profile_response.dart';
import 'package:http/http.dart' as http;

import '../model/public_echo_model.dart';
import '../profile_tab/privateechopagemanager.dart';

class FetchEcoScreen extends StatefulWidget {
  String token;
   FetchEcoScreen({Key? key,required this.token}) : super(key: key);

  @override
  State<FetchEcoScreen> createState() => _FetchEcoScreenState();
}

class _FetchEcoScreenState extends State<FetchEcoScreen> {
  FetchProfilePublicEchoModel? fetchProfilePublicEchoModel;
  int pageindex=0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
     // print("the tohmm nitt is ${widget.token}");
      getpublicecho(token: "${widget.token}");
    });

  }
  @override
  void dispose() {

    super.dispose();
    // audioplayers.release();
    // audioplayers.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      body: SingleChildScrollView(

        child: Container(
      child: fetchProfilePublicEchoModel==null?Center(
        child: CircularProgressIndicator(),
      ):GridView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: publicEcho.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 3,
      ), itemBuilder: (BuildContext context, int index){
      //  _pageManager = PageManager(audioUrl:fetchProfilePublicEchoModel!.publicEcho[index].audio);
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: fetchProfilePublicEchoModel!.publicEcho[index].backgroundImage!=""?ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child:CachedNetworkImage (imageUrl:fetchProfilePublicEchoModel!.publicEcho[index].backgroundImage,
                  width: 125,height: 125,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => new Container(),
                  errorWidget: (context, url, error) => new Icon(Icons.person),),
              ):Container(),
            ),
            Privateechoprivatemanager(url:fetchProfilePublicEchoModel!.publicEcho[index].audio,),
            // Align(
            //     alignment: Alignment.center,
            //     child: ValueListenableBuilder<ButtonState>(
            //       valueListenable: _pageManager.buttonNotifier,
            //
            //       builder: (_, value, __) {
            //
            //     switch (value) {
            //       case ButtonState.paused:
            //         return IconButton(
            //             icon: const Icon(
            //               Icons.play_arrow,
            //               color: Colors.redAccent,
            //             ),
            //             iconSize: 32.0,
            //             onPressed:
            //             _pageManager.play
            //
            //
            //         );
            //       case ButtonState.playing:
            //        return IconButton(
            //             icon: const Icon(
            //               Icons.pause,
            //               color: Colors.redAccent,
            //             ),
            //             iconSize: 32.0,
            //             onPressed:
            //             _pageManager.pause
            //
            //
            //         );
            //
            //     }
            //     return Text('');
            //
            //         // switch (value) {
            //         //   case ButtonState.loading:
            //         //     return Container(
            //         //       margin: const EdgeInsets.all(8.0),
            //         //       width: 32.0,
            //         //       height: 32.0,
            //         //       child: const CircularProgressIndicator(
            //         //         color: Colors.redAccent,
            //         //       ),
            //         //     );
            //         //   case ButtonState.paused:
            //         //     return IconButton(
            //         //       icon: const Icon(
            //         //         Icons.play_arrow,
            //         //         color: Colors.redAccent,
            //         //       ),
            //         //       iconSize: 32.0,
            //         //       onPressed:_pageManager.play,
            //         //     );
            //         //   case ButtonState.playing:
            //         //     return IconButton(
            //         //       icon: const Icon(
            //         //         Icons.pause,
            //         //         color: Colors.redAccent,
            //         //       ),
            //         //       iconSize: 32.0,
            //         //       onPressed: _pageManager.pause,
            //         //     );
            //         // }
            //       },
            //     )),
          ],
        ) ;
      }),
        ),
      ),
    );
  }
  String audio="";
  String bg="";
  List<PublicEcho> publicEcho=[];
  Future<FetchProfilePublicEchoModel?> getpublicecho({required String token}) async {

    // print(userId);

    try {
      print("trying to Profile");

      var url = Uri.parse('http://3.227.35.5:3001/api/user/my_profile');

      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Cookie':
            'connect.sid=s%3AtVnLmITSn_zletRj2nMA2yCjWafW69aY.vufwo%2Fh45zhYEp06x9RKcV0mhk2DkYDZ1twbPiJRp5Y'
          },
          body: json
              .encode({"APP_KEY": "SpTka6TdghfvhdwrTsXl28P1", "ID": "$token"}));
      print(response.statusCode);
      print("the bnjkkjhgf is    ${response.body}");

      if (response.statusCode == 200) {
        print("my body is $response");
        fetchProfilePublicEchoModel=fetchProfilePublicEchoModelFromJson(response.body);
        setState(() {
          for(int i=0;i<fetchProfilePublicEchoModel!.publicEcho.length;i++){
            audio=fetchProfilePublicEchoModel!.publicEcho[i].audio.toString();
            bg=fetchProfilePublicEchoModel!.publicEcho[i].backgroundImage.toString();

          publicEcho.add(PublicEcho(audio: audio,backgroundImage: bg));

          }
        });

      }
    } catch (e) {
      log(e.toString());
    }
  }
}
