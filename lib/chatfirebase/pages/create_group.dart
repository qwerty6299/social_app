import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/chatfirebase/pages/ShowChatPage.dart';
import 'package:uuid/uuid.dart';

import '../models/UserModel.dart';
import 'group_chat_home_screen.dart';
import 'home_screen.dart';

class CreateGroup extends StatefulWidget {
  List<Map<String,dynamic>> membersList=[];
  final   UserModel targetUser;

   CreateGroup({Key? key,required this.membersList,required this.targetUser}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("the duspl is ${_auth.currentUser!.displayName}");
    print("the duspl is ${widget.membersList.length}");
  }

  void createGroup() async {
    setState(() {
      isLoading = true;
    });

    String groupId = Uuid().v1();

    await _firestore.collection('groups').doc("groupId").set({
      "members": widget.membersList,
      "id": groupId,
    });

    for (int i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]['uid'];
      print("oneuid is$uid ");
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "name": _groupName.text,
        "id": groupId,
      });
    }

    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "message": "${widget.targetUser.fullname} Created This Group.",
      "type": "notify",
    });



    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => GroupChatHomeScreen(targetUser: widget.targetUser,)), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      body: isLoading
          ? Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
                controller: _groupName,
                decoration: InputDecoration(
                  hintText: "Enter Group Name",
                  hintStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide( color: Theme.of(context).accentColor,),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Theme.of(context).accentColor),
                  ),

                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).backgroundColor,
              side: BorderSide(
                color: Theme.of(context).accentColor
              )
            ),
            onPressed: createGroup,
            child: Text("Create Group",style: TextStyle(
              color: Theme.of(context).accentColor
            ),),
          ),
        ],
      ),
    );
  }
}
