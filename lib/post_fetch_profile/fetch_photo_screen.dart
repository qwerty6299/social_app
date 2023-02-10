import 'dart:convert';
import 'dart:developer';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/fetch_profile_response.dart';
import 'package:http/http.dart'as http;

import '../model/my_profile_model.dart';

class FetchPhotoScreen extends StatefulWidget {
  String gettoken,idtoken;
   FetchPhotoScreen({Key? key,required this.gettoken,required this.idtoken}) : super(key: key);

  @override
  State<FetchPhotoScreen> createState() => _FetchPhotoScreenState();
}

class _FetchPhotoScreenState extends State<FetchPhotoScreen> {

  List<Photo> publicphoto=[];
  MyPrModel? myProfile;
  void initState() {


    super.initState();
   getProfile(userId: "${widget.gettoken}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      body: SingleChildScrollView(
        child: Container(
          height: 90.h,
          // padding: EdgeInsets.all(12.0),
          child:myProfile==null?Center(
            heightFactor: 14,
              child: CircularProgressIndicator(

          )):myProfile!.publicphoto.length==0?Center(child: Text("No Result Found",style: TextStyle(
            color: Colors.white
          ),)):
          GridView.builder(
            itemCount: publicphoto.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 3,),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: myProfile!.publicphoto[index].backgroundImage==null?Container(): CachedNetworkImage (imageUrl:  myProfile!.publicphoto[index].backgroundImage,
                      width:125,height: 125,
                      fit: BoxFit.fill,

                      placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                      errorWidget: (context, url, error) => new Icon(Icons.person),),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String backfroundimage="";
  Future<Fetchprofileresponse?> getProfile({required String userId}) async {

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
              .encode({"APP_KEY": "SpTka6TdghfvhdwrTsXl28P1", "ID": userId}));
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        myProfile=myPrModelFromJson(response.body);
        setState(() {
          for(int i=0;i<myProfile!.publicphoto.length;i++){
            backfroundimage=myProfile!.publicphoto[i].backgroundImage;

            publicphoto.add(Photo( backgroundImage: backfroundimage,

            ));
          }
        });

      }
    } catch (e) {
      log(e.toString());
    }
  }
}


