import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Profileechoclick extends StatefulWidget {
  const Profileechoclick({Key? key}) : super(key: key);

  @override
  State<Profileechoclick> createState() => _ProfileechoclickState();
}

class _ProfileechoclickState extends State<Profileechoclick> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            'Echoes',
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600,color: Theme.of(context).hoverColor,),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height*0.03,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left:size.width*0.05),
                  child: Text('Who can view',style: TextStyle(
                      color: Theme.of(context).hoverColor
                  ),
                  ),
                ),
                SizedBox(
                  height: size.height*0.04,
                ),
                echoes(name: 'Anyone', color: Theme.of(context).hoverColor, fsize: 16),
                SizedBox(
                  height: size.height*0.01,
                ),
                Divider(
                    color:Theme.of(context).hoverColor.withOpacity(0.5)
                ),
                SizedBox(
                  height: size.height*0.01,
                ),
                echoes(name: 'Friends', color: Theme.of(context).hoverColor, fsize: 16),

              ],
            ),

          ],
        ),

      ),
    );
  }
  Widget echoes({required String name,required Color color,required double fsize}){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name',style: TextStyle(
              color: color,fontSize: fsize
          ),),
          // IosSwitch(
          //     size: 22,
          //     disableBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //     activeBackgroundColor: Theme.of(context).hoverColor,
          //     disableBorderColor:  Theme.of(context).hoverColor,
          //
          //     dotActiveColor: Theme.of(context).hoverColor,
          //     dotdisableColor: Theme.of(context).hoverColor.withOpacity(0.2),
          //     onChanged: (v){
          //
          //     })
        ],
      ),
    );
  }
}
