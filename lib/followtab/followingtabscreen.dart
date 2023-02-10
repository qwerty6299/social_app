import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/showsnackbar.dart';
import '../chatfirebase/models/UserModel.dart';
import '../model/blockmodel.dart';
import '../model/followers_following.dart';
import '../model/reportmodel.dart';
import '../post_fetch_profile/fetch_profile.dart';

class FollowingTabScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  FollowingTabScreen({Key? key,required this.userModel, required this.firebaseUser
  }) : super(key: key);

  @override
  State<FollowingTabScreen> createState() => _FollowingTabScreenState();
}

class _FollowingTabScreenState extends State<FollowingTabScreen> {
  FollowersFollowingModel? followersFollowingModel;
  List<FollowArray> followerArray=[];
  String id="";
  String name="";
  String pic="";
  String username="";
  String idtoken="";
  Future getidtoken() async{
    final prefs= await SharedPreferences.getInstance();
    final showhome=prefs.getString("USER_ID")??'';
    setState(() {
      idtoken=showhome;
    });
    print("the id for following is $idtoken");
  }
  Future<void> settid(uid)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('postuserid', uid);
  }
  Future getfollowinglist()async{
    final result=await Connectivity().checkConnectivity();
    if(result==ConnectivityResult.wifi||result==ConnectivityResult.mobile) {
      await followinglist();
    }else{
      showconnectivitysnackbar(context, result);
    }
  }
  void showconnectivitysnackbar(BuildContext context,
      ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet ? "connection restored" :
    "No internet connection";
    final color = hasInternet ? Colors.green : Colors.red;
    Utils.showsnackbar(context, message, color);
  }
  Future followinglist()async{
    var response = await http.post(Uri.parse("http://3.227.35.5:3001/api/user/fetchFollowFollowingList"),body:
    {
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "ID":"$idtoken"
    }
    );
    if(response.statusCode==200){
      followersFollowingModel=followersFollowingModelFromJson(response.body);
      setState(() {
        for(int i=0;i<followersFollowingModel!.followArray.length;i++){
          id = followersFollowingModel!.followArray[i].id;
          name = followersFollowingModel!.followArray[i].name;
          pic = followersFollowingModel!.followArray[i].profilePic;
          username = followersFollowingModel!.followArray[i].username;
          followerArray.add(FollowArray(id: id, name: name, profilePic: pic, username: username));
        }
      });
    }
    else{
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    getidtoken().whenComplete(() async {
   await getfollowinglist();
    });

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
        body:followersFollowingModel==null?Center(child: CircularProgressIndicator(
          color: Theme.of(context).hoverColor,
        ),)


        : followerArray.length==0?SizedBox.expand(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Image.asset("asset/images/nofollowe.png",width: 100,height: 60,),
                SizedBox(
                  height: 8,
                ),
                Text('No Result Found',style: TextStyle(
                    color: Theme.of(context).hoverColor
                ),)
              ]

          ),
        ):ListView.builder(
          shrinkWrap: true,
          itemCount: followerArray.length,
          itemBuilder: (BuildContext context, int index) {

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          settid(followerArray[index].id);

                       Get.to(fetchprofile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage (imageUrl: followerArray[index].profilePic,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,

                            placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                            errorWidget: (context, url, error) => new Icon(Icons.person),),
                        ),
                      ),
                      SizedBox(
                        width: 14,
                      ),

                      GestureDetector(
                        onTap: (){
                          settid(followerArray[index].id);

                         Get.to(fetchprofile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,));
                        },
                        child: Column(
                          children: [
                            Text(
                              '${followerArray[index].name}',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hoverColor),
                            ),
                            Text(
                              '${followerArray[index].username}',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hoverColor),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.person_add_alt_outlined,
                              color: Theme.of(context).hoverColor,
                            ),
                            GestureDetector(
                              onTap: () => showModalBottomSheet(
                                  backgroundColor: Color(0xff4E4E4E),
                                  context: context,
                                  builder: (context) => buildSheet(index),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)))),
                              child: Icon(
                                Icons.more_vert_outlined,
                                color: Theme.of(context).hoverColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),





              ],
            );
          },

        ));
  }
  String reportmessage="";
  String blockmessage="";
  ReportModel? reportModel;
  BlockModel? blockmodel;
  Future reportlisttt({required String reportid})async{
    var body={
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "UID": "$reportid",
      "LUID": "$idtoken"
    };
    var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/report"),body:body );

    if(response.statusCode==200){
      print(body);
      reportModel=reportModelFromJson(response.body);
      setState(() {
        reportmessage=reportModel!.message;
        print(reportmessage);
      });


    }
  }
  Future blocklisttt({required String blockid})async{
    var body={
      "APP_KEY":"SpTka6TdghfvhdwrTsXl28P1",
      "UID":"$blockid",
      "LUID":"$idtoken"
    };
    var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/block"),body:body);
    if(response.statusCode==200){
      blockmodel=blockModelFromJson(response.body);
      setState(() {
        blockmessage=blockmodel!.message.toString();
        print("the block msg is $blockmessage");
      });
    }
  }


  Widget buildSheet(int index) => Container(
        height: 260,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22, left: 19),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:  CachedNetworkImage(
                      imageUrl: "${followerArray[index].profilePic}",
                      fit: BoxFit.fill,
                      width: 30,
                      height: 30,
                      placeholder: (context, url) => Padding(
                        padding: EdgeInsets.all(18.0),
                        child: CircularProgressIndicator(
                            strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.person),
                    ),
                  ),
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '${followerArray[index].name}',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 10,
              color: Color(0xff808080),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    'Remove From Followers',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Divider(
              height: 15,
              color: Color(0xff808080),
            ),
            GestureDetector(
              onTap: () async{
                await reportlisttt(reportid: followerArray[index].id);
                 Fluttertoast.showToast(msg: reportmessage);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 14, left: 20),
                child: Row(
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Divider(
              height: 10,
              color: Color(0xff808080),
            ),
            InkWell(
              onTap: () async{
              await  blocklisttt(blockid: followerArray[index].id);
                 Fluttertoast.showToast(msg: blockmessage);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 9, left: 20),
                child: Row(
                  children: [
                    Text(
                      'Block',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
