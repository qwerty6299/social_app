// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
//
// import 'package:flutter/material.dart';
// import 'package:socialapp/commentscreen.dart';
//
// import 'chatfirebase/models/UserModel.dart';
//
// class CommentReply extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;
//
//   CommentReply({Key? key,required this.userModel, required this.firebaseUser}) : super(key: key);
//
//   @override
//   State<CommentReply> createState() => _CommentReplyState();
// }
//
// class _CommentReplyState extends State<CommentReply> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Color(0xff161730),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Color(0xff161730),
//         title: Text(
//           'Comments',
//           style: TextStyle(
//               fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.only(top: 30, left: 14.87, right: 14.87),
//               child: Container(
//                   height: 120,
//                   width: size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Color(0xff171723)),
//                   child: Column(children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 7, left: 10),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               'asset/images/becca.png',
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 50,
//                           ),
//                           Text(
//                             'becca_tapert',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           SizedBox(
//                             width: size.width / 2,
//                           ),
//                           Text(
//                             '2d',
//                             style: TextStyle(color: Color(0xffA4A4A4)),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 45, top: 10),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.play_arrow,
//                             color: Colors.blue,
//                             size: 22,
//                           ),
//                           Image.asset('asset/images/recording.png'),
//                           SizedBox(
//                             width: size.width / 3,
//                           ),
//                           Icon(
//                             Icons.favorite_border,
//                             size: 20,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: size.width / 60,
//                           ),
//                           Text(
//                             '13 Likes',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 45),
//                       child: Row(
//                         children: [
//                           Text(
//                             'View Replies',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CommentScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
//                             },
//                             child: Text(
//                               'Reply',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           Text(
//                             'Share',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                   ])),
//             ),
//             Divider(
//               height: 1,
//               color: Color(0xff393939),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 14.87, right: 14.87),
//               child: Container(
//                   height: 120,
//                   width: size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Color(0xff171723)),
//                   child: Column(children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 7, left: 10),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               'asset/images/becca.png',
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 50,
//                           ),
//                           Text(
//                             'becca_tapert',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           SizedBox(
//                             width: size.width / 2,
//                           ),
//                           Text(
//                             '2d',
//                             style: TextStyle(color: Color(0xffA4A4A4)),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 45, top: 10),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.play_arrow,
//                             color: Colors.blue,
//                             size: 22,
//                           ),
//                           Image.asset('asset/images/recording.png'),
//                           SizedBox(
//                             width: size.width / 3,
//                           ),
//                           Icon(
//                             Icons.favorite_border,
//                             size: 20,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: size.width / 60,
//                           ),
//                           Text(
//                             '13 Likes',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 45),
//                       child: Row(
//                         children: [
//                           Text(
//                             'View2Replies',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CommentScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
//                             },
//                             child: Text(
//                               'Reply',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           Text(
//                             'Share',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                   ])),
//             ),
//             Divider(
//               height: 1,
//               color: Color(0xff393939),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 14.87, right: 14.87),
//               child: Container(
//                   height: 120,
//                   width: size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Color(0xff171723)),
//                   child: Column(children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 7, left: 10),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               'asset/images/becca.png',
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 50,
//                           ),
//                           Text(
//                             'becca_tapert',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           SizedBox(
//                             width: size.width / 2,
//                           ),
//                           Text(
//                             '2d',
//                             style: TextStyle(color: Color(0xffA4A4A4)),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 45, top: 10),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.play_arrow,
//                             color: Colors.blue,
//                             size: 22,
//                           ),
//                           Image.asset('asset/images/recording.png'),
//                           SizedBox(
//                             width: size.width / 3,
//                           ),
//                           Icon(
//                             Icons.favorite_border,
//                             size: 20,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: size.width / 60,
//                           ),
//                           Text(
//                             '13 Likes',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 45),
//                       child: Row(
//                         children: [
//                           Text(
//                             'View2Replies',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CommentScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
//                             },
//                             child: Text(
//                               'Reply',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           Text(
//                             'Share',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                   ])),
//             ),
//             Divider(
//               height: 1,
//               color: Color(0xff393939),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 14.87, right: 14.87),
//               child: Container(
//                   height: 120,
//                   width: size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Color(0xff171723)),
//                   child: Column(children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 7, left: 10),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               'asset/images/becca.png',
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 50,
//                           ),
//                           Text(
//                             'becca_tapert',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           SizedBox(
//                             width: size.width / 2,
//                           ),
//                           Text(
//                             '2d',
//                             style: TextStyle(color: Color(0xffA4A4A4)),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 45, top: 10),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.play_arrow,
//                             color: Colors.blue,
//                             size: 22,
//                           ),
//                           Image.asset('asset/images/recording.png'),
//                           SizedBox(
//                             width: size.width / 3,
//                           ),
//                           Icon(
//                             Icons.favorite_border,
//                             size: 20,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: size.width / 60,
//                           ),
//                           Text(
//                             '13 Likes',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 45),
//                       child: Row(
//                         children: [
//                           Text(
//                             'View2Replies',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CommentScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
//                             },
//                             child: Text(
//                               'Reply',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           Text(
//                             'Share',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                   ])),
//             ),
//             Divider(
//               height: 1,
//               color: Color(0xff393939),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 14.87, right: 14.87),
//               child: Container(
//                   height: 120,
//                   width: size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Color(0xff171723)),
//                   child: Column(children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 7, left: 10),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               'asset/images/becca.png',
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 50,
//                           ),
//                           Text(
//                             'becca_tapert',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           SizedBox(
//                             width: size.width / 2,
//                           ),
//                           Text(
//                             '2d',
//                             style: TextStyle(color: Color(0xffA4A4A4)),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 45, top: 10),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.play_arrow,
//                             color: Colors.blue,
//                             size: 22,
//                           ),
//                           Image.asset('asset/images/recording.png'),
//                           SizedBox(
//                             width: size.width / 3,
//                           ),
//                           Icon(
//                             Icons.favorite_border,
//                             size: 20,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: size.width / 60,
//                           ),
//                           Text(
//                             '13 Likes',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 45),
//                       child: Row(
//                         children: [
//                           Text(
//                             'View2Replies',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CommentScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
//                             },
//                             child: Text(
//                               'Reply',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           Text(
//                             'Share',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                   ])),
//             ),
//             Divider(
//               height: 1,
//               color: Color(0xff393939),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 14.87, right: 14.87),
//               child: Container(
//                   height: 120,
//                   width: size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Color(0xff171723)),
//                   child: Column(children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 7, left: 10),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               'asset/images/becca.png',
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 50,
//                           ),
//                           Text(
//                             'becca_tapert',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           SizedBox(
//                             width: size.width / 2,
//                           ),
//                           Text(
//                             '2d',
//                             style: TextStyle(color: Color(0xffA4A4A4)),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 45, top: 10),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.play_arrow,
//                             color: Colors.blue,
//                             size: 22,
//                           ),
//                           Image.asset('asset/images/recording.png'),
//                           SizedBox(
//                             width: size.width / 3,
//                           ),
//                           Icon(
//                             Icons.favorite_border,
//                             size: 20,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: size.width / 60,
//                           ),
//                           Text(
//                             '13 Likes',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 45),
//                       child: Row(
//                         children: [
//                           Text(
//                             'View2Replies',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CommentScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
//                             },
//                             child: Text(
//                               'Reply',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 10,
//                           ),
//                           Text(
//                             'Share',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                           )
//                         ],
//                       ),
//                     ),
//                   ])),
//             ),
//             SizedBox(
//               height: 50,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Future getCommentReply({required String postId}) async {
//     try {
//       print("trying to Comment");
//
//      var headers = {
//   'Content-Type': 'application/json',
//   'Cookie': 'connect.sid=s%3A19wAgGHYcMTZgmO4XBvp9dDvts9HI-Am.5V9HR5iwVlnLAaoczyFGnpS8ctJRVWosMLhbVgaT7og'
// };
// var request = http.Request('GET', Uri.parse('http://3.227.35.5:3001/api/user/comment-reply-list'));
// request.body = json.encode({
//   "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
//   "COMMENT_ID": "62bd7e17fe00670c03da421b"
// });
// request.headers.addAll(headers);
//
// http.StreamedResponse response = await request.send();
//
// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }
//
//
//       }
//      catch (e) {
//       log(e.toString());
//     }
//   }
//