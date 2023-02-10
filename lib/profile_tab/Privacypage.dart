import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:socialapp/profile_tab/profilecommentclick.dart';
import 'package:socialapp/profile_tab/profileechoclick.dart';
import 'package:socialapp/profile_tab/profilephotosclick.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading:  ExpandTapWidget(
              tapPadding: EdgeInsets.all(10.0),
              onTap: (){
                Navigator.of(context).pop();

              },
              child: SvgPicture.asset('asset/images/back_arow.svg',width: 10,height: 15,fit: BoxFit.scaleDown,
                color: Theme.of(context).hoverColor,)),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Privacy',
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600,color: Theme.of(context).hoverColor,),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                  onTap: (){
                  Get.to(ProfilePhotosClick());
                  },
                  child: privacy(name: "Photos",color:Theme.of(context).hoverColor )),
              Divider(
              color:Theme.of(context).hoverColor.withOpacity(0.5)
              ),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                onTap: (){
                  Get.to(Profileechoclick());
                },
                  child: privacy(name: "Echoes",color:Theme.of(context).hoverColor)),
              Divider(
              color:Theme.of(context).hoverColor.withOpacity(0.5)
              ),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Get.to(ProfileCommentClick());
                  },
                  child: privacy(name: "Comments",color:Theme.of(context).hoverColor)),
              Divider(
              color:Theme.of(context).hoverColor.withOpacity(0.5)
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget privacy({required String name,required Color color}){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name',style: TextStyle(
            color: color
          ),),
          Icon(Icons.arrow_forward_ios,color: color,size: 12,)
        ],
      ),
    );
  }
}
