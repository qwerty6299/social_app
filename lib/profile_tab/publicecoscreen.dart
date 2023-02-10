import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/profile.dart';
import 'package:http/http.dart'as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:socialapp/profile_tab/privateechopagemanager.dart';
import '../audioManager.dart';
import '../model/publicechomodel.dart';

class PublicEcoScreen extends StatefulWidget {
  PublicEcoScreen({Key? key}) : super(key: key);

  @override
  State<PublicEcoScreen> createState() => _PublicEcoScreenState();
}

class _PublicEcoScreenState extends State<PublicEcoScreen> {
  int? index;
  PublicechoModel? publicechoModel;
  List<PrivatePhoto> publicEcho=[];
  final audioplayers=AudioPlayer();
  // PlayerState playerState=PlayerState.paused;
  String idtoken="";
  // String u="http://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/intromusic.ogg";

  //List<bool> playing=List.generate(2000000, (index) => false);
  late PageManager _pageManager;


  String audio="";
  String image="";
  Future getuserid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();
    print(userId);
    setState((){
      idtoken=userId;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserid().whenComplete(() async{
      await getpublicecho();
    });
  }
  @override
  void dispose() {
    _pageManager.dispose();

    super.dispose();
    // audioplayers.release();
    // audioplayers.dispose();
  }
Future getpublicecho()async {
  var data={
    "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
    "ID": "$idtoken"
  };
  var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/my_profile"),body:data );
  if(response.statusCode==200){
    print(data);
    print(response.body);
    publicechoModel=publicechoModelFromJson(response.body);
    setState(() {
      for(int i=0;i<publicechoModel!.publicEcho.length;i++){
        audio=publicechoModel!.publicEcho[i].audio;
        image=publicechoModel!.publicEcho[i].backgroundImage;
        print("dfb${publicechoModel!.publicEcho[i].audio}");
        publicEcho.add(PrivatePhoto(audio: audio, backgroundImage: image));
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      body: SingleChildScrollView(
        child: Container(
            child:publicechoModel == null
                ? Center(

              child: CircularProgressIndicator(),
            )
                :  GridView.builder(
                itemCount: publicEcho.length,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 3,
                ), itemBuilder:(BuildContext context, int index){
              _pageManager = PageManager(audioUrl:publicechoModel!.publicEcho[index].audio);
              return
                Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: publicechoModel!.publicEcho[index].backgroundImage!=""?ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:CachedNetworkImage (imageUrl:publicechoModel!.publicEcho[index].backgroundImage,
                        width: 125,height: 125,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(Icons.person),),
                    ):Container(),
                  ),
                  Positioned.fill(child:Align(   alignment: Alignment.center, child: Privateechoprivatemanager(url:publicechoModel!.publicEcho[index].audio,))),
                ],
              ) ;
            }

            )


        ),
      ),
    );
  }
}
