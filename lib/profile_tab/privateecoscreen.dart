
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:socialapp/profile_tab/privateechopagemanager.dart';
import '../audioManager.dart';
import '../model/my_profile_model.dart';

import 'package:audioplayers/audioplayers.dart';

class PrivateEcoScreen extends StatefulWidget {
  const PrivateEcoScreen({Key? key}) : super(key: key);

  @override
  State<PrivateEcoScreen> createState() => _PrivateEcoScreenState();
}

class _PrivateEcoScreenState extends State<PrivateEcoScreen> {
  MyPrModel? myProfile;
  int? index;
  late PageManager _pageManager;
 // final audioplayers=AudioPlayer();
 // PlayerState playerState=PlayerState.paused;
  String idtoken="";
 // String u="http://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/intromusic.ogg";

 // List<bool> playing=List.generate(2000000, (index) => false);
  List<Private> privateEcho=[];
  String audio="";
  bool selected=false;



  Future getuserid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();
    print(userId);
    setState((){
      idtoken=userId;
    });
  }
  void initState() {

    getuserid().whenComplete(() async{
      await getprivateecho();

    });
      super.initState();

    // audioplayers.onPlayerStateChanged.listen(( event) {
    //   setState(() {
    // index==null?playing[index!]=event==PlayerState.stopped:    playing[index!]=event==PlayerState.playing;
    //   });
    // });

  }


  @override
  void dispose() {
     _pageManager.dispose();
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
          child: myProfile == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : GridView.builder(
            itemCount: privateEcho.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 3,
            ), itemBuilder:(BuildContext context, int index){
            _pageManager = PageManager(audioUrl:myProfile!.privateEcho[index].audio);
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: myProfile!.privateEcho[index].backgroundImage!=""?ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child:CachedNetworkImage (imageUrl:myProfile!.privateEcho[index].backgroundImage,
                    width: 125,height: 125,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => new Container(),
                    errorWidget: (context, url, error) => new Icon(Icons.person),),
                ):Container(),
              ),
              Positioned.fill(child: Align(
                alignment: Alignment.center,
                  child: Privateechoprivatemanager(url:myProfile!.privateEcho[index].audio ,))),
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
             }

          )


        ),
      ),
    );


  }
  String image="";
  Future getprivateecho()async{
     var data={
       "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
       "ID": "$idtoken"
     };
    var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/my_profile"),body:data );
    if(response.statusCode==200){
      print(data);
      print(response.body);
      myProfile=myPrModelFromJson(response.body);
      setState(() {
        for(int i=0;i<myProfile!.privateEcho.length;i++){
           audio=myProfile!.privateEcho[i].audio;
           image=myProfile!.privateEcho[i].backgroundImage;
           print("dfbschxbvnd,cnv $audio,$image");
          privateEcho.add(Private(audio: audio,backgroundImage: image,isPublic: false,isAnonymous: true));
        }
      });
    }
  }

}

