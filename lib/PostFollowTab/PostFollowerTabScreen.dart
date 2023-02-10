import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../chatfirebase/models/UserModel.dart';
import '../model/followers_following.dart';
import '../model/reportmodel.dart';
import '../post_fetch_profile/fetch_profile.dart';

class PostFollowerTabScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
   PostFollowerTabScreen({Key? key,required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<PostFollowerTabScreen> createState() => _PostFollowerTabScreenState();
}

class _PostFollowerTabScreenState extends State<PostFollowerTabScreen> {
  FollowersFollowingModel? followersFollowingModel;
  List<FollowerArray> followArray=[];
  String idtoken="";
  String id="";
  String name="";
  String pic="";
  String username="";
  Future<void> settid(uid)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('postuserid', uid);
  }
  Future getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("followertoken").toString();

    setState(() {
      idtoken=userId;
    });
    print("post foollower vv $idtoken");
  }

  @override
  void initState() {
    super.initState();
    getuserid().whenComplete(() async{
      await followerslist();
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
        body:followArray.length==0?Center(child: CircularProgressIndicator(
          color:  Theme.of(context).hoverColor,
        ),)

            : ListView.builder(
          shrinkWrap: true,
          itemCount: followArray.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          settid(followArray[index].id);

                          Get.to(fetchprofile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:followArray[index].profilePic==null? Image.asset('asset/images/dummyimage-removebg-preview.png',width: 60,height: 50,):
                          CachedNetworkImage (imageUrl: followArray[index].profilePic,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,

                            placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                            errorWidget: (context, url, error) => new Icon(Icons.error),),
                        ),
                      ),
                      SizedBox(
                        width: 14,
                      ),

                      GestureDetector(
                        onTap: (){
                          settid(followArray[index].id);

                          Get.to(fetchprofile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,));
                        },
                        child: Column(
                          children: [
                            Text(
                              '${followArray[index].name}',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hoverColor),
                            ),
                            Text(
                              '${followArray[index].username}',
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
                            GestureDetector(
                              onTap: (){

                              },
                              child: Image.asset(
                                "asset/images/follow.png",
                                width: 25,
                                height: 20,
                                color: Theme.of(context).hoverColor,
                              ),
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

        )



    );
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
                  child: CachedNetworkImage(
                    imageUrl: "${followArray[index].profilePic}",
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
                  )
              ),
              SizedBox(
                width: 11,
              ),
              Text(
                '${followArray[index].name}',
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
          onTap:()async{

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
        GestureDetector(
          onTap: ()async{

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
  Future followerslist()async{
    var response = await http.post(Uri.parse("http://3.227.35.5:3001/api/user/fetchFollowFollowingList"),body:
    {
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "ID":"$idtoken"
    }
    );
    if(response.statusCode==200){
      followersFollowingModel=followersFollowingModelFromJson(response.body);
      setState(() {
        for(int i=0;i<followersFollowingModel!.followerArray.length;i++){
          id = followersFollowingModel!.followerArray[i].id;
          name = followersFollowingModel!.followerArray[i].name;
          pic = followersFollowingModel!.followerArray[i].profilePic;
          username = followersFollowingModel!.followerArray[i].username;
          followArray.add(FollowerArray(id: id, name: name, profilePic: pic, username: username));
        }
      });
    }
    else{
      print(response.statusCode);
    }
  }
}
