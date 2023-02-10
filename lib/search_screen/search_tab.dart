import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/search_screen/treanding_search.dart';
import 'package:socialapp/search_screen/account_search.dart';
import 'package:socialapp/search_screen/group_search.dart';
import 'package:socialapp/search_screen/echo_search.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../audioManager.dart';
import '../chatfirebase/models/UserModel.dart';
import '../model/search_trending_model.dart';
import '../post_fetch_profile/fetch_profile.dart';
import '../profile_tab/privateechopagemanager.dart';

class SearchTab extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  SearchTab({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> with SingleTickerProviderStateMixin {
  TextEditingController controller = new TextEditingController();
  SearchtrendingModel? searchtrendingModel;
  String username="";
  String first_name="";
  String last_name="";
  String profile_pic="";
  String bgimage="";
  String audio="";
  String trendingid="";
  void searchaccount() async{
    var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/finder"),body: {
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "search_data":controller.text.toString().isEmpty?"":"${controller.text.toString()}"
    });
    if(response.statusCode==200){
      print(response.body);
      searchtrendingModel=searchtrendingModelFromJson(response.body);
      setState(() {
        for(int i=0;i<searchtrendingModel!.dat.length;i++){
          username=searchtrendingModel!.dat[i].username.toString();
          first_name=searchtrendingModel!.dat[i].firstName.toString();
          last_name=searchtrendingModel!.dat[i].lastName.toString();
          profile_pic=searchtrendingModel!.dat[i].profilePic.toString();
          trendingid=searchtrendingModel!.dat[i].id.toString();
          _cities.add(Dat(username: username, firstName: first_name, lastName: last_name, profilePic: profile_pic,id: trendingid));
        }

        for(int i=0;i<searchtrendingModel!.echos.length;i++){
          bgimage=searchtrendingModel!.echos[i].backgroundImage.toString();
          audio=searchtrendingModel!.echos[i].audio.toString();

          echos.add(Echo(backgroundImage: bgimage,audio: audio));
        }
      });
    }
  }

Future settrendingpersonid(String iddd)async{
    final preferences= await SharedPreferences.getInstance();
    preferences.setString("postuserid", iddd);

}

  List<Dat> _cities=[];
  List<Echo> echos=[];
  late PageManager _pageManager;
  @override
  void dispose() {
 controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    searchaccount();

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff161730),
        appBar: AppBar(
          backgroundColor: Color(0xff161730),
          elevation: 0,
          title: Center(
            child: Container(
              margin: EdgeInsets.only(left: 16.0,top: 16.0,bottom: 16.0),
              height: 50,
              width: size.width / 1.3,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff4F4F4F)),
                borderRadius: BorderRadius.circular(13),
              ),
              child:TextField(
                style: TextStyle(color: Colors.white), //
                controller:controller ,
                onChanged: search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'search by..',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey
                    )
                  )
                ),
              )
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tabSection(context),
            ],
          ),
        ));
  }
  void search(String query){
    final suggestions=_cities.where((element) {
       final booktitle=element.lastName.toLowerCase();
       final bookfirst=element.firstName.toLowerCase();
       final input=query.toLowerCase();
        return booktitle.contains(input) || bookfirst.contains(input);
    }).toList();

    setState(() {
       _cities=suggestions;
    });


  }

// border for all 3 colors
  final kGradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(

        colors: [Color.fromRGBO(92, 97, 231, 1), Color.fromRGBO(235, 73, 56, 1)]),

    borderRadius: BorderRadius.circular(32),
  );

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // width: 2.w,
            child: TabBar(
                indicatorColor: Colors.white,
                isScrollable: false,
                labelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                unselectedLabelColor: Colors.white38,
                tabs: [
                  Tab(
                    text: "Account",
                  ),
                  Tab(text: "Echo"),
                  Tab(text: "Groups"),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: 20,
                        ),
                        itemCount: _cities.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap:(){
                                  settrendingpersonid(_cities[index].id);
                                  print("the id for cities is ${_cities[index].id}");
                                  Get.to(fetchprofile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,));
                                },
                                child: Row(
                                  children: [
                                    ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl:"${_cities[index].profilePic}",

                            imageBuilder: (context, imageProvider) =>
                          Container(
                                decoration: kGradientBoxDecoration,
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child:ClipOval(
                          clipBehavior: Clip.antiAlias,
                            child:
                            Container(
                           width: 70.0,
                           height: 70.0,
                           decoration: BoxDecoration(
                          // border: Border(
                          //     top: BorderSide(
                          //         color: Colors.red,
                          //         width: 8
                          //     )
                          // ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                           ),
                            ),

                          )
                          )

                          ),
                            placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                  Container(
                                    decoration: kGradientBoxDecoration,
                                    child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child:ClipOval(
                                          clipBehavior: Clip.antiAlias,
                                          child:     Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,

                                              image: DecorationImage(
                                                  image: AssetImage("asset/images/dummyimage-removebg-preview.png"), fit: BoxFit.contain),
                                            ),
                                          ),


                                        )
                                    )

                                  ),

                          ),
                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            '${_cities[index].firstName}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${_cities[index].lastName}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              )



                            ],
                          );

                        }),
                  ),
                  SingleChildScrollView(
                    child: Container(
                        child: searchtrendingModel == null
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : GridView.builder(
                            itemCount: echos.length,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              crossAxisCount: 3,
                            ), itemBuilder:(BuildContext context, int index){
                          _pageManager = PageManager(audioUrl:searchtrendingModel!.echos[index].audio);
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: searchtrendingModel!.echos[index].backgroundImage!=""?ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child:CachedNetworkImage (imageUrl:searchtrendingModel!.echos[index].backgroundImage,
                                    width: 125,height: 125,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => new Container(),
                                    errorWidget: (context, url, error) => new Icon(Icons.person),),
                                ):Container(),
                              ),
                              Positioned.fill(


                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.center,
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        Privateechoprivatemanager(url:searchtrendingModel!.echos[index].audio,),

                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${searchtrendingModel!.echos[index].title}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,style: TextStyle(
                                              color: Colors.white,fontSize: 12
                                            ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              // Align(
                              //     alignment: Alignment.center,
                              //     child: ValueListenableBuilder<ButtonState>(
                              //       valueListenable: _pageManager.buttonNotifier,
                              //
                              //       builder: (_, value, __) {
                              //
                              //     switch (value) {
                              //       case ButtonState.paused:
                              //         return IconButton(
                              //             icon: const Icon(
                              //               Icons.play_arrow,
                              //               color: Colors.redAccent,
                              //             ),
                              //             iconSize: 32.0,
                              //             onPressed:
                              //             _pageManager.play
                              //
                              //
                              //         );
                              //       case ButtonState.playing:
                              //        return IconButton(
                              //             icon: const Icon(
                              //               Icons.pause,
                              //               color: Colors.redAccent,
                              //             ),
                              //             iconSize: 32.0,
                              //             onPressed:
                              //             _pageManager.pause
                              //
                              //
                              //         );
                              //
                              //     }
                              //     return Text('');
                              //
                              //         // switch (value) {
                              //         //   case ButtonState.loading:
                              //         //     return Container(
                              //         //       margin: const EdgeInsets.all(8.0),
                              //         //       width: 32.0,
                              //         //       height: 32.0,
                              //         //       child: const CircularProgressIndicator(
                              //         //         color: Colors.redAccent,
                              //         //       ),
                              //         //     );
                              //         //   case ButtonState.paused:
                              //         //     return IconButton(
                              //         //       icon: const Icon(
                              //         //         Icons.play_arrow,
                              //         //         color: Colors.redAccent,
                              //         //       ),
                              //         //       iconSize: 32.0,
                              //         //       onPressed:_pageManager.play,
                              //         //     );
                              //         //   case ButtonState.playing:
                              //         //     return IconButton(
                              //         //       icon: const Icon(
                              //         //         Icons.pause,
                              //         //         color: Colors.redAccent,
                              //         //       ),
                              //         //       iconSize: 32.0,
                              //         //       onPressed: _pageManager.pause,
                              //         //     );
                              //         // }
                              //       },
                              //     )),
                            ],
                          ) ;
                        }

                        )


                    ),
                  ),
                  // EchoSearch(),
                  GroupSearch()]),
          ),
        ],
      ),
    );
  }
}
