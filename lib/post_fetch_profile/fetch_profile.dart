import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/chatfirebase/pages/ShowChatPage.dart';
import 'package:uuid/uuid.dart';

import '../PostFollowTab/PostFollowerScreen.dart';
import '../chatfirebase/models/ChatRoomModel.dart';
import '../chatfirebase/models/FirebaseHelper.dart';
import '../chatfirebase/models/UserModel.dart';
import '../chatfirebase/pages/ChatRoomPage.dart';
import '../followerscreen.dart';
import '../model/fetch_profile_response.dart';
import '../model/followmodel.dart';
import '../profile_tab/privateecoscreen.dart';
import '../profile_tab/privatephotoscreen.dart';
import '../profile_tab/publicecoscreen.dart';
import '../profile_tab/publicphotoscreen.dart';
import '../settingscreen.dart';
import 'fetch_eco_screen.dart';
import 'fetch_photo_screen.dart';
class fetchprofile extends StatefulWidget {


  final UserModel userModel;
  final User firebaseUser;
   fetchprofile({Key? key,required this.userModel,required this.firebaseUser}) : super(key: key);

  @override
  State<fetchprofile> createState() => _fetchprofileState();
}

class _fetchprofileState extends State<fetchprofile> {
  Fetchprofileresponse? fetchprofileresponse;

  String fetchprofilename="";
  String fetchprofilepic="";
  String fetchprofilepostcount="";
  String fetchprofilefollowercount="";
  String fetchprofilefollowingcount="";
  String token="";
  String followmessage="UnFollowed successfully!";
  String Unfollowmessage="";
  String idtoken="";
  FollowModel? followModel;
  String action="";
  String unfollowaction="";
  Future getProfileid() async

  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("postuserid").toString();

    setState(() {
      token=userId;
    });
    print("vvdsbvhsbdvsdmvsdmv$token");
  }
  Future setprofileid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("pubechouid", token);
  }
    Future<void> settokenprofileid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("followertoken", token);
  }
  Future getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();

    setState(() {
      idtoken=userId;
    });
    print("vvdsbvhsbdvdscvfbgsdmvsdmv$idtoken");
  }
  Future fetchprofile() async{

    final response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/fetch_profile"),body: {

        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID":"$token"

    });
    if(response.statusCode==200){
      print("+++++++++++++++++==========${response.body}");
      setState((){
        fetchprofileresponse=fetchprofileresponseFromJson(response.body);
        fetchprofilename=fetchprofileresponse!.data.name.toString();
        fetchprofilepic=fetchprofileresponse!.data.profilePic.toString();
        fetchprofilepostcount=fetchprofileresponse!.data.postsCount.toString();
        fetchprofilefollowercount=fetchprofileresponse!.data.followerCount.toString();
        fetchprofilefollowingcount=fetchprofileresponse!.data.followingCount.toString();
      });


    }
    else{
      print(response.statusCode);
    }
  }
  Future<void> fetchresponse(name)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('fetchname', name);
  }
  String statuschexk="";
  Future followbtn({required String statuscheck})async{
    final response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/follow"),body:
      {
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "USER_ID":"$idtoken",
        "TO_WHOM": "$token",
        "FOLLOW_STATUS":"$statuscheck"
      }
    );
    if(response.statusCode==200){
      followModel=followModelFromJson(response.body);
      setState((){
        followmessage=followModel!.message.toString();
        action=followModel!.action.toString();
        print("1324r4$action");
        print(followmessage);
      });

    }else{
      print(response.statusCode);
    }
  }
  // Future Unfollowbtn({required String statuscheck})async{
  //   final response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/follow"),body:
  //   {
  //     "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
  //     "USER_ID":"$idtoken",
  //     "TO_WHOM": "$token",
  //     "FOLLOW_STATUS":"$statuscheck"
  //   }
  //   );
  //   if(response.statusCode==200){
  //     followModel=followModelFromJson(response.body);
  //     setState((){
  //
  //       Unfollowmessage=followModel!.message.toString();
  //       unfollowaction=followModel!.action.toString();
  //       print(Unfollowmessage);
  //       print("1324r4$unfollowaction");
  //     });
  //
  //   }else{
  //     print(response.statusCode);
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserid();
    getProfileid().whenComplete(() async {
   await fetchprofile();
   print("gsdhvjbvkblk$token");

    });

    print("bcbdcd nc${fetchprofilename}");


  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.all(10),
                child: Container(
                  height: 284,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).errorColor),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 10,top: 15,bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child:
                                    fetchprofilepic==null?
                                    Image.asset('asset/images/dummyimage-removebg-preview.png',width: 60,height: 50,):
                                    CachedNetworkImage (imageUrl: "$fetchprofilepic",width: 60,height: 60,
                                      placeholder: (context, url) => new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => new Icon(Icons.person),),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width / 30,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$fetchprofilename',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color:Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color:Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color:Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color:Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width / 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.menu,
                                      color:Theme.of(context).disabledColor,
                                      size: 25,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: 23),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      fetchprofilepostcount!=null?'$fetchprofilepostcount':'',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color:Theme.of(context).disabledColor),
                                    ),
                                    Text(
                                      'post',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color:Theme.of(context).disabledColor.withOpacity(0.7)),
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  width:size.width*0.02,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    fetchresponse('$fetchprofilename');
                                    settokenprofileid();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => PostFollowerscreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser, selectedpage: 0,)));
                                  },

                                  child: Column(
                                    children: [
                                      Text(
                                        fetchprofilefollowercount!=null? '$fetchprofilefollowercount':'',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color:Theme.of(context).disabledColor),
                                      ),
                                      Text(
                                        'followers',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color:Theme.of(context).disabledColor.withOpacity(0.7)),
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width*0.02,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    fetchresponse('$fetchprofilename');
                                    settokenprofileid();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => PostFollowerscreen( userModel: widget.userModel, firebaseUser: widget.firebaseUser,selectedpage: 1,)));
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        fetchprofilefollowingcount!=null? '$fetchprofilefollowingcount':'',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color:Theme.of(context).disabledColor),
                                      ),
                                      Text(
                                        'following',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color:Theme.of(context).disabledColor.withOpacity(0.7)),
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: ()async{

                                  if(followmessage=="UnFollowed successfully!"){
                                    await  followbtn(statuscheck: "Follow");
                                  }else if (followmessage=="Followed successfully!"){
                                    await  followbtn(statuscheck: "UnFollow");

                                  }
                                },
                                child: Container(
                                  width: 150,
                                  height: 35,

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.red,),
                                  child: Center(
                                    child: Text(
                                      (followmessage=="UnFollowed successfully!")?"Follow":(followmessage=="Followed successfully!")?"UnFollow":"",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color:Theme.of(context).disabledColor.withOpacity(0.95)),
                                    ),
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: ()async{
                              //
                              //     await  Unfollowbtn(statuscheck: "UnFollow");
                              //     Fluttertoast.showToast(msg: Unfollowmessage);
                              //        },
                              //   child: Visibility(
                              //     visible:followmessage=="Followed successfully!"?true: false,
                              //     child: Container(
                              //       width: 150,
                              //       height: 35,
                              //
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(8),
                              //         color: Colors.red,),
                              //       child: Center(
                              //         child: Text(
                              //           Unfollowmessage=="UnFollowed successfully!"?"$action":"Unfollow",
                              //           style: TextStyle(
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.w700,
                              //               color: Colors.white),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                width: size.width*0.03,
                              ),

                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection("users").where("fullname",isEqualTo: "$fetchprofilename" ).snapshots(), builder:
                                  (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                    if(snapshot.hasData) {
                                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                                      if(dataSnapshot.docs.length > 0) {
                                        Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;

                                        UserModel searchedUser = UserModel.fromMap(userMap);

                                        return GestureDetector(
                                            onTap: () async {
                                              ChatRoomModel? chatroomModel = await getChatroomModel(searchedUser);

                                              if(chatroomModel != null) {
                                                Navigator.pop(context);
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) {
                                                      return ChatRoomPage(
                                                        targetUser: searchedUser,
                                                        userModel: widget.userModel,
                                                        firebaseUser: widget.firebaseUser,
                                                        chatroom: chatroomModel,
                                                      );
                                                    }
                                                ));
                                              }
                                            },
                                          child: Container(

                                            height: 35,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color:Theme.of(context).disabledColor.withOpacity(0.5))),
                                            child: Center(
                                              child: Text('Messages',style: TextStyle(
                                                  color:Theme.of(context).disabledColor.withOpacity(0.5)
                                              ),),
                                            ),
                                          ),

                                        );
                                      }
                                      else {
                                        return Container(
                                          height: 35,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color:Theme.of(context).disabledColor.withOpacity(0.5))),
                                          child: Center(
                                            child: Text('Messages',style: TextStyle(
                                                color:Theme.of(context).disabledColor.withOpacity(0.5)
                                            ),),
                                          ),
                                        );
                                      }

                                    }
                                    else{
                                      return Container(

                                        height: 35,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color:Theme.of(context).disabledColor.withOpacity(0.5))),
                                        child: Center(
                                          child: Text('Messages',style: TextStyle(
                                              color:Theme.of(context).disabledColor.withOpacity(0.5)
                                          ),),
                                        ),
                                      );
                                    }
                                  },

                                  ),


                                // Container(
                                //
                                //   height: 35,
                                //   width: 150,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(8),
                                //     border: Border.all(color:Theme.of(context).disabledColor.withOpacity(0.5))),
                                //   child: Center(
                                //     child: Text('Messages',style: TextStyle(
                                //       color:Theme.of(context).disabledColor.withOpacity(0.5)
                                //     ),),
                                //   ),
                                // ),

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _tabSection(context),
            ],
          ),
        ),
      ),
    );
  }
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true).where("participants.${targetUser.uid}", isEqualTo: true).get();

    if(snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();

      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
      print("existing is ${widget.userModel.uid}");
      print("existing target  is ${targetUser.uid}");
      print("existing target  is ${widget.userModel.uid}");
      //   print("existing length  is ${chatRoom.participants?.length}");

    }
    else {
      String filename=Uuid().v1();
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid:filename,
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance.collection("chatrooms").doc(newChatroom.chatroomid).set(newChatroom.toMap());

      chatRoom = newChatroom;

      print("New Chatroom Created!");
      print("New Chatroom Created!${newChatroom.chatroomid}");
    }

    return chatRoom;
  }
  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,

      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // width: 2.w,
            child: TabBar(
                indicatorColor: Theme.of(context).disabledColor,
                isScrollable: false,

                labelStyle:
                TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
               labelColor: Theme.of(context).disabledColor,
                tabs: [
                  Tab(
                    text: "Echoes",
                  ),
                  Tab(text: "Photo"),

                ]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [

              FetchEcoScreen(token: token),

              FetchPhotoScreen(gettoken:token ,idtoken: idtoken,),
            ]),
          ),
        ],
      ),
    );
  }
}
