import 'dart:convert';
import 'dart:developer';


import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/commentscreen.dart';
import 'package:http/http.dart' as http;
import 'package:socialapp/model/blockmodel.dart';
import 'package:socialapp/model/home_screen_model.dart';
import 'package:socialapp/model/reportmodel.dart';
import 'package:socialapp/post_fetch_profile/fetch_profile.dart';
import 'package:socialapp/profile_tab/privateechopagemanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Utils/showsnackbar.dart';
import 'audioManager.dart';
import 'chatfirebase/models/UserModel.dart';
import 'likeindex_apicall/like.dart';
import 'model/Likedresponse.dart';
import 'package:get/get.dart';
import 'model/bookmark_model.dart';
import 'likeindex_apicall/newclllll.dart';


final toComment = TextEditingController();

class HomeTabScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  HomeTabScreen({Key? key,required this.userModel,required this.firebaseUser}) : super(key: key);

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> with SingleTickerProviderStateMixin {
  ScrollController scrollController=ScrollController();

  String? profilepic;
  ReportModel? reportModel;
  BlockModel? blockmodel;
  BookmarkModel? bookmarkModel;
  String bookmarkmessage="";
  String homescreenid="";

   PageManager? _pageManager;

  HomeTabModel? _homeData;
  Likedresponse? likedresponse;
  List<bool>? likedmessage;

  // void showconnectivitysnackbar(BuildContext context,
  //     ConnectivityResult result) {
  //
  //   final hasInternet = result != ConnectivityResult.none;
  //   final message = hasInternet ? "connection restored" :
  //   "No internet connection";
  //   final color = hasInternet ? Colors.green : Colors.red;
  //   Utils.showsnackbar(context, message, color);
  //
  // }

  Future<HomeTabModel?> getHomeTab() async {
    const limit=3;
    try {
      print("trying to get POSTS");

      var url =  Uri.parse(ApiConstants.baseUrl + ApiConstants.homeEndPoint);
      // var iscacheexists = await APICacheManager().isAPICacheKeyExist("api");
      // if(!iscacheexists) {
        var response = await http.post(url,
            body: {
              "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
              "ID": "$newuserid",
              "OFFSET": "0"
            });
        print(response.statusCode);
        print("URL hit");
        if (response.statusCode == 200) {

          print(response.body);
          print("---------- Success -----------");
          APICacheDBModel cacheDBModel = new APICacheDBModel(key: "api", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);

          return homeTabModelFromJson(response.body);





        }
      // }
      // else{
      //   var cachedata = await APICacheManager().getCacheData("api");
      //   print("cache hit");
      //   return homeTabModelFromJson(cachedata.syncData);
      // }
    } catch (e) {
      print(e.toString()+"bhvyj,");
      print(e.toString()+"bhvyj,");

    }


  }

late TransformationController transformationController;
late AnimationController animationController;
Animation<Matrix4>? animation;

  void initState() {


gettokenuserid();
    super.initState();

    transformationController=TransformationController();
    animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 200))..addListener(() {
      transformationController.value=animation!.value;

    });

    }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    transformationController.dispose();
    animationController.dispose();
    _pageManager!.dispose();
  }

  // Future _getData() async {
  //   final result=await Connectivity().checkConnectivity();
  //   if(result==ConnectivityResult.wifi||result==ConnectivityResult.mobile) {
  //     await getHomeTab();
  //   }else{
  //     showconnectivitysnackbar(context, result);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      bottom: false,
      child: Scaffold(
        extendBody: true,

        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body:

         FutureBuilder(
           future: getHomeTab(),
           builder: (BuildContext context,AsyncSnapshot snapshot) {
             if(!snapshot.hasData){
               return Center(
                 child: CircularProgressIndicator(),
               );
             }
             final posts = snapshot.data;
             return ListView.builder(
                 itemCount: posts.postList.length,
                      scrollDirection: Axis.vertical,
                      //  controller: scrollController,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),

               itemBuilder: (context, i) {
                        _pageManager =
                            PageManager(audioUrl: "${posts.postList[i].audio}");
                        return Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0, left: 0),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          newpostid("${posts.postList[i].uId}");
                                          Get.to(() =>
                                              fetchprofile(
                                                  userModel: widget.userModel,
                                                  firebaseUser: widget
                                                      .firebaseUser));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 18.0,
                                              top: 12,
                                              right: 10,
                                              bottom: 0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: "${posts.postList[i].profilePic}",
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              placeholder: (context,
                                                  url) => new CircularProgressIndicator(),
                                              errorWidget: (context, url, error) =>
                                              new Icon(Icons.person),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      newpostid("${posts.postList[i].uId}");
                                      Get.to(() =>
                                          fetchprofile(userModel: widget.userModel
                                            , firebaseUser: widget.firebaseUser,));
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "${posts.postList[i].name}",

                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Theme
                                                  .of(context)
                                                  .hoverColor),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          '',

                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Theme
                                                  .of(context)
                                                  .hoverColor),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.07),
                                          child: GestureDetector(
                                            onTap: () =>
                                                showModalBottomSheet(
                                                    backgroundColor: Color(
                                                        0xff4E4E4E),
                                                    context: context,
                                                    builder: (context) {
                                                      return Text('csf');
                                                    },
                                                        // buildSheet(i),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .vertical(
                                                            top: Radius.circular(
                                                                20)))),
                                            child: Icon(
                                              Icons.more_vert_sharp,
                                              color: Theme
                                                  .of(context)
                                                  .hoverColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 20, right: 20),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(25.0),
                                          bottomLeft: Radius.circular(25.0),
                                          bottomRight: Radius.circular(25.0)
                                      ),

                                      color: Color(0xff262626),),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            print("the type is ${posts.postList[i]
                                                .type}");
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ShowImage(
                                                      imageUrl:"${posts.postList[i]
                                                          .backgroundImage}",
                                                    ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20.0),
                                                  topRight: Radius.circular(20.0)),
                                              child: posts.postList[i]
                                                  .backgroundImage == null
                                                  ? Container() : (posts.postList[i]
                                                  .type == "echo") ?


                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(15),
                                                    child: CachedNetworkImage(
                                                      imageUrl: "${posts.postList[i]
                                                          .backgroundImage}",

                                                      fit: BoxFit.fill,
                                                      placeholder: (context,
                                                          url) => new CircularProgressIndicator(),
                                                      errorWidget: (context, url,
                                                          error) =>
                                                      new Icon(Icons.person),),
                                                  ),
                                                  posts.postList[i]
                                                      .backgroundImage != ""
                                                      ? Positioned.fill(
                                                      child: Align(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Privateechoprivatemanager(
                                                            url:"${posts.postList[i]
                                                                .audio}",)))
                                                      : Container(height: 0,)
                                                ],
                                              )

                                                  : (posts.postList[i]
                                                  .type == "image")
                                                  ?
                                              CachedNetworkImage(
                                                imageUrl: "${posts.postList[i]
                                                    .backgroundImage}",

                                                fit: BoxFit.fill,
                                                placeholder: (context,
                                                    url) => new CircularProgressIndicator(),
                                                errorWidget: (context, url,
                                                    error) =>
                                                new Icon(Icons.person),)
                                                  : Container()


                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 16, bottom: 8),
                                          child:
                                          Row(children: [
                                            Likeresponse(
                                              userModel: widget.userModel,
                                              firebaseUser: widget.firebaseUser,
                                              postid: "${posts.postList[i].id}",
                                              id: newuserid,
                                              likes: posts.postList[i].likes!,
                                              islikes: posts.postList[i]
                                                  .islike!,),

                                            // GestureDetector(
                                            //   onTap: () async {
                                            //     final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
                                            //     tokensharedpreferences.setString('like_post_id', posts.postList[i].id);
                                            //     Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //             builder: (context) =>
                                            //                 LikesScreen()));
                                            //
                                            //   },
                                            //   child: Text(
                                            //     posts.postList[i].likes
                                            //         .toString(),
                                            //     style: TextStyle(
                                            //         fontFamily: 'Roboto',
                                            //         fontSize: 14,
                                            //         fontWeight: FontWeight.w400,
                                            //         color: Color(0xffD1D1D1)),
                                            //   ),
                                            // ),

                                            SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.07
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                print(posts.postList[i].id);
                                                newsettoken(
                                                    posts.postList[i].id);
                                                picset(posts.postList[i]
                                                    .profilePic);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommentScreen(
                                                              userModel: widget
                                                                  .userModel,
                                                              firebaseUser: widget
                                                                  .firebaseUser,)));
                                              },
                                              child: SvgPicture.asset(
                                                "asset/images/comment.svg",
                                                height: 24,
                                                width: 24,

                                                color: Colors.white,

                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.02
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                print(posts.postList[i].id);
                                                newsettoken(
                                                    posts.postList[i].id);
                                                picset(posts.postList[i]
                                                    .profilePic);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommentScreen(
                                                                userModel: widget
                                                                    .userModel,
                                                                firebaseUser: widget
                                                                    .firebaseUser)));
                                              },
                                              child: Text(
                                                posts.postList[i].comments
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.06
                                            ),
                                            SvgPicture.asset(
                                              "asset/images/nesend.svg",
                                              height: 20,
                                              width: 20,

                                              color: Colors.white,

                                            ),


                                            // GestureDetector(
                                            //   onTap: () async {
                                            //   await  postbookmark(id: newuserid,postid: posts.postList[i].id);
                                            //   setState(() {
                                            //  colored[i]=!colored[i];
                                            //  if(colored[i]==true){
                                            //    posts.postList[i].isbookmark==true;
                                            //  }
                                            //  else if(!colored[i]){
                                            //    posts.postList[i].isbookmark==false;
                                            //  }
                                            //   });
                                            //
                                            //
                                            //   },
                                            //   child: Icon(
                                            //     Icons.bookmark_add,
                                            //     color:colored[i]==true?Colors.red:Theme.of(context).hoverColor,
                                            //     size: 28,
                                            //   ),
                                            // )
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.06),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .end,
                                                  children: [
                                                    Bookmarklogic(id: newuserid,
                                                        postid: "${posts.postList[i].id}",
                                                        isbookmark: "${posts.postList[i]
                                                            .isbookmark}"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Row(
                                children: [
                                  Text(
                                   " ${posts.postList[i].title}",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Theme
                                            .of(context)
                                            .hoverColor),
                                  )
                                ],
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: 20, left: 7, right: 0),
                            //   child: Row(
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.only(left: 3.0),
                            //         child: ClipRRect(
                            //           borderRadius: BorderRadius.circular(10),
                            //           child: CachedNetworkImage(
                            //             imageUrl: "$mainpic",
                            //             width: 40,
                            //             height: 40,
                            //             fit: BoxFit.fill,
                            //             placeholder: (context,
                            //                 url) => new Container(),
                            //             errorWidget: (context, url,
                            //                 error) => new Icon(Icons.person),),
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         width: 8,
                            //       ),
                            //       // Container(
                            //       //   width: MediaQuery
                            //       //       .of(context)
                            //       //       .size
                            //       //       .width * 0.83,
                            //       //   height: 40,
                            //       //
                            //       //   decoration: BoxDecoration(
                            //       //       border: Border.all(
                            //       //         color: Theme.of(context).hoverColor,
                            //       //       ),
                            //       //       borderRadius: BorderRadius.all(
                            //       //           Radius.circular(50))
                            //       //   ),
                            //       //   child: Row(
                            //       //     children: [
                            //       //
                            //       //       SizedBox(
                            //       //         width: 8,
                            //       //       ),
                            //       //
                            //       //       Expanded(
                            //       //         child: Container(
                            //       //           width: 130,
                            //       //           height: 25,
                            //       //           padding: EdgeInsets.only(left: 3),
                            //       //           child: TextField(
                            //       //
                            //       //             maxLines: 5,
                            //       //             style: TextStyle(
                            //       //                 overflow: TextOverflow.ellipsis,
                            //       //
                            //       //                 color: Theme.of(context).hoverColor,
                            //       //                 fontSize: 14),
                            //       //             cursorColor: Theme.of(context).hoverColor,
                            //       //             controller: toComment,
                            //       //
                            //       //             // onSubmitted: (String str) {
                            //       //             //   getHomeTabService().postComment(cmt: str);
                            //       //             //   toComment.clear();
                            //       //             //   setState(() {
                            //       //             //     toComment;
                            //       //             //   });
                            //       //             // },
                            //       //             // textInputAction: TextInputAction.go,
                            //       //
                            //       //             decoration: InputDecoration(
                            //       //                 contentPadding: EdgeInsets.zero,
                            //       //                 isDense: true,
                            //       //                 enabledBorder: InputBorder.none,
                            //       //                 focusedBorder: InputBorder.none,
                            //       //                 disabledBorder: InputBorder.none,
                            //       //                 border: InputBorder.none,
                            //       //                 hintText: "Reply (Comment)",
                            //       //                 hintStyle: TextStyle(
                            //       //                     color: Theme.of(context).hoverColor
                            //       //                         .withOpacity(0.5),
                            //       //                     fontSize: 12)),
                            //       //           ),
                            //       //         ),
                            //       //       ),
                            //       //
                            //       //       // Expanded(
                            //       //       //   child: Row(
                            //       //       //     mainAxisAlignment: MainAxisAlignment
                            //       //       //         .end,
                            //       //       //     children: [
                            //       //       //       Padding(
                            //       //       //         padding: const EdgeInsets.only(
                            //       //       //             right: 0.0),
                            //       //       //         child: InkWell(
                            //       //       //           // onTap: (() async {
                            //       //       //           //   await  getHomeTabService().postComment(
                            //       //       //           //       postId:_homeData!.postList[i].id);
                            //       //       //           //       toComment.clear();
                            //       //       //           //
                            //       //       //           //
                            //       //       //           // }),
                            //       //       //
                            //       //       //
                            //       //       //             child: Image.asset(
                            //       //       //                 'asset/images/mic.png')),
                            //       //       //       ),
                            //       //       //       OutlinedButton(
                            //       //       //         child: Text('POST'),
                            //       //       //
                            //       //       //         style: OutlinedButton.styleFrom(
                            //       //       //
                            //       //       //           primary: Theme.of(context).hoverColor,
                            //       //       //         ),
                            //       //       //         onPressed: () async {
                            //       //       //           newsettoken(
                            //       //       //               _homeData!.postList[i].id);
                            //       //       //           setimageurl(_homeData!.postList[i]
                            //       //       //               .backgroundImage);
                            //       //       //
                            //       //       //           await getHomeTabService()
                            //       //       //               .postComment(
                            //       //       //               postId: _homeData!.postList[i]
                            //       //       //                   .id,context: context);
                            //       //       //
                            //       //       //           if (toComment.text
                            //       //       //               .toString()
                            //       //       //               .isEmpty) {
                            //       //       //
                            //       //       //           } else {
                            //       //       //             toComment.clear();
                            //       //       //             Navigator.push(
                            //       //       //               context,
                            //       //       //               MaterialPageRoute(builder: (
                            //       //       //                   context) => const CommentListPage()),
                            //       //       //
                            //       //       //             );
                            //       //       //           }
                            //       //       //         },
                            //       //       //       ),
                            //       //       //
                            //       //       //     ],
                            //       //       //   ),
                            //       //       // ),
                            //       //
                            //       //
                            //       //     ],
                            //       //   ),
                            //       // ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              height: 10,
                              color: Color(0xff575757),
                            ),
                          ],
                        );

             },
                  );
           }
         )



                ),

    );
  }
  Future gettokenuserid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();
  //  print(userId);
    setState(() {
      newuserid=userId;
    });
    print("new user id is $newuserid");
  }
  String mainpic="";
  Future getphotoscreen()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cc=  prefs.getString("mainpagepic").toString();
    setState(() {
      mainpic=cc;
    });
    print("the image is $mainpic");


  }


  String newuserid="";
  bool checked=false;


  Future<void> newpostid(uid)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('postuserid', uid);
  }


  Future<void> newsettoken(token)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('post_id', token);
  }Future<void> picset(token)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('picset', token);
  }

  Future<void> setimageurl(token)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('image_url', token);
  }
  // Future postbookmark({required String id,required String postid})async{
  //   try{
  //   var body={
  //     "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
  //     "ID": "$id",
  //     "POST_ID": "$postid"
  //   };
  //   var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/bookmark"),body: body,
  //
  //   );
  //   if(response.statusCode==200) {
  //     print(response.body);
  //     bookmarkModel = bookmarkModelFromJson(response.body);
  //     setState(() {
  //       bookmarkmessage = bookmarkModel!.message.toString();
  //       if(bookmarkmessage.contains("Marked successfully!")){
  //         bookmarkmessage=="Marked successfully!";
  //         print("theeee $bookmarkmessage");
  //         colored==true;
  //       }
  //       else{
  //         colored==false;
  //       }
  //     });
  //   }
  //   }catch(e){
  //     print(e.toString());
  //   }
  //
  //   }


  void resetAnimation() {
    animation=Matrix4Tween(
      begin: transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    animationController.forward(from: 0);
  }
  String reportmessage="";
  String blockmessage="";
  Future reportlist({required String reportid})async{
    var body={
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "UID": "$reportid",
      "LUID": "$newuserid"
    };
    var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/report"),body:body );

    if(response.statusCode==200){
      print(response.body);
      reportModel=reportModelFromJson(response.body);
      setState(() {
       reportmessage=reportModel!.message.toString();
      });


    }
  }
  Future blocklist({required String blockid})async{
    var body={
      "APP_KEY":"SpTka6TdghfvhdwrTsXl28P1",
      "UID":"$blockid",
      "LUID":"$newuserid"
    };
    var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/block"),body:body);
    if(response.statusCode==200){
      blockmodel=blockModelFromJson(response.body);
      setState(() {
        print(response.body);
        blockmessage=blockmodel!.message.toString();
        print("the block msg is $blockmessage");
      });
    }
  }

  // Widget buildSheet(int index) => Container(
  //   height: 200,
  //   child: Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 22, left: 19),
  //         child: Row(
  //           children: [
  //             Container(
  //                 height: 40,
  //                 width: 130,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20),
  //                   border: Border.all(
  //                     width: 3,
  //                     color: Color(0xff818181),
  //                     style: BorderStyle.solid,
  //                   ),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.share_outlined,
  //                       color: Theme.of(context).hoverColor,
  //                     ),
  //                     SizedBox(width: 10),
  //                     Text(
  //                       'Share',
  //                       style: TextStyle(color: Theme.of(context).hoverColor),
  //                     )
  //                   ],
  //                 )),
  //           ],
  //         ),
  //       ),
  //       SizedBox(
  //         height: 20,
  //       ),
  //       Divider(
  //         height: 10,
  //         color: Color(0xff808080),
  //       ),
  //       GestureDetector(
  //         onTap: ()async{
  //         await reportlist(reportid: "${_homeData!.postList[index].id}");
  //         Fluttertoast.showToast(msg:reportmessage );
  //         Navigator.pop(context);
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 20, left: 20),
  //           child: Row(
  //             children: [
  //               Text(
  //                 'Report',
  //                 style: TextStyle(color: Theme.of(context).hoverColor),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 13,
  //       ),
  //       Divider(
  //         height: 15,
  //         color: Color(0xff808080),
  //       ),
  //       GestureDetector(
  //         onTap: ()async{
  //           await blocklist(blockid:"${_homeData!.postList[index].id}");
  //           Fluttertoast.showToast(msg: blockmessage);
  //           Navigator.pop(context);
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 14, left: 20),
  //           child: Row(
  //             children: [
  //               Text(
  //                 'Block',
  //                 style: TextStyle(color: Theme.of(context).hoverColor),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // );
}



class getHomeTabService {



  Future postComment({required String postId,required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();
    print(userId);

    try {
      print("trying to Comment");

      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.commentEndPoint);

      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Cookie':
                'connect.sid=s%3AtVnLmITSn_zletRj2nMA2yCjWafW69aY.vufwo%2Fh45zhYEp06x9RKcV0mhk2DkYDZ1twbPiJRp5Y'
          },
          body: json.encode({
            "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
            "ID": userId,
            "POST_ID": postId,
            "COMMENT": toComment.text,
            "TYPE": "Text"
          }));
      print(response.statusCode);
      print(response.body);
      var toastVal = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("---------- Commented Successfully -------------");
        Fluttertoast.showToast(
            msg: toastVal['MESSAGE'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).hoverColor.withOpacity(0.8),
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } catch (e) {
      log(e.toString());
    }
  }

}

class ApiConstants {
  static String baseUrl = 'http://3.227.35.5:3001/api/user/';
  static String homeEndPoint = 'home';
  static String likeEndPoint = 'like';
  static String commentEndPoint = 'comment';
}
class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child:imageUrl==null?Container(): PhotoView(
          enableRotation: true,

            imageProvider: NetworkImage(imageUrl,)),
      ),
    );
  }
}