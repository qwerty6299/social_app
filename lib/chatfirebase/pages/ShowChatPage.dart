import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/aaaaaaaa/bottom_navigation_page.dart';
import 'package:socialapp/chatfirebase/models/ChatRoomModel.dart';
import 'package:socialapp/chatfirebase/models/FirebaseHelper.dart';
import 'package:socialapp/chatfirebase/models/UIHelper.dart';
import 'package:socialapp/chatfirebase/models/UserModel.dart';
import 'package:socialapp/chatfirebase/pages/ChatRoomPage.dart';
import 'package:socialapp/chatfirebase/pages/LoginPage.dart';
import 'package:socialapp/chatfirebase/pages/SearchPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/chatfirebase/pages/group_chat_home_screen.dart';
import 'package:socialapp/homepage.dart';
import 'package:uuid/uuid.dart';

import '../chatfirebasesetup.dart';
import 'home_screen.dart';

class ShowChatPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ShowChatPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _ShowChatPageState createState() => _ShowChatPageState();
}

class _ShowChatPageState extends State<ShowChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpic();
    print("budsvswdefruds${widget.userModel.email}");


  }
  String chatimg="";

  Future getpic()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   String img= prefs.getString("mainpagepic").toString();
   setState(() {
     chatimg=img;
   });
  }
  TextEditingController searchController = TextEditingController();
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
  bool tapped=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor:Theme.of(context).backgroundColor,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.group),
      //   onPressed: (){
      //
      //   },
      // ),
      // appBar: AppBar(
      //
      //
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         await FirebaseAuth.instance.signOut();
      //         Navigator.popUntil(context, (route) => route.isFirst);
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) {
      //               return LoginPage();
      //             }
      //           ),
      //         );
      //       },
      //       icon: Icon(Icons.exit_to_app),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ExpandTapWidget(
                  onTap: (){
                    Get.to(BottomNavigationPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser));

                  },
                  tapPadding: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,size: 20,),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: new EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: new TextField(
                        onChanged: (val){
                          setState(() {
                            tapped=true;
                          });
                        },

                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 14
                        ),
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,color: Theme.of(context).accentColor,
                          ),

                          // suffixIcon: GestureDetector(
                          //   onTap: (){
                          //
                          //   },
                          //   child: Icon(Icons.score,color: Theme.of(context).accentColor,),
                          // ),
                          hintText: 'Search',
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          enabledBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide:  BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.more_vert,color: Theme.of(context).accentColor,size: 20,),
                ),
              ],
            ),


           SizedBox(
              height: 0.055,
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Text('New message',style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,

                ),),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: (){
                    print("GroupChatHomeScreen pressed${widget.userModel.fullname}");
                    print("GroupChatHomeScreen pressed${widget.userModel.email}");
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupChatHomeScreen(targetUser: widget.userModel,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('create a group chat'),
                          Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child:  tapped==true?
              StreamBuilder(
                  stream:searchController.text.toString().contains("@")? FirebaseFirestore.instance.collection("users").where("email",isEqualTo: searchController.text ).snapshots():
                  FirebaseFirestore.instance.collection("users").where("fullname",isEqualTo: searchController.text ).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active) {
                      if(snapshot.hasData) {
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                        if(dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;

                          UserModel searchedUser = UserModel.fromMap(userMap);

                          return ListTile(
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
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(searchedUser.profilepic!),
                              backgroundColor: Colors.grey[500],
                            ),
                            title: Text(searchedUser.fullname!,style: TextStyle(
                              color: Theme.of(context).accentColor
                            ),),
                            subtitle: Text(searchedUser.email!,style: TextStyle(
                                color: Theme.of(context).accentColor
                            )),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Theme.of(context).accentColor
                            )
                          );
                        }
                        else {
                          return Text("No results found!");
                        }

                      }
                      else if(snapshot.hasError) {
                        return Text("An error occured!");
                      }
                      else {
                        return Text("No results found!");
                      }
                    }
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
              ):

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.active) {
                    if(snapshot.hasData) {
                      QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);

                          Map<String, dynamic> participants = chatRoomModel.participants!;

                          List<String> participantKeys = participants.keys.toList();
                          participantKeys.remove(widget.userModel.uid);

                          return FutureBuilder(
                            future: FirebaseHelper.getUserModelById(participantKeys[0]),
                            builder: (context, userData) {
                              if(userData.connectionState == ConnectionState.done) {
                                if(userData.data != null) {
                                  UserModel targetUser = userData.data as UserModel;

                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                         print(" the chat image is ${targetUser.profilepic.toString()}");

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              return ChatRoomPage(
                                                chatroom: chatRoomModel,
                                                firebaseUser: widget.firebaseUser,
                                                userModel: widget.userModel,
                                                targetUser: targetUser,
                                              );
                                            }),
                                          );
                                        },
                                        leading:targetUser.profilepic.toString()!=""? CircleAvatar(
                                          backgroundImage: NetworkImage(targetUser.profilepic.toString()),
                                        ):CircleAvatar(),

                                        title: Text(targetUser.fullname.toString(),style: TextStyle(
                                          color: Theme.of(context).accentColor
                                        ),),
                                        subtitle: (chatRoomModel.lastMessage.toString() != "") ? Text(chatRoomModel.lastMessage.toString(),style: TextStyle(
                                            color: Theme.of(context).accentColor
                                        ),) : Text("Say hi to your new friend!", style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),),
                                      ),
                                      Divider(
                                        color: Colors.grey.withOpacity(0.5),
                                        thickness: 1,
                                      )
                                    ],
                                  );
                                }
                                else {
                                  return Container();
                                }
                              }
                              else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    }
                    else if(snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    else {
                      return Center(
                        child: SvgPicture.asset("asset/images/nochatpic.svg"),
                      );
                    }
                  }
                  else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

          ],
        ),
      ),

    );
  }
}