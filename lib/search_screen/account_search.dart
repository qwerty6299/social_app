import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/peoplefellow.dart';
import 'package:http/http.dart' as http;

import '../model/search_trending_model.dart';

class AccountSearch extends StatefulWidget {
  AccountSearch({Key? key}) : super(key: key);

  @override
  State<AccountSearch> createState() => _AccountSearchState();
}

class _AccountSearchState extends State<AccountSearch> {
  SearchtrendingModel? searchtrendingModel;
  List<Dat> dat=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchaccount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff161730),
      body: GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => PeopleFollow()));
        },
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: 20,
                ),
            itemCount: dat.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child:ClipRRect(


                        child: CachedNetworkImage(imageUrl:"${dat[index].profilePic}",
                          width: 30,
                          height: 80,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                          errorWidget: (context, url, error) => new Icon(Icons.person),
                        )),
                  ),
                  Text(
                    '${dat[index].firstName}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${dat[index].lastName}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              );

            }),
      ),
    );
  }
  String username="";
  String first_name="";
  String last_name="";
  String profile_pic="";
  String id="";
  void searchaccount() async{
    var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/finder"),body: {
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "search_data":"vik"
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
      id=searchtrendingModel!.dat[i].id.toString();
      dat.add(Dat(username: username, firstName: first_name, lastName: last_name, profilePic: profile_pic,id: id));
    }


      });
    }
  }
}
