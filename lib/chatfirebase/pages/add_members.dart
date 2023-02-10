
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/UserModel.dart';
import 'create_group.dart';

class AddMembersInGroup extends StatefulWidget {
  final   UserModel targetUser;
   AddMembersInGroup({Key? key,required this.targetUser}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
    print("gchcgc${_auth.currentUser!.uid}");
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        membersList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {

        userMap = value.docs[0].data();
        isLoading = false;
      });
      print("the user map is $userMap");
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
      print("result tap is ${membersList[i]["name"]}");
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": userMap!['fullname'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });
        print("the  resylttap user map is ${membersList.length}");
        userMap = null;
      });
    }

  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });

    }
  }
  bool tapped=false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,

        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,size: 20,),
                  ),
                  Flexible(
                    child: Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        child: new TextField(
                          cursorColor: Theme.of(context).accentColor,
                        onChanged: (val){
                          onSearch();
                        },

                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 14
                          ),
                          controller: _search,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,color: Theme.of(context).accentColor,
                            ),


                            hintText: 'Search....',
                            hintStyle: TextStyle(
                              color: Theme.of(context).accentColor.withOpacity(0.5)
                            ),
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            enabledBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.more_vert,color: Theme.of(context).accentColor,size: 20,),
                  ),
                ],
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onRemoveMembers(index),
                      leading: Icon(Icons.account_circle,color: Colors.white,),
                      title: Text(membersList[index]['name'],style: TextStyle(
                        color: Colors.white
                      ),),
                      subtitle: Text(membersList[index]['email'],style: TextStyle(
                          color: Colors.white
                      )),
                      trailing: Icon(Icons.close,color: Colors.white,),
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              // Container(
              //   height: size.height / 14,
              //   width: size.width,
              //   alignment: Alignment.center,
              //   child: Container(
              //     height: size.height / 14,
              //     width: size.width / 1.15,
              //     child: TextField(
              //       controller: _search,
              //       decoration: InputDecoration(
              //         hintText: "Search",
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: size.height / 50,
              // ),
              // isLoading
              //     ? Container(
              //   height: size.height / 12,
              //   width: size.height / 12,
              //   alignment: Alignment.center,
              //   child: CircularProgressIndicator(),
              // )
              //     : ElevatedButton(
              //   onPressed: onSearch,
              //   child: Text("Search"),
              // ),
              userMap != null
                  ? ListTile(
                onTap: onResultTap,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child:userMap!['profilepic']==null?Container(): Image.network(userMap!['profilepic']),
                ),
                title: Text(userMap!['fullname'],style: TextStyle(
                  color: Colors.white
                ),),
                subtitle: Text(userMap!['email'],style: TextStyle(
                    color: Colors.white
                )),
                trailing: Icon(Icons.add,color: Colors.white,),
              )
                  : SizedBox(),


            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: membersList.length >= 2
            ?Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.03),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CreateGroup(
                        membersList: membersList, targetUser: widget.targetUser,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 60,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(colors: [Color(0xffEB4938), Color(0xff950E00)])
                  ),
                  child: Center(child: Text('Done',style: TextStyle(
                    color: Colors.white,fontSize: 16
                  ),))

        //         FloatingActionButton.extended(
        //
        //   onPressed: ()=> {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (_) => CreateGroup(
        //               membersList: membersList, targetUser: widget.targetUser,
        //             ),
        //           ),
        //         ),
        //   },
        //
        //   label: Text("Save"),
        // ),
                ),
              ),
            )
            : SizedBox(),
      ),
    );
  }
}