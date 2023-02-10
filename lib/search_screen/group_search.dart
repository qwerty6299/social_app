import 'package:flutter/material.dart';
import 'package:socialapp/search_screen/search_tab.dart';
import 'package:http/http.dart' as http;
import '../model/search_trending_model.dart';

class GroupSearch extends StatefulWidget {
  GroupSearch({Key? key}) : super(key: key);

  @override
  State<GroupSearch> createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  SearchtrendingModel? searchtrendingModel;
  List<Group> groups=[];
  String url="";
  String name="";
  void group() async {
    var response = await http.post(
        Uri.parse("http://3.227.35.5:3001/api/user/finder"), body: {
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "search_data": ""
    });
    if (response.statusCode == 200) {
      print(response.body);
      searchtrendingModel = searchtrendingModelFromJson(response.body);
      setState(() {
        for (int i = 0; i < searchtrendingModel!.groups.length; i++) {
          url=searchtrendingModel!.groups[i].url.toString();
          name=searchtrendingModel!.groups[i].name.toString();
          groups.add(Group(url: url, name: name));

        }
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    group();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff161730),
      body: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
                height: 20,
              ),
          itemCount: groups.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'asset/images/profile.png',
                  fit: BoxFit.fill,
                ),
              ),
              title: Text(
                '${searchtrendingModel!.groups[index].name}',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '${searchtrendingModel!.groups[index].desc}',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Container(
                height: 40,
                width: size.width / 4,
                decoration: BoxDecoration(
                    color: Color(0xff950E00),
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(
                    'Request',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
