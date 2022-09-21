import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';
import '../strings.dart';

int _type = 1;

/*
test ( _close,   _mainModel,   _editControllerAddress,
      _editControllerName,   _editControllerPhone,   context) async {
dprint("jeanlouis : ");
}
*/

getSuccesBooking(Function() _close, MainModel _mainModel, TextEditingController _editControllerAddress,
    TextEditingController _editControllerName, TextEditingController _editControllerPhone, BuildContext context){
    _editControllerAddress.text = _editControllerName.text;
    _mainModel.account.initAddressEdit(_editControllerAddress, _editControllerName, _editControllerPhone);


    //test(_close,  _mainModel,  _editControllerAddress, _editControllerName,  _editControllerPhone,  context);

    double windowWidth = 0;
    double windowHeight = 0;
    double windowSize = 0;
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UnconstrainedBox(
            child: Container(
              height: windowWidth/3,
              width: windowWidth/3,
              child: image11(
                  theme.booking5LogoAsset ? Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain) :
                  CachedNetworkImage(
                      imageUrl: theme.booking5Logo,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                  ),
                  //Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain)
                  20),
            )),
        SizedBox(height: 20,),
        Text(strings.get(116), // "Thank you!",
            textAlign: TextAlign.center, style: theme.style20W800),
        SizedBox(height: 20,),
        Text(strings.get(115), // "Your booking has been successfully submitted, you will receive a confirmation soon."
            textAlign: TextAlign.center, style: theme.style14W400),
        SizedBox(height: 40,),
        Text("${strings.get(232)} $cartLastAddedId", /// "Booking ID",
            textAlign: TextAlign.center, style: theme.style14W400),
        SizedBox(height: 40,),
        Container(
            alignment: Alignment.center,
            child: Container(
                width: windowWidth/2,
                child: button2(strings.get(114), theme.mainColor, // "Ok",
                        (){
                      _close();
                      route("category");
                    }))
        ),
        SizedBox(height: 20,),
      ],
    );




}