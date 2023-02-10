import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/commentlist_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
class CommentListPage extends StatefulWidget {
  const CommentListPage({Key? key}) : super(key: key);

  @override
  State<CommentListPage> createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  String postidtoken="";
  List<CommentList> commentlist=[];
  String name="";
  String pic="";
  String comment="";
  String comment_time="";
  String comment_id="";
  String imagepref="";

  CommentListModel? commentListModel;
  Future<void> getcommentlist() async{
  var response=await http.post(Uri.parse('http://3.227.35.5:3001/api/user/comment-list'),body: json.encode({
    "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
    "POST_ID":"$postidtoken"
  }), headers: {
    'Content-Type': 'application/json',
    'Cookie':
    'connect.sid=s%3AtVnLmITSn_zletRj2nMA2yCjWafW69aY.vufwo%2Fh45zhYEp06x9RKcV0mhk2DkYDZ1twbPiJRp5Y'
  });
  if(response.statusCode==200){
    print(response.body);
    setState((){
      commentListModel=CommentListModel.fromJson(json.decode(response.body));
    for(int i=0;i<commentListModel!.commentList.length;i++){
    name=commentListModel!.commentList[i].name;
    pic=commentListModel!.commentList[i].profilePic;
    comment=commentListModel!.commentList[i].comment;
    comment_time=commentListModel!.commentList[i].commentTime;
    comment_id=commentListModel!.commentList[i].commentId;
    commentlist.add(CommentList(name: name, profilePic: pic, username: "username", comment: comment,
        commentType: "Text", commentTime: comment_time,
        commentLikes: 1, commentReplies: 1, commentId:  comment_id));
    }
    });
  }
  }
  Future gettoken()async{

    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    var  extratokuuu = tokensharedpreferences.getString('post_id');
    setState(() {
 postidtoken=extratokuuu!;
    });
    print("token get is ${postidtoken}");



  }
  Future getimageurl()async{

    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    var  newimage = tokensharedpreferences.getString('image_url');
    setState(() {
     imagepref=newimage!;
    });
    print("token get is ${imagepref}");



  }
  @override
  void initState() {
    getimageurl();
    gettoken().whenComplete(() async {
      await getcommentlist();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xff161730),
      body: SafeArea(
        child:Column(
          children: [
          imagepref==""?Container(): ClipRRect(


              child: CachedNetworkImage(imageUrl: imagepref,width: double.infinity,height: 250,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                errorWidget: (context, url, error) => new Icon(Icons.person),
               )),
            if (commentListModel==null) CircularProgressIndicator(
            ) else Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                  itemCount: commentlist.length,
                    itemBuilder: (BuildContext context , int index){
                  return  Column(
                   
                    children: [

                      Container(

                        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                        child: Row(
                          children: [
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: CachedNetworkImageProvider(commentlist[index].profilePic),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10,),
                                Container(
                                  padding:  EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border:Border.all(width:0.5),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("${commentlist[index].name}", style: TextStyle(fontSize: 16,color: Colors.white),),
                                      SizedBox(height: 6,),
                                      Container(
                                        constraints: BoxConstraints.loose(Size(
                                            200.0, 250.0
                                        )),
                                        child: Text("${commentlist[index].comment}",
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 8,
                                          style: TextStyle(fontSize: 13,color: Colors.white,
                                            fontWeight:FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('${commentlist[index].commentTime}',style: TextStyle(fontSize: 13,color: Colors.white)),
                        ],
                      )
                    ],
                  );
                }),
            ),
          ),
          ],
        ),
      )
    );
  }
}
