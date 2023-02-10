import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/audioManager.dart';
import 'package:socialapp/homepage.dart';
import 'package:socialapp/model/trendingsearchmodel.dart';
import 'package:socialapp/peoplefellow.dart';
import 'package:socialapp/post_fetch_profile/fetch_profile.dart';
import 'package:socialapp/search_screen/search_tab.dart';
import 'package:get/get.dart';

import '../chatfirebase/models/UserModel.dart';

class TreandingSearch extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  TreandingSearch({Key? key,required this.userModel,required this.firebaseUser}) : super(key: key);

  @override
  State<TreandingSearch> createState() => _TreandingSearchState();
}

class _TreandingSearchState extends State<TreandingSearch> {
  TrendingSearchModel? profileDataa;
  late PageManager _pageManager;

  void initState() {
    _getData();

    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  Future _getData() async {
    profileDataa = (await getProfileServicee().getProfilee());

    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.black,
      //   onPressed: () {},
      //   child: Image.asset(
      //     'asset/images/floating.png',
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   color: Color(0xff262626),
      //   shape: CircularNotchedRectangle(),
      //   notchMargin: 5,
      //   child: Container(
      //     height: 60,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             MaterialButton(
      //               onPressed: () {},
      //               minWidth: 40,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(
      //                     Icons.home_outlined,
      //                     color: Colors.white,
      //                   )
      //                 ],
      //               ),
      //             ),
      //             MaterialButton(
      //               onPressed: () {},
      //               minWidth: 40,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(
      //                     Icons.dashboard,
      //                     color: Colors.white,
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             MaterialButton(
      //               onPressed: () {},
      //               minWidth: 40,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(
      //                     Icons.chat,
      //                     color: Colors.white,
      //                   )
      //                 ],
      //               ),
      //             ),
      //             MaterialButton(
      //               onPressed: () {},
      //               minWidth: 40,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(
      //                     Icons.person,
      //                     color: Colors.white,
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ],
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        leading: ExpandTapWidget(
            onTap: () {
              Navigator.of(context).pop();
            },
            tapPadding: EdgeInsets.all(6.0),
            child: Icon(Icons.arrow_back_ios,color: Theme.of(context).hoverColor)),
        elevation: 0,
        title: Center(
          child: InkWell(
            //  onTap:() {
            // Get.to(() => SearchTabScreen());
            // },
            child: Container(
              height: 50,
              width: size.width / 1.3,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff4F4F4F)),
                borderRadius: BorderRadius.circular(13),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchTab(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Center(
                        child: Text(
                          "Search(number)",
                          style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 14),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Trending Accounts",
                        style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  profileDataa == null
                      ? SizedBox()
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: StaggeredGridView.countBuilder(
                        staggeredTileBuilder: (index) =>
                index==2? StaggeredTile.count(1,2): StaggeredTile.count(1,1), //cross axis cell count

                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount:
                        profileDataa!.data[0].trndingAccounts!.length,

                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          crossAxisCount: 3,


                        itemBuilder: (BuildContext context, int index) {
                          print(  "12345678${profileDataa!.data[0].trndingAccounts!.length}",);

                          return profileDataa == null ||
                              profileDataa!
                                  .data[0].trndingAccounts!.isEmpty
                              ? Center(
                            heightFactor: 14,
                            child: CircularProgressIndicator(),
                          )
                              : Padding(
                            padding:
                            const EdgeInsets.only(left: 0.0),
                            child: GestureDetector(
                              onTap: () {
                                print("the postid is ${profileDataa!.data[0]
                                    .trndingAccounts![index].id}");
                                newpostid(profileDataa!.data[0]
                                    .trndingAccounts![index].id);
                               Get.to(() => fetchprofile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,));
                              },
                              child: Stack(children: [
                                Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width /
                                      3,
                                  height: 300,
                                  child: CachedNetworkImage(
                                    imageUrl: profileDataa!
                                        .data[0]
                                        .trndingAccounts![index]
                                        .image,

                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Center(
                                            child:
                                            new CircularProgressIndicator()),
                                    errorWidget:
                                        (context, url, error) =>
                                    new Icon(Icons.error),
                                  ),
                                ),

                                Positioned.fill(
                                  child: Align(
                                      alignment:
                                      Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 6.0),
                                        child: Text(
                                          profileDataa!
                                              .data[0]
                                              .trndingAccounts![index]
                                              .name,
                                          style: TextStyle(
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      )),
                                ),

                                // Positioned(
                                //     bottom: 20,
                                //     left: 40,
                                //     child: Text(
                                //       _profileData!.data.posts[index].category
                                //           .toString(),
                                //       style: TextStyle(
                                //           fontSize: 12,
                                //           fontWeight: FontWeight.w400,
                                //           color: Colors.white54),
                                //     )),
                              ]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Echoes(Recordings)",
                        style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  profileDataa == null
                      ? SizedBox()
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: profileDataa!.data[1].echoes!.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        print(index);

                        return profileDataa == null ||
                            profileDataa!.data[1].echoes!.isEmpty
                            ? Center(
                          heightFactor: 14,
                          child: CircularProgressIndicator(),
                        )
                            : Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Stack(children: [
                            Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3,
                              child: CachedNetworkImage(
                                imageUrl: profileDataa!
                                    .data[1].echoes![index].image,
                                height: 200,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child:
                                    new CircularProgressIndicator()),
                                errorWidget:
                                    (context, url, error) =>
                                new Icon(Icons.error),
                              ),
                            ),

                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(bottom: 6.0),
                                  child: Text(
                                    profileDataa!.data[1]
                                        .echoes![index].name,
                                    style: TextStyle(
                                        overflow:
                                        TextOverflow.ellipsis,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                )),

                            // Positioned(
                            //     bottom: 20,
                            //     left: 40,
                            //     child: Text(
                            //       _profileData!.data.posts[index].category
                            //           .toString(),
                            //       style: TextStyle(
                            //           fontSize: 12,
                            //           fontWeight: FontWeight.w400,
                            //           color: Colors.white54),
                            //     )),
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Trending Groups",
                        style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  profileDataa == null
                      ? SizedBox()
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                      profileDataa!.data[2].trendingGroup!.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        print(index);

                        return profileDataa == null ||
                            profileDataa!
                                .data[2].trendingGroup!.isEmpty
                            ? Center(
                          heightFactor: 14,
                          child: CircularProgressIndicator(),
                        )
                            : Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Stack(children: [
                            Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3,
                              child: CachedNetworkImage(
                                imageUrl: profileDataa!.data[2]
                                    .trendingGroup![index].image,
                                height: 200,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child:
                                    new CircularProgressIndicator()),
                                errorWidget:
                                    (context, url, error) =>
                                new Icon(Icons.error),
                              ),
                            ),

                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(bottom: 6.0),
                                  child: Text(
                                    profileDataa!.data[2]
                                        .trendingGroup![index].name,
                                    style: TextStyle(
                                        overflow:
                                        TextOverflow.ellipsis,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                )),

                            // Positioned(
                            //     bottom: 20,
                            //     left: 40,
                            //     child: Text(
                            //       _profileData!.data.posts[index].category
                            //           .toString(),
                            //       style: TextStyle(
                            //           fontSize: 12,
                            //           fontWeight: FontWeight.w400,
                            //           color: Colors.white54),
                            //     )),
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class getProfileServicee {
// Future<TrendingSearchModel> getProfilee() async {
//     var headers = {
//   'Content-Type': 'application/json',
//   'Cookie': 'connect.sid=s%3AkcMvnr-cKWkGD9oZ5Y1JEY8oict_IALv.pHtzwc%2Fyoq00tDq5A8Vl1oIhdBXViW%2F2wfw%2B%2BxdSWDA'
// };
// var request = http.Request('POST', Uri.parse('http://3.227.35.5:3001/api/user/trendings'));
// request.body = json.encode({
//   "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1"
// });
// request.headers.addAll(headers);

// http.StreamedResponse response = await request.send();

//  if (response.statusCode == 200) {
//       TrendingSearchModel _model = trendingSearchModelFromJson(request.body);
//         return _model;
//   print(await response.stream.bytesToString());
//       print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
//       return TrendingSearchModel.fromJson(
//           jsonDecode(await response.stream.bytesToString()));
//     } else {

//       print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
//       print(response.reasonPhrase);
//       return TrendingSearchModel.fromJson(
//           jsonDecode(await response.stream.bytesToString()));
//     }

// }
// }

class getProfileServicee {
  Future<TrendingSearchModel>? getProfilee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();
    print("private screen uid is $userId");

    try {
      print("trying to Profile");

      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndPoint);

      var response = await http.post(url,

          body: json.encode({"APP_KEY": "SpTka6TdghfvhdwrTsXl28P1"}));
      // print(response.statusCode);

      if (response.statusCode == 200) {
        print("---------- Success -----------");
        print(response.body);

        TrendingSearchModel _model = trendingSearchModelFromJson(response.body);
        return _model;
        // final _model = jsonDecode(response.body).cast<Map<String,dynamic>>();
        // return _model.map<TrendingSearchModel>((json)=> Datum.fromJson(json)).toList();
      } else {
        throw Text("");
      }
    } catch (e) {
      log(e.toString());
    }

    throw Text("knjbhgh");
  }
}

class ApiConstants {
  static String baseUrl = 'http://3.227.35.5:3001/api/user/';
  static String profileEndPoint = 'trendings';
}

Future<void> newpostid(uid) async {
  final SharedPreferences tokensharedpreferences =
  await SharedPreferences.getInstance();
  tokensharedpreferences.setString('postuserid', uid);
}
