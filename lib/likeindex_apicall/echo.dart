// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart'as http;
//
// import '../model/my_profile_model.dart';
//
// class Echoindex extends StatefulWidget {
//   String imageurl;
//    Echoindex({Key? key,required this.imageurl}) : super(key: key);
//
//   @override
//   State<Echoindex> createState() => _EchoindexState();
// }
//
// class _EchoindexState extends State<Echoindex> {
//   MyPrModel? myProfile;
//   List<Private> privateEcho=[];
//   @overridea
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(6.0),
//           child:ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child:CachedNetworkImage (imageUrl:widget.imageurl,
//               width: 125,height: 125,
//               fit: BoxFit.fill,
//               placeholder: (context, url) => new Container(),
//               errorWidget: (context, url, error) => new Icon(Icons.person),),
//           ),
//         ),
//         Align(
//           alignment: Alignment.center,
//           child: IconButton(
//               color: Colors.redAccent,
//               onPressed: ()async{
//                 if(playing[index]==true){
//                   await audioplayers.pause();
//                 }else if(playing[index]==false){
//                   await audioplayers.play(UrlSource(myProfile!.privateEcho[index].audio));
//                   //await audioplayers.resume();
//                 }
//                 // await audioplayers.setReleaseMode(ReleaseMode.loop);
//               }, icon:playing[index]==true? Icon(
//               Icons.pause
//           ):Icon(Icons.play_arrow)
//           ),
//         ),
//       ],
//     );
//   }
// }
