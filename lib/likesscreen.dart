import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/hometabscreen.dart';
import 'package:http/http.dart' as http;
import 'package:socialapp/post_fetch_profile/fetch_profile.dart';

import 'chatfirebase/models/UserModel.dart';
import 'model/liked_list_response.dart';

class LikesScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  LikesScreen({Key? key,required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  LikedListresponse? likedListresponse;
  List<LikeList> likelist=[];
  Future<void> newpostlikeuserid(uid)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('postuserid', uid);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(

        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading:  ExpandTapWidget(
              tapPadding: EdgeInsets.all(10.0),
              onTap: (){
               Navigator.of(context).pop();

              },
              child: SvgPicture.asset('asset/images/back_arow.svg',width: 10,height: 15,fit: BoxFit.scaleDown,
                color: Theme.of(context).hoverColor,)),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Likes',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600,color: Theme.of(context).hoverColor,),
          ),
        ),
        body:likedListresponse==null?Center(
          heightFactor: 14,
          child: CircularProgressIndicator(),
        ):likedListresponse!.likeList.length==0?Center(child: Center(
          child: Text('no result found', 
            style: TextStyle(
                wordSpacing: 2,
                color: Theme.of(context).hoverColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),),
        ),): ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
    itemCount: likedListresponse!.likeList.length,
    itemBuilder: (context, i) => 
        Column(
            children: [
              Padding(
                padding:  EdgeInsets.only(top: 30, left: 20),
                child: Row(
                  children: [
                    Column(
                      children: [
                     GestureDetector(
                       onTap: (){
                         newpostlikeuserid(likedListresponse!.likeList[i].uId);
                         },
                       child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                            CachedNetworkImage (imageUrl:likedListresponse!.likeList[i].profilePic,


                              width: 40,height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => ClipRRect(

                                  borderRadius: BorderRadius.circular(10),

                                  child: new Icon(Icons.person,color: Theme.of(context).hoverColor,)),)
                          ),
                     ),

                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: (){
                        newpostlikeuserid(likedListresponse!.likeList[i].uId);
                        Get.to(fetchprofile(
                          userModel: widget.userModel, firebaseUser: widget.firebaseUser,));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${likedListresponse!.likeList[i].name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,color: Theme.of(context).hoverColor,),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${likelist[i].username}',
                            style: TextStyle(color: Theme.of(context).hoverColor, fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RawMaterialButton(
                            onPressed: () {},
                            elevation: 2.0,
                            fillColor: Color(0xff494949),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(
                              side: BorderSide(
                                  width: 2,
                                  color: Color(0xffADADAD),
                                  style: BorderStyle.solid),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

String likeidtoken="";
  @override
  void initState() {
    super.initState();

    getlikeposttoken().whenComplete(()async {
  await getlikelist();

    });
  }
  Future getlikeposttoken()async{
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    var  extratokuuu = tokensharedpreferences.getString('like_post_id');
    setState(() {
      likeidtoken=extratokuuu!;
    });
    print("token like get is ${likeidtoken}");
  }
  String name="";
  String profilepic="";
  String username="";
  String uid="";

  Future getlikelist()async{
    var body={
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "POST_ID":"$likeidtoken"
    };
    var response = await http.post(Uri.parse("http://3.227.35.5:3001/api/user/like-list"),body:body );
    if(response.statusCode==200){
      print(response.body);
      setState(() {
        likedListresponse=likedListresponseFromJson(response.body);
        for(int i=0;i<likedListresponse!.likeList.length;i++){
         name=likedListresponse!.likeList[i].name;
         print("bfvhdsjcbxznvcd$name");

          profilepic=likedListresponse!.likeList[i].profilePic;
           username=likedListresponse!.likeList[i].username;
           uid=likedListresponse!.likeList[i].uId;
          likelist.add(LikeList(name: name, profilePic: profilepic, username: username,uId:uid ));

        }

      });
    }
    else{
      print(response.statusCode);
    }
  }
}
