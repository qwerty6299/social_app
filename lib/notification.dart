import 'package:flutter/material.dart';

class Notification2 extends StatefulWidget {
  Notification2({Key? key}) : super(key: key);

  @override
  State<Notification2> createState() => _Notification2State();
}

class _Notification2State extends State<Notification2> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff161730),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff161730),
          title: Text(
            'Notifications',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        body: Center(
          child: Text('No Notification Found',style: TextStyle(
            color: Colors.white
          ),),
        ),
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding:
        //             const EdgeInsets.only(top: 28.76, left: 18.78, right: 22),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(10),
        //                 child: Image.asset('asset/images/christinewalker.png'),
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Text(
        //                 'Christinewalker',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold, color: Colors.white),
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 'like your photo.',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               ),
        //               SizedBox(
        //                 width: size.width / 15,
        //               ),
        //               Text(
        //                 '46m',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 15,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding:
        //             const EdgeInsets.only(top: 18.23, left: 18.78, right: 22),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               Column(
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius: BorderRadius.circular(10),
        //                     child: Image.asset(
        //                       'asset/images/victorrotiz.png',
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'victor_rotiz',
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold,
        //                             color: Colors.white),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         'request to',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   ),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'follow you',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         '1d',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   )
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: size.width / 40,
        //               ),
        //               Column(
        //                 children: [
        //                   Container(
        //                       height: 35,
        //                       width: 100,
        //                       decoration: BoxDecoration(
        //                           color: Colors.red,
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(20))),
        //                       child: Center(
        //                         child: Text(
        //                           'Confirm',
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                       )),
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Column(
        //                 children: [
        //                   Icon(
        //                     Icons.highlight_off_sharp,
        //                     color: Colors.white,
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 10,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(
        //           top: 18.23,
        //           left: 18.78,
        //         ),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(10),
        //                 child: Image.asset('asset/images/debrawood.png'),
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Text(
        //                 'debra_wood',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold, color: Colors.white),
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 'Comment on your photo',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 '2d',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 10,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding:
        //             const EdgeInsets.only(top: 18.23, left: 18.78, right: 22),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               Column(
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius: BorderRadius.circular(10),
        //                     child: Image.asset(
        //                       'asset/images/rotiz.png',
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'victor_rotiz',
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold,
        //                             color: Colors.white),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         'started',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   ),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'following you',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         '5d',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   )
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: size.width / 16,
        //               ),
        //               Column(
        //                 children: [
        //                   Container(
        //                       height: 35,
        //                       width: 120,
        //                       decoration: BoxDecoration(
        //                           color: Colors.red,
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(20))),
        //                       child: Center(
        //                         child: Text(
        //                           'Follow',
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                       )),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 10,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding:
        //             const EdgeInsets.only(top: 28.76, left: 18.78, right: 22),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(10),
        //                 child: Image.asset('asset/images/christinewalker.png'),
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Text(
        //                 'Christinewalker',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold, color: Colors.white),
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 'like your photo.',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               ),
        //               SizedBox(
        //                 width: size.width / 15,
        //               ),
        //               Text(
        //                 '46m',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 15,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding:
        //             const EdgeInsets.only(top: 18.23, left: 18.78, right: 22),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               Column(
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius: BorderRadius.circular(10),
        //                     child: Image.asset(
        //                       'asset/images/victorrotiz.png',
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'victor_rotiz',
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold,
        //                             color: Colors.white),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         'request to',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   ),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'follow you',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         '1d',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   )
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: size.width / 40,
        //               ),
        //               Column(
        //                 children: [
        //                   Container(
        //                       height: 35,
        //                       width: 100,
        //                       decoration: BoxDecoration(
        //                           color: Colors.red,
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(20))),
        //                       child: Center(
        //                         child: Text(
        //                           'Confirm',
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                       )),
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Column(
        //                 children: [
        //                   Icon(
        //                     Icons.highlight_off_sharp,
        //                     color: Colors.white,
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 10,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(
        //           top: 18.23,
        //           left: 18.78,
        //         ),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(10),
        //                 child: Image.asset('asset/images/debrawood.png'),
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Text(
        //                 'debra_wood',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold, color: Colors.white),
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 'Comment on your photo',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 '2d',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 10,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding:
        //             const EdgeInsets.only(top: 18.23, left: 18.78, right: 22),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               Column(
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius: BorderRadius.circular(10),
        //                     child: Image.asset(
        //                       'asset/images/rotiz.png',
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'victor_rotiz',
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold,
        //                             color: Colors.white),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         'started',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   ),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'following you',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         '5d',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   )
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: size.width / 16,
        //               ),
        //               Column(
        //                 children: [
        //                   Container(
        //                       height: 35,
        //                       width: 120,
        //                       decoration: BoxDecoration(
        //                           color: Colors.red,
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(20))),
        //                       child: Center(
        //                         child: Text(
        //                           'Follow',
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                       )),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 10,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding:
        //             const EdgeInsets.only(top: 28.76, left: 18.78, right: 22),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(10),
        //                 child: Image.asset('asset/images/christinewalker.png'),
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Text(
        //                 'Christinewalker',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold, color: Colors.white),
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 'like your photo.',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               ),
        //               SizedBox(
        //                 width: size.width / 15,
        //               ),
        //               Text(
        //                 '46m',
        //                 style: TextStyle(color: Color(0xffA4A4A4)),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 18.78, right: 22),
        //         child: Divider(
        //           height: 15,
        //           color: Color(0xff4E4E4E),
        //         ),
        //       ),
        //       Padding(
        //         padding:
        //             const EdgeInsets.only(top: 18.23, left: 18.78, right: 22),
        //         child: Container(
        //           width: size.width,
        //           child: Row(
        //             children: [
        //               Column(
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius: BorderRadius.circular(10),
        //                     child: Image.asset(
        //                       'asset/images/victorrotiz.png',
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'victor_rotiz',
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold,
        //                             color: Colors.white),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         'request to',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   ),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'follow you',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       ),
        //                       SizedBox(
        //                         width: 5,
        //                       ),
        //                       Text(
        //                         '1d',
        //                         style: TextStyle(color: Color(0xffA4A4A4)),
        //                       )
        //                     ],
        //                   )
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: size.width / 40,
        //               ),
        //               Column(
        //                 children: [
        //                   Container(
        //                       height: 35,
        //                       width: 100,
        //                       decoration: BoxDecoration(
        //                           color: Colors.red,
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(20))),
        //                       child: Center(
        //                         child: Text(
        //                           'Confirm',
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                       )),
        //                 ],
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Column(
        //                 children: [
        //                   Icon(
        //                     Icons.highlight_off_sharp,
        //                     color: Colors.white,
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
