import 'package:flutter/material.dart';
import 'package:socialapp/profile_follow/echoes.dart';
import 'package:socialapp/profile_follow/photos.dart';
import 'package:socialapp/search_screen/account_search.dart';

class PeopleFollow extends StatefulWidget {
  PeopleFollow({Key? key}) : super(key: key);

  @override
  State<PeopleFollow> createState() => _PeopleFollowState();
}

class _PeopleFollowState extends State<PeopleFollow> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff262626),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 284,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xff1D1D1D)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.asset(
                                    'asset/images/debrawood.png',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: size.width / 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sarah Noltner',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Actor / Flim / Music',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white38),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Lorem ipsum dolor sit amet, conse',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white38),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'tetur adipising elit.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white38),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'www.jacksonalex.com',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: size.width / 12,
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                      backgroundColor: Color(0xff4E4E4E),
                                      context: context,
                                      builder: (context) => buildSheet(),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)))),
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 23, left: 26),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '233',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'Post',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width / 6,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Text(
                                      '425k',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: size.width / 6,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '584',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Row(
                            children: [
                              Container(
                                height: 35,
                                width: size.width / 3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xffEB4938)),
                                child: Center(
                                  child: Text(
                                    'Follow',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width / 22,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 35,
                                  width: size.width / 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white),
                                      color: Color(0xff262626)),
                                  child: Center(
                                    child: Text(
                                      'Message',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _tabSection(context),
          ],
        ),
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // width: 2.w,
            child: TabBar(
                indicatorColor: Colors.white,
                isScrollable: true,
                labelStyle:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                unselectedLabelColor: Colors.white38,
                tabs: [
                  Tab(
                    text: " Echoes",
                  ),
                  Tab(text: " Photos"),
                ]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [Echoes(), Photos()]),
          ),
        ],
      ),
    );
  }

  Widget buildSheet() => Container(
        height: 250,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22, left: 19),
              child: Row(
                children: [
                  Container(
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 3,
                          color: Color(0xff818181),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Share',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                ],
              ),
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
                    'Copy profile url',
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
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    'Report',
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
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 20),
              child: Row(
                children: [
                  Text(
                    'Block',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      );
}
