import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/profile.dart';
import 'package:http/http.dart' as http;

import '../model/my_profile_model.dart';
import 'bigprivatephotoscreen.dart';
class PublicPhotoScreen extends StatefulWidget {
  PublicPhotoScreen({Key? key}) : super(key: key);

  @override
  State<PublicPhotoScreen> createState() => _PublicPhotoScreenState();
}

class _PublicPhotoScreenState extends State<PublicPhotoScreen> {
  List<Photo> publicphoto=[];
  String backfroundimage="";
  String idtoken="";
  @override
  void initState() {
    super.initState();
    getuserid().whenComplete(() async{
      await  getpublicPhoto();
    });

  }
  Future getuserid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();
    print(userId);
    setState((){
      idtoken=userId;
    });
  }

  MyPrModel? myProfile;
  Future getpublicPhoto() async {


    try {
      print("trying to Profile");

      var url = Uri.parse("http://3.227.35.5:3001/api/user/my_profile");
      var data={
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID": "$idtoken"
      };

      var response = await http.post(url,

          body: data);


      print("data $data");

      if (response.statusCode == 200) {
        myProfile=myPrModelFromJson(response.body);
        setState(() {
          for(int i=0;i<myProfile!.publicphoto.length;i++){
            backfroundimage=myProfile!.publicphoto[i].backgroundImage;

            publicphoto.add(Photo(backgroundImage: backfroundimage,

             ));
          }
        });

      }
    } catch (e) {
      log(e.toString());
    }
  }
  Future setphotoscreen(String img)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("privatephoto",img);


  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
  body: SingleChildScrollView(
        child: myProfile==null?Center(

          child: CircularProgressIndicator(),
        ): Container(
          child: GridView.builder(
            itemCount: publicphoto.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 3,
              ), itemBuilder:(BuildContext context, int index){
                return  GestureDetector(
                  onTap: (){
                    setphotoscreen("${ myProfile!.publicphoto[index].backgroundImage}");
                    Get.to(BigPrivatePhotoScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(15)),


                      child: CachedNetworkImage(imageUrl: myProfile!.publicphoto[index].backgroundImage,width:125,height: 125,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                        errorWidget: (context, url, error) => new Icon(Icons.person),
                      ),),
                  ),
                );

          }),
        )
  ),
      ),
    );
  }


}
