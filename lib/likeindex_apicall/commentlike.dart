import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart'as http;
import '../commentreplylistshow.dart';
import '../model/Comment_like_model.dart';
import '../model/commentlistshowmodel.dart';

class CommentLikefolder extends StatefulWidget {
  String id,commentid;
  int likes;
  bool islikes;
   CommentLikefolder({Key? key,required this.id,required this.commentid,required this.islikes,
     required this.likes}) : super(key: key);

  @override
  State<CommentLikefolder> createState() => _CommentLikefolderState();
}

class _CommentLikefolderState extends State<CommentLikefolder> {
  ComementLikeModel? comementLikeModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.likes;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.only(right: 15.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: ()async{
              await commentlike(id: widget.id,commentid: widget.commentid);
      setState(() {
        if (comementLikeModel!.message=="Liked successfully!") {
         widget.likes += 1;
          widget.islikes=true;
        }
        else if(comementLikeModel!.message=="Like removed successfully!"){
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

                ),],),
          ),
          GestureDetector(
            // onTap: () async {
            //   final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
            //   tokensharedpreferences.setString('like_post_id', widget.postid);
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               LikesScreen()));
            //
            // },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Text('${widget.likes}', style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffD1D1D1)),key: ValueKey(widget.likes),),transitionBuilder: (Widget child,Animation<double> animation){
              return ScaleTransition(scale: animation,child: child,);
            },),

          ),


        ],
      ),
    );
  }
  Future commentlike({required String id,required String commentid}) async {


    try {
      print("trying to Like");

      var url = Uri.parse("http://3.227.35.5:3001/api/user/commentlike");
      var body={
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID": "$id",
        "COMMENT_ID": "$commentid"
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
          comementLikeModel=comementLikeModelFromJson(response.body);
        });

      }
    } catch (e) {
      log(e.toString());
    }
  }
}
