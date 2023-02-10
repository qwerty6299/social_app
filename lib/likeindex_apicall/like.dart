import 'dart:developer';

import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/chatfirebase/models/UserModel.dart';
import 'package:socialapp/model/fetch_profile_response.dart';
import '../likesscreen.dart';
import '../model/Likedresponse.dart';
import '../model/home_screen_model.dart';

class Likeresponse extends StatefulWidget {
  String id,postid;
  int likes;
  bool islikes;
  final UserModel userModel;
  final User firebaseUser;
  Likeresponse({Key? key,required this.id,required this.postid,
    required this.likes,required this.islikes,required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<Likeresponse> createState() => _LikeresponseState();
}

class _LikeresponseState extends State<Likeresponse> {

  List<PostList> postlist=[];
  Likedresponse? likedresponse;
  bool checked=false;

  @override
  void initState() {
    super.initState();
    widget.likes;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Row(
      children: [
        GestureDetector(
            onTap:() async{
              await   postLike(
                  newuserid: widget.id, postId: widget.postid
              );
              setState(() {
                  if (likedresponse!.check==true) {
                    widget.likes += 1;
                    widget.islikes=true;
                  }
                  else if(likedresponse!.check==false){
                   widget.likes-=1;
                   widget.islikes=false;
                  }

              });


              },
            child: Row(
              children: [
                SvgPicture.asset(
                  "asset/images/love.svg",
                  height: 24,
                  width: 24,

                  color:widget.islikes==true
                      ? Colors.redAccent
                      :(widget.islikes=false)?Colors.white:Colors.white,

                ),],),),
                SizedBox(width: size.width / 50),
        ExpandTapWidget(
                  onTap: () async {
                    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
                    tokensharedpreferences.setString('like_post_id', widget.postid);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LikesScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));

                  },
                  tapPadding: EdgeInsets.only(right: 3,left: 1),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Text('${widget.likes}', style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffD1D1D1)),key: ValueKey(widget.likes),),transitionBuilder: (Widget child,Animation<double> animation){
                      return ScaleTransition(scale: animation,child: child,);
                    },),

                )
              ],

    );
  }

  Future postLike({required String newuserid,required String postId}) async {


    try {
      print("trying to Like");

      var url = Uri.parse("http://3.227.35.5:3001/api/user/like");
      var body={
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID": "$newuserid",
        "POST_ID": "$postId"
      };
      var response = await http.post(url,
          body:body
      );
      print(response.statusCode);
      if(response.statusCode==200){
        print(response.body);
        print(body);
      }



      if (response.statusCode == 200) {
        print("---------- Success Like -------------");
        setState((){
          likedresponse=likedresponseFromJson(response.body);
        });

      }
    } catch (e) {
      log(e.toString());
    }
  }
}
