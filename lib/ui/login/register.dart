import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';
import '../../other_config.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  String userEmail = "";
  String userName = "";
  String userPhone = "";
  String userAvatar = "";
  String userSocialLogin = "";
  bool enableNotify = true;
  List<String> userFavorites = [];
  List<String> userFavoritesProviders = [];
  // List<String> cartList = []; // старая версия, заменена на cartData
  List<CartData> cartData = [];
  List<AddressData> userAddress = [];
  List<String> blockedUsers = [];




  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _editControllerName = TextEditingController();
  final _editControllerEmail = TextEditingController();
  final _editControllerPassword1 = TextEditingController();
  final _editControllerPassword2 = TextEditingController();

  @override
  void dispose() {
    _editControllerName.dispose();
    _editControllerEmail.dispose();
    _editControllerPassword1.dispose();
    _editControllerPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
        backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            ListView(
              children: [
                ClipPath(
                    clipper: ClipPathClass23(20),
                    child: Container(
                      color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.black54,
                      width: windowWidth,
                      height: windowHeight*0.3,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(strings.get(49), /// "Register",
                                          style: theme.style25W800),
                                      SizedBox(height: 10,),
                                      Text(strings.get(50), /// "in less than a minute",
                                          style: theme.style16W600White),
                                    ],
                                  ))),
/*
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            alignment: Alignment.bottomRight,
                            width: windowWidth*0.3,
                            height: windowWidth*0.3,
                            child: theme.registerLogoAsset ? Image.asset("assets/ondemands/ondemand5.png", fit: BoxFit.contain) :
                            CachedNetworkImage(
                                imageUrl: theme.registerLogo,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                            ),)
                          */
                        ],

                      ),
                    )),

                Container(
                  color: (theme.darkMode) ? Colors.black : Colors.white,
                  child: Column(
                      children: [

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: edit42(strings.get(21), // "Name",
                            _editControllerName,
                            strings.get(22), // "Enter Name",
                          ),
                        ),

                        SizedBox(height: 20,),
/*
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: edit42(strings.get(25), // "Email",
                            _editControllerEmail,
                            strings.get(26), // "Enter Email",
                          ),
                        ),
*/

                        Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(appSettings.otpPrefix,
                                    style: theme.style18W800),
                                SizedBox(width: 10,),
                                Expanded(
                                    child: edit42("", // "Phone number",
                                    _editControllerEmail,
                                    strings.get(26), // "Enter your Phone number",
                                    type: TextInputType.phone)),
                              ],
                            )
                        ),



                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Edit43(
                            text: strings.get(44), // "Password",
                            textStyle: theme.style14W600Grey,
                            controller: _editControllerPassword1,
                            hint: strings.get(45), // "Enter Password",
                          ),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Edit43(
                            text: strings.get(51), // "Confirm Password",
                            textStyle: theme.style14W600Grey,
                            controller: _editControllerPassword2,
                            hint: strings.get(45), // "Enter Password",
                          ),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.all(20),
                          child: button2(strings.get(46), theme.mainColor, _continue), /// "CONTINUE",
                        ),

                      ],
                  ),
                ),

              ],
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.white,
                "", context, () {goBack();}),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

          ],
        )

    ));
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _continue() async {


    if (_editControllerName.text.isEmpty)
      return messageError(context, strings.get(22)); /// "Please Enter Email",

    if (_editControllerEmail.text.isEmpty)
      return messageError(context, strings.get(209)); /// "Please Enter Email",
    if (_editControllerPassword1.text.isEmpty || _editControllerPassword2.text.isEmpty)
      return messageError(context, strings.get(136)); /// "Please enter password",
    if (_editControllerPassword1.text != _editControllerPassword2.text)
      return messageError(context, strings.get(140)); /// "Passwords are not equal",
    /*
    if (!validateEmail(_editControllerEmail.text))
      return messageError(context, strings.get(139)); /// "Email are wrong",
    */
    _waits(true);
    var ret = await register1(_editControllerEmail.text, appSettings.otpPrefix+_editControllerEmail.text+"@modjidep.com",
        _editControllerPassword1.text, _editControllerName.text,
        strings.get(138) /// User don't create
    );
    _waits(false);
    if (ret != null)
      return messageError(context, ret);


    goBack();
    goBack();
  }






// stringUserDontCreate - strings.get(182); /// User don't create
  Future<String?> register1(String phone, String email, String pass, String name, String stringUserDontCreate) async {
    try {
      final User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: pass,)).user;

      if (user == null)
        return stringUserDontCreate;

      dprint("LAST_PHONE1 :"  +  LAST_PHONE1);
      setState(() {
        LAST_PHONE1 = phone;
      });
      dprint("LAST_PHONE1 :"  +  LAST_PHONE1);


      FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
        "visible": true,
        "phoneVerified": false,
        "email": user.email,
        "phone": "",
        "name": name,
        "date_create" : FieldValue.serverTimestamp()
      });

      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"customersCount": FieldValue.increment(1)}, SetOptions(merge:true));

      localSettings.saveLogin(email, pass, "email");

    }catch(ex){
      return "register " + ex.toString();
    }
    return null;
  }






}


