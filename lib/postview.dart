  import 'dart:async';
import 'dart:developer';
import 'dart:ui';
  import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:fluttertoast/fluttertoast.dart';
  import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:socialapp/Utils/showsnackbar.dart';
import 'package:socialapp/aaaaaaaa/bottom_navigation_page.dart';
import 'dart:convert';
import 'dart:io';

import 'package:socialapp/chat_bubble.dart';

import 'package:socialapp/model/uploadpostmodel.dart';

import 'bucketmodel/Bucketmodel.dart';
import 'chatfirebase/models/UserModel.dart';
import 'model/categorylistmodel.dart';
import 'model/user_model.dart';

class PostView extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  PostView({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool val1 = true;
  bool val2 = false;
  bool isfirst = false;
  bool isSwitched = false;
  bool isAnonymous = false;

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
      print('Switch Button is ON');
    }
    else {
      setState(() {
        isSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  void anonymousSwitch(bool value) {
    if (isAnonymous == false) {
      setState(() {
        isAnonymous = true;
      });
      print('Switch Button is ON');
    }
    else {
      setState(() {
        isAnonymous = false;
      });
      print('Switch Button is OFF');
    }
  }

  final ImagePicker _picker = ImagePicker();
 // XFile? _image;
  File? _image;
  ImagePicker imagepi = ImagePicker();
  late String imagePath;

  File? selectedFile;
  TextEditingController titlee = TextEditingController();
  SimpleS3 _simpleS3 = SimpleS3();
  bool isLoading = false;
  bool uploaded = false;
  String? newValue;
  CategoryModel? _profileData;
  String? businessvalue;

  String? tradelicenseimage;
  String? audiosendurl;

  File? audioFile = File("");
  String? apath;


  String? _directoryPath;
  late Directory appDirectory;

  late final RecorderController recorderController;

  late final PlayerController playerController5;

  String? path;
  String? musicFile;
  bool isRecording = false;
  String? postvalue = "0";
  String? annoymousvalue = "0";

  onChangeFunction1(bool newValue1) {
    setState(() {
      val1 = newValue1;
      if (newValue1 == true) {
        postvalue = "1";
        print("the value of post with 1 is $postvalue");
      } else {
        postvalue = "0";
        print("the value of post with 1 is$postvalue");
      }
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      val2 = newValue2;
      if (newValue2 == true) {
        annoymousvalue = "1";
        print(annoymousvalue);
      } else {
        annoymousvalue = "0";
        print(annoymousvalue);
      }
    });
  }

  late String valueChoose;
  List listItem = ['item 1', 'item 2'];

  @override
  void initState() {
    super.initState();
    // _getDir();
    _initialiseControllers();
    _getData();
    getbucketapi();
    }

  Future _getData() async {
    _profileData = (await getCategoryService().getCategory());
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    _preparePlayers();
    path = "${appDirectory.path}/music.aac";
  }

  Future<ByteData> _loadAsset(String path) async {
    return await rootBundle.load(path);
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;

    playerController5 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  void _preparePlayers() async {
    ///audio-1
  }

  void _disposeControllers() {
    recorderController.dispose();

    playerController5.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();

    super.dispose();

  }

  ///As recording/playing media is resource heavy task,
  ///you don't want any resources to stay allocated even after
  ///app is killed. So it is recommended that if app is directly killed then
  ///this still will be called and we can free up resouces.
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.detached) {
  //     _disposeControllers();
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: new Container(
                          width: size.width / 2.5,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 48,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'asset/images/bluebutton.png'),
                                  fit: BoxFit.fill)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save as Draft',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async{
                          final result=await Connectivity().checkConnectivity();
                         if(result==ConnectivityResult.wifi||result==ConnectivityResult.mobile){
                           if(dload==true){
                             Fluttertoast.showToast(
                                 msg: "Voice still uploading.. wait",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.BOTTOM,
                                 backgroundColor: Colors.red,
                                 textColor: Colors.white,
                                 fontSize: 16.0);
                             }
                           if(imageloaded==true){
                             Fluttertoast.showToast(
                                 msg: "image still uploading.. wait",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.BOTTOM,
                                 backgroundColor: Colors.red,
                                 textColor: Colors.white,
                                 fontSize: 16.0);
                           }

                          else  if (titlee.text.toString().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter title",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }

                            else {
                              UploadPost(titlee.text.toString()).then((
                                  value) async {
                                print(value.sTATUS);
                                if (value.sTATUS == "SUCCESS") {
                                  Fluttertoast.showToast(
                                      msg: value.mESSAGE!,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BottomNavigationPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
                                } else {
                                  print(1);
                                  print(value.sTATUS);

                                  Fluttertoast.showToast(
                                      msg: value.mESSAGE!,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              });
                            }
                          }
                         else{
                           showconnectivitysnackbar(context, result);
                         }
                        },


                        child: new Container(
                          width: size.width / 2.5,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 48,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'asset/images/redbutton.png'),
                                  fit: BoxFit.fill)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Post',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          leading: ExpandTapWidget(
            tapPadding: EdgeInsets.all(8.0),
            onTap: (){
              Navigator.of(context).pop(true);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color:  Theme.of(context).hoverColor,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Lets Echo',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color:  Theme.of(context).hoverColor),
            ),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30),
                child: Row(
                  children: [
                    // ClipRRect(
                    //     borderRadius: BorderRadius.circular(50),
                    //     child: Image.asset('asset/images/profile.png'))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Container(
                  width: size.width,
                  child: TextFormField(
                    controller: titlee,
                    style: TextStyle(color: Theme.of(context).hoverColor),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).hoverColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).hoverColor),
                        ),

                        hintText: 'title for your echo',
                        hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).hoverColor)),
                  ),
                ),
              ),
              !isRecording ? Padding(
                padding: const EdgeInsets.only(top: 43, left: 20, right: 20),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.only(
                                top: 0, left: 0, right: 12),
                            contentPadding: const EdgeInsets.only(
                                top: 0, left: 0, bottom: 20),
                            insetPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                            content: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: (BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ))),
                              height: 200,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: Color(0xffEB4938),
                                    height: 55,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Audio",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                'asset/images/close.png',
                                                width: 17,
                                                height: 17,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [

                                        GestureDetector(
                                          onTap: () async {
                                            _pickAudio();
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'asset/images/gallery.png',
                                                width: 50,
                                                height: 50,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Upload Voice\n   ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),


                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              if (audiosendurl == null) {
                                                isfirst = true;
                                                print("$audiosendurl");
                                              } else {
                                                isfirst = false;
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Your Voice Is Already Uploaded",
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity:
                                                    ToastGravity.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                'asset/images/recorder.png',
                                                scale: 0.9,

                                                width: 50,
                                                height: 50,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Record Your\n       Voice",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.upload_file,
                              color: Colors.grey,
                            )),
                        Text(
                          'Upload audio and video record ',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.mic_none_rounded,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ) : Container(),

              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,


                  children: [
                    const SizedBox(height: 20),
                    if (playerController5.playerState !=
                        PlayerState.stopped) ...[
                      WaveBubble(

                        playerController: playerController5,
                        isPlaying: playerController5.playerState ==
                            PlayerState.playing,
                        onTap: () => _playOrPlausePlayer(playerController5),
                        isSender: false,
                      ),
                    ],
                  ],
                ),
              ),
              !isfirst ? Container() : Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isRecording
                        ? AudioWaveforms(
                      enableGesture: true,
                      size: Size(
                          MediaQuery
                              .of(context)
                              .size
                              .width / 2,
                          50),
                      recorderController: recorderController,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.white,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color(0xFF1E1B26),
                      ),
                      padding: const EdgeInsets.only(left: 18),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15),
                    )
                        : Container(

                    ),
                  ),


                  isfirst ? TextButton(

                    onPressed: _startOrStopRecording,
                    child: Text(
                        isRecording ? "stop recording" : "start recording"),
                    style: TextButton.styleFrom(primary:Theme.of(context).hoverColor,
                      backgroundColor:Theme.of(context).scaffoldBackgroundColor,),

                  ) : Container(),
                ],
              ),
              dload==true?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    size: 20,

                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index.isEven ? Colors.redAccent :Theme.of(context).hoverColor,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Uploading....',style: TextStyle(
                    color:Theme.of(context).hoverColor,
                  ),)
                ],
              ):Container(),


              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _image != null
                        ? () {
                      print("Image alredy selected");
                    }
                        : () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.only(
                                  top: 0, left: 0, right: 12),
                              contentPadding: const EdgeInsets.only(
                                  top: 0, left: 0, bottom: 20),
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 15),
                              content: Container(
                                decoration: const BoxDecoration(

                                    borderRadius: (BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ))),
                                height: 200,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      color: Color(0xffEB4938),
                                      height: 55,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Image",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Image.asset(
                                                  'asset/images/close.png',
                                                  width: 17,
                                                  height: 17,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,

                                    ),
                                    Container(

                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              var img =await  imagepi.getImage(source: ImageSource.camera);

                                              setState(() {
                                                _image = File(img!.path);
                                                selectedFile =
                                                    File(_image!.path,);
                                              });
                                              print(_image);

                                              imagePath = _image!.path;
                                              Navigator.pop(context);
                                              if (selectedFile != null)
                                                _uploadTradeLicense();
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  'asset/images/camera.png',
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Take Photo\n   ",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              var image =
                                              await imagepi.pickImage(
                                                  source: ImageSource
                                                      .gallery);
                                              setState(() {
                                                _image = File(image!.path);
                                                selectedFile =
                                                    File(_image!.path);
                                              });
                                              print(_image);
                                              imagePath = _image!.path;
                                              Navigator.pop(context);
                                              if (selectedFile != null)
                                                _uploadTradeLicense();
                                            },
                                            child: Column(
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Image.asset(

                                                  'asset/images/gallery.png',
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Choose from\n       gallery ",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: _image == null
                        ? Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20),
                      child: DottedBorder(
                        color: Colors.blueAccent,
                        child: Container(
                          height: 120,
                          width: size.width - 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.grey,
                                size: 32,
                              ),
                              Text(
                                'Upload background Image',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                        : Stack(
                      children: [
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 4,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 20,
                          margin: EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              _image!,
                              scale: 1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Visibility(
                                  child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding: EdgeInsets.only(right: 10),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,


                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .end,
                                        children: [

                                          Image.asset(
                                            'asset/images/delete.png',
                                            width: 27,
                                            height: 27,
                                          ),
                                        ],
                                      )),
                                )))
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              imageloaded==true?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    size: 20,

                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index.isEven ? Colors.redAccent :Theme.of(context).hoverColor,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Uploading....',style: TextStyle(
                      color:Theme.of(context).hoverColor
                  ),)
                ],
              ):Container(),

              // Padding(
              //   padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              //   child: DottedBorder(
              //     color: Colors.blueAccent,
              //     child: Container(
              //       height: 120,
              //       width: size.width,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             Icons.cloud_upload_outlined,
              //             color: Colors.grey,
              //             size: 32,
              //           ),
              //           Text(
              //             'Upload background Image',
              //             style: TextStyle(
              //                 fontSize: 12,
              //                 color: Colors.grey,
              //                 fontWeight: FontWeight.w400),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 22, left: 20, right: 20),
                    child: Row(
                      children: [
                        Text(
                          "Public(Post)",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).hoverColor.withOpacity(0.5)),
                        ),
                        Spacer(),
                        Switch(
                          onChanged: toggleSwitch,
                          value: isSwitched,
                          activeColor: Colors.grey,
                          activeTrackColor: Theme.of(context).hoverColor,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 3,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 22, left: 20, right: 20),
                    child: Row(
                      children: [
                        Text(
                          "Anonymous Post",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).hoverColor.withOpacity(0.5)),
                        ),
                        Spacer(),
                        Switch(
                          onChanged: anonymousSwitch,
                          value: isAnonymous,
                          activeColor: Colors.grey,
                          activeTrackColor: Theme.of(context).hoverColor,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  height: 50,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: Row(

                    children: [
                      _profileData==null?SizedBox():Container(

                        width: size.width - 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),


                          child: DropdownButtonHideUnderline(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Color(0xff161730),
                              ),
                              child: DropdownButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white, // <-- SEE HERE
                                  ),
                                  hint: Text(
                                    'Select Category',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onChanged: (changedValue) {
                                    setState(() {
                                      newValue = changedValue as String?;
                                      print(newValue);
                                    });
                                  },
                                  value: newValue,

                                  items: _profileData!.categoryList.map((cityOne) {
                                    return DropdownMenuItem(
                                      child: Text(cityOne.name,style: TextStyle(color: Colors.white),),
                                      value: cityOne.name,
                                    );
                                  }).toList()),
                              // items: <String>[
                              //   'Alabama',
                              //   'Alaska',
                              //   'Arizona',
                              //   'Arkansas',
                              // ].map((String value) {
                              //   return new DropdownMenuItem<String>(
                              //     value: value,
                              //     child: Text(
                              //       value,
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //   );
                              // }).toList()),
                            ),
                          ),

                          // child: Text(
                          //   'Select Category',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.w400),
                          // ),
                        ),
                      ),
                      // SizedBox(
                      //   width: size.width / 2,
                      // ),
                      // Icon(
                      //   Icons.keyboard_arrow_down,
                      //   color: Colors.white,
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customSwitch(String text, bool val, Function onChangeMethod) {
    return Padding(
      padding: EdgeInsets.only(top: 22, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white60),
          ),
          Spacer(),
          CupertinoSwitch(
              trackColor: Colors.grey,
              activeColor: Colors.white,
              value: val,
              onChanged: (newValue) {
                onChangeMethod(newValue);
              })
        ],
      ),
    );
  }
  bool imageloaded=false;
  Bucketmodel? bucketmodel;
  Future getbucketapi()async{
    var response = await http.get(Uri.parse("http://3.227.35.5:3001/api/user/credentials"));
    if(response.statusCode==200){
      setState((){
        bucketmodel=bucketmodelFromJson(response.body);
        print(response.body);
      });

    }
    else{
      print(response.statusCode);
    }
  }

  Future<String?> _uploadTradeLicense() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          imageloaded = true;
        });
        result = await _simpleS3.uploadFile(
          selectedFile!,
          "${bucketmodel!.data.bucket.toString()}",
          "${bucketmodel!.data.poolId.toString()}",
          AWSRegions.apSouth1,
          debugLog: true,
          s3FolderPath:"image" ,

          accessControl: S3AccessControl.publicRead,
        ).catchError((error){
          print("suberror are $error");
        });

        print("https://winklixsocial.s3.ap-south-1.amazonaws.com/image/" +
            "${selectedFile!
                .path
                .split("/")
                .last}");
        tradelicenseimage = ("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
          "image/"+"${selectedFile!
                .path
                .split("/")
                .last}");

        setState(() {
          uploaded = true;
          imageloaded = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  void _pickAudio() async {
    try {
      _directoryPath = null;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['mp3', 'ogg', 'wav', 'aac'],
        // allowCompression: true,
        type: FileType.custom,
      );

      if (result != null) {
        setState(() {
          audioFile = File(result.files.single.path.toString());

          print("the audio file is $audioFile");
          Fluttertoast.showToast(
              msg: "Your Voice Upload Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          isRecording = true;
        });

        _uploadBusinessLicense();
        // postController.bgPath = _upload5(toUpload: audioFile).toString();
      } else {
        // User canceled the picker
      }
      // _paths = (await FilePicker.platform.pickFiles(
      //   type: FileType.audio,

      //   onFileLoading: (FilePickerStatus status) => print(status),
      //   allowedExtensions: ['mp3', ],
      // )
      // )
      // ?.files;
    } on PlatformException catch (e) {
      //  _logException('Unsupported operation' + e.toString());
    } catch (e) {
      // _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
      // _fileName =
      //     result != null ? _paths!.map((e) => e.name).toString() : '...';
      // _userAborted = _paths == null;
    });
  }



  Future<String?> _uploadBusinessLicense() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        result = await _simpleS3.uploadFile(
          audioFile!,
          "${bucketmodel!.data.bucket.toString()}",
          "${bucketmodel!.data.poolId.toString()}",
          AWSRegions.apSouth1,
          debugLog: true,
          s3FolderPath: "echo",
          accessControl: S3AccessControl.publicRead,
        );

        print("https://winklixsocial.s3.ap-south-1.amazonaws.com/echo/" +
            "${audioFile!
                .path
                .split("/")
                .last}");
        audiosendurl = ("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
           "echo/"+"${audioFile!
                .path
                .split("/")
                .last}");

        setState(() {
          uploaded = true;
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  void _playOrPlausePlayer(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);
  }

  void _startOrStopRecording() async {
    if (isRecording) {
      recorderController.reset();
      final path = await recorderController.stop(false);
      if (path != null) {
        await playerController5.preparePlayer(path: path);
        setState(() {
          // isRecording = !isRecording;
          selectedFile = File(path);
        });
        if (selectedFile != null) {
          setState(() {
            isRecording = !isRecording;
            Fluttertoast.showToast(
                msg: "Your Voice Upload Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            isfirst = false;
          });
          _uploadAudioMouthVoice();
          path == null;
        }
      }
    } else {
      await recorderController.record(path: path);
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }

  Future<String?> _uploadAudioMouthVoice() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          dload = true;
        });
        result = await _simpleS3.uploadFile(
          selectedFile!,
          "${bucketmodel!.data.bucket.toString()}",
          "${bucketmodel!.data.poolId.toString()}",
          AWSRegions.apSouth1,
          debugLog: true,
          s3FolderPath: "echo",
          accessControl: S3AccessControl.publicRead,
        );

        print("abcdeeeeehttps://winklixsocial.s3.ap-south-1.amazonaws.com/echo/" +
            "${selectedFile!
                .path
                .split("/")
                .last}");
        audiosendurl = ("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
           "echo/"+"${selectedFile!
                .path
                .split("/")
                .last}");

        setState(() {
          uploaded = true;
          dload = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }
  bool dload=false;

  Future<UploadPostModel> UploadPost(String titlee) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('USER_ID') ?? '';
    print(name);
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
      'connect.sid=s%3A2z3BncojYc2yuDSurOEiaM9yo7RXga3q.BJYwkvwTIXjsC8FfzPhV0z86euOtsxgiFguA%2BZv0nZc'
    };
    var request =
    http.Request('POST', Uri.parse('http://3.227.35.5:3001/api/user/post'));
    request.body = json.encode({
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "ID": name,
      "TITLE": titlee,
      "AUDIO": audiosendurl,
      "BACKGROUND_IMAGE": tradelicenseimage,
      "IS_PUBLIC": isSwitched,
      "IS_ANONYMOUS": isAnonymous,
      "TYPE": (audiosendurl == null && tradelicenseimage != null)
          ? "image"
          : (tradelicenseimage == null && audiosendurl != null) ? "echo" :
      (audiosendurl != null && tradelicenseimage != null) ? "echo" : "echo",
      "CATEGORY": ["$newValue"],
      "POST_STATUS": "1"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
      print("theeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${request.body}");
      print(data);
      return UploadPostModel.fromJson(data);
    } else {
      Navigator.of(context).pop();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.reasonPhrase);
      return UploadPostModel.fromJson(data);
    }
  }

  // var files;
  //
  // void getFiles() async { //asyn function to get list of files
  //   List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
  //   var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
  //   var fm = FileManager(root: Directory(root)); //
  //   files = await fm.filesTree(
  //       excludedPaths: ["/storage/emulated/0/Android"],
  //       extensions: ["mp3"] //optional, to filter files, list only mp3 files
  //   );
  //   setState(() {}); //update the UI
  // }
   void showconnectivitysnackbar(BuildContext context,
      ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet ? "connection restored" :
    "No internet connection";
    final color = hasInternet ? Colors.green : Colors.red;
    Utils.showsnackbar(context, message, color);
  }
}
  class getCategoryService {
    Future<CategoryModel?> getCategory() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("USER_ID").toString();

      print("private screen uid is $userId");

      try {
        print("trying to Category");

        var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndPoint);

        var response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Cookie':
              'connect.sid=s%3AtVnLmITSn_zletRj2nMA2yCjWafW69aY.vufwo%2Fh45zhYEp06x9RKcV0mhk2DkYDZ1twbPiJRp5Y'
            },
            body: json.encode({"APP_KEY": "SpTka6TdghfvhdwrTsXl28P1"}));
        // print(response.statusCode);
        // print(response.body);

        if (response.statusCode == 200) {
          print("---------- Success -----------");

          CategoryModel _model = categoryModelFromJson(response.body);
          return _model;
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  class ApiConstants {
    static String baseUrl = 'http://3.227.35.5:3001/api/user/';
    static String profileEndPoint = 'get-category';
  }
