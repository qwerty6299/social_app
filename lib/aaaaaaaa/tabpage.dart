// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'package:transparent_image/transparent_image.dart';
// import 'package:video_player/video_player.dart';
//
//
// // class TabCamera extends StatefulWidget {
// //   const TabCamera({Key? key}) : super(key: key);
// //
// //   @override
// //   State<TabCamera> createState() => _TabCameraState();
// // }
// //
// // class _TabCameraState extends State<TabCamera> {
// //   int _cameraIndex = 0;
// //   late CameraController controller;
// //   @override
// //   Widget build(BuildContext context) {
// //     return  Scaffold(
// //       body: Stack(
// //         children: <Widget>[
// //          // _buildCameraPreiew(),
// //
// //           Column(
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               children: <Widget>[
// //                 _buildGalleryBar(),
// //                 _buildControlBar(),
// //              //   _buildTapForPhotoText(),
// //               ]
// //           ),
// //         ],),
// //     );
// //   }
// //   Widget _buildGalleryBar() {
// //     final barHeight = 90.0;
// //     final vertPadding = 10.0;
// //
// //     return Container(
// //       height: barHeight,
// //       child: ListView.builder(
// //         padding: EdgeInsets.symmetric(vertical: vertPadding),
// //         scrollDirection: Axis.horizontal,
// //         itemBuilder: (BuildContext context, int _) {
// //           return Container(
// //             padding: EdgeInsets.only(right: 5.0),
// //             width: 70.0,
// //             height: barHeight - vertPadding * 2,
// //             child: Image(
// //               image: randomImageUrl(),
// //               fit: BoxFit.cover,
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildControlBar() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceAround,
// //       children: <Widget>[
// //         IconButton(
// //           color: Colors.white,
// //           icon: Icon(Icons.flash_auto),
// //           onPressed: () {},
// //         ),
// //         GestureDetector(
// //           onTap: _onTakePictureButtonPress,
// //           child: Container(
// //             height: 80.0,
// //             width: 80.0,
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               border: Border.all(
// //                 color: Colors.white,
// //                 width: 5.0,
// //               ),
// //             ),
// //           ),
// //         ),
// //         IconButton(
// //           color: Colors.white,
// //           icon: Icon(Icons.switch_camera),
// //           onPressed: _onSwitchCamera,
// //         ),
// //       ],
// //     );
// //   }
// //   void _onSwitchCamera() {
// //     if (controller == null ||
// //         !controller.value.isInitialized ||
// //         controller.value.isTakingPicture) {
// //       return;
// //     }
// //     final newIndex = _cameraIndex + 1 == cameras.length ? 0 : _cameraIndex + 1;
// //     _initCamera(newIndex);
// //   }
// //   void _initCamera(int index) async {
// //     if (controller != null) {
// //       await controller.dispose();
// //     }
// //     controller = CameraController(cameras[index], ResolutionPreset.high);
// //
// //     // If the controller is updated then update the UI.
// //     controller.addListener(() {
// //       if (mounted) setState(() {});
// //       if (controller.value.hasError) {
// //        // _showInSnackBar('Camera error ${controller.value.errorDescription}');
// //       }
// //     });
// //
// //     try {
// //       await controller.initialize();
// //     } on CameraException catch (e) {
// //       _showCameraException(e);
// //     }
// //
// //     if (mounted) {
// //       setState(() {
// //         _cameraIndex = index;
// //       });
// //     }
// //   }
// //
// //   void _onTakePictureButtonPress() {
// //     _takePicture().then((filePath) {
// //       if (filePath != null) {
// //         // _showInSnackBar('Picture saved to $filePath');
// //         Navigator.push(context, MaterialPageRoute(builder: (context) {
// //           return Scaffold(
// //             appBar: AppBar(
// //               backgroundColor: Colors.black,
// //               actions: <Widget>[
// //                 IconButton(
// //                   icon: Icon(Icons.crop_rotate),
// //                   onPressed: () {},
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.insert_emoticon),
// //                   onPressed: () {},
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.text_fields),
// //                   onPressed: () {},
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.edit),
// //                   onPressed: () {},
// //                 ),
// //               ],
// //             ),
// //             body: Container(
// //               color: Colors.black,
// //               child: Center(
// //                 child: Image.file(File(filePath)),
// //               ),
// //             ),
// //           );
// //         }));
// //       }
// //     });
// //   }
// //   String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
// //   Future<String> _takePicture() async {
// //     if (!controller.value.isInitialized || controller.value.isTakingPicture) {
// //       return 'fbjdb';
// //     }
// //     final Directory extDir = await getApplicationDocumentsDirectory();
// //     final String dirPath = '${extDir.path}/Pictures/whatsapp_clone';
// //     await Directory(dirPath).create(recursive: true);
// //     final String filePath = '$dirPath/${_timestamp()}.jpg';
// //
// //     try {
// //       await controller.takePicture();
// //       return filePath;
// //     } on CameraException catch (e) {
// //       _showCameraException(e);
// //       return 'fbjdb';
// //     }
// //     return filePath;
// //   }
// //   void _showCameraException(CameraException e) {
// //     logError(e.code, e.description!);
// //  //   _showInSnackBar('Error: ${e.code}\n${e.description}');
// //   }
// //   // void _showInSnackBar(String message) {
// //   //   _scaffoldKey.currentState?.s(SnackBar(content: Text(message)));
// //   // }
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //
// //
// //
// //
// //
// // }
//
// class TabCamera extends StatefulWidget {
//   const TabCamera({Key? key}) : super(key: key);
//
//   @override
//   State<TabCamera> createState() => _TabCameraState();
// }
//
// class _TabCameraState extends State<TabCamera> {
//   List<Album> _albums=[];
//   bool _loading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loading = true;
//     initAsync();
//   }
//
//   Future<void> initAsync() async {
//     if (await _promptPermissionSetting()) {
//       List<Album> albums =
//       await PhotoGallery.listAlbums(mediumType: MediumType.image);
//       setState(() {
//         _albums = albums;
//         _loading = false;
//       });
//     }
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   Future<bool> _promptPermissionSetting() async {
//     if (Platform.isIOS &&
//         await Permission.storage.request().isGranted &&
//         await Permission.photos.request().isGranted ||
//         Platform.isAndroid && await Permission.storage.request().isGranted) {
//       return true;
//     }
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//
//         body: _loading
//             ? Center(
//           child: CircularProgressIndicator(),
//         )
//             : LayoutBuilder(
//           builder: (context, constraints) {
//             double gridWidth = (constraints.maxWidth - 20) / 3;
//             double gridHeight = gridWidth + 33;
//             double ratio = gridWidth / gridHeight;
//             return Container(
//               padding: EdgeInsets.all(5),
//               child: GridView.count(
//                 childAspectRatio: ratio,
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 5.0,
//                 crossAxisSpacing: 5.0,
//                 children: <Widget>[
//                   ...?_albums.map(
//                         (album) => GestureDetector(
//                       onTap: () => Navigator.of(context).push(
//                           MaterialPageRoute(
//                               builder: (context) => AlbumPage(album))),
//                       child: Column(
//                         children: <Widget>[
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(5.0),
//                             child: Container(
//                               color: Colors.grey[300],
//                               height: gridWidth,
//                               width: gridWidth,
//                               child: FadeInImage(
//                                 fit: BoxFit.cover,
//                                 placeholder:
//                                 MemoryImage(kTransparentImage),
//                                 image: AlbumThumbnailProvider(
//                                   albumId: album.id,
//                                   mediumType: album.mediumType,
//                                   highQuality: true,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             alignment: Alignment.topLeft,
//                             padding: EdgeInsets.only(left: 2.0),
//                             child: Text(
//                               album.name ?? "Unnamed Album",
//                               maxLines: 1,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 height: 1.2,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             alignment: Alignment.topLeft,
//                             padding: EdgeInsets.only(left: 2.0),
//                             child: Text(
//                               album.count.toString(),
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 height: 1.2,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// class AlbumPage extends StatefulWidget {
//   final Album album;
//
//   AlbumPage(Album album) : album = album;
//
//   @override
//   State<StatefulWidget> createState() => AlbumPageState();
// }
//
// class AlbumPageState extends State<AlbumPage> {
//   List<Medium>? _media;
//
//   @override
//   void initState() {
//     super.initState();
//     initAsync();
//   }
//
//   void initAsync() async {
//     MediaPage mediaPage = await widget.album.listMedia();
//     setState(() {
//       _media = mediaPage.items;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//
//         body: GridView.count(
//           crossAxisCount: 3,
//           mainAxisSpacing: 1.0,
//           crossAxisSpacing: 1.0,
//           children: <Widget>[
//             ...?_media?.map(
//                   (medium) => GestureDetector(
//                 onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => ViewerPage(medium))),
//                 child: Container(
//                   color: Colors.grey[300],
//                   child: FadeInImage(
//                     fit: BoxFit.cover,
//                     placeholder: MemoryImage(kTransparentImage),
//                     image: ThumbnailProvider(
//                       mediumId: medium.id,
//                       mediumType: medium.mediumType,
//                       highQuality: true,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ViewerPage extends StatelessWidget {
//   final Medium medium;
//
//   ViewerPage(Medium medium) : medium = medium;
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime? date = medium.creationDate ?? medium.modifiedDate;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//
//
//         body: Container(
//           alignment: Alignment.center,
//           child: medium.mediumType == MediumType.image
//               ? FadeInImage(
//             fit: BoxFit.cover,
//             placeholder: MemoryImage(kTransparentImage),
//             image: PhotoProvider(mediumId: medium.id),
//           )
//               : VideoProvider(
//             mediumId: medium.id,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class VideoProvider extends StatefulWidget {
//   final String mediumId;
//
//   const VideoProvider({
//     required this.mediumId,
//   });
//
//   @override
//   _VideoProviderState createState() => _VideoProviderState();
// }
//
// class _VideoProviderState extends State<VideoProvider> {
//   VideoPlayerController? _controller;
//   File? _file;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       initAsync();
//     });
//     super.initState();
//   }
//
//   Future<void> initAsync() async {
//     try {
//       _file = await PhotoGallery.getFile(mediumId: widget.mediumId);
//       _controller = VideoPlayerController.file(_file!);
//       _controller?.initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//     } catch (e) {
//       print("Failed : $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _controller == null || !_controller!.value.isInitialized
//         ? Container()
//         : Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         AspectRatio(
//           aspectRatio: _controller!.value.aspectRatio,
//           child: VideoPlayer(_controller!),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               _controller!.value.isPlaying
//                   ? _controller!.pause()
//                   : _controller!.play();
//             });
//           },
//           child: Icon(
//             _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//       ],
//     );
//   }
// }
//