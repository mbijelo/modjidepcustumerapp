import 'dart:io';
import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/model.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:ondemandservice/other_config.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late MainModel _mainModel;
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
  final _editControllerEmail = TextEditingController();
  final _editControllerPassword = TextEditingController();


  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }


  @override
  void dispose() {
    _editControllerEmail.dispose();
    _editControllerPassword.dispose();
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
                      //color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
                        color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.black54,
                      width: windowWidth,
                      height: windowHeight/3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Container(
                            width: windowWidth*0.2,
                            height: windowWidth*0.2,
                            child:Image.asset("assets/ondemands/ondemand1-cercle.png", fit: BoxFit.contain),
                            /*
                              theme.loginLogoAsset ? Image.asset("assets/ondemands/ondemand1-cercle.png", fit: BoxFit.contain) :

                            CachedNetworkImage(
                                imageUrl: theme.loginLogo,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                            ),
                            */
                          ),
                          SizedBox(height: 20,),
                          Text(strings.get(288), // "SERVICE",
                              style: theme.style10W600White11),
                          /*
                          Expanded(child: Container(
                            width: windowWidth,
                            child: theme.loginImageAsset ? Image.asset("assets/ondemands/ondemand2.png", fit: BoxFit.cover) :
                            CachedNetworkImage(
                                imageUrl: theme.loginImage,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                            ),
                          )
                          )
                           */
                        ],
                      ),
                    )),

                Container(
                  color: (theme.darkMode) ? Colors.black : Colors.white,
                  child: Column(
                      children: [
                        Center(
                          child: Text(strings.get(43), // "Sign in now",
                            style: theme.style16W800,
                          ),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: edit42(strings.get(25), /// "Email",
                              _editControllerEmail,
                              strings.get(26), // "Enter your Email",
                              type: TextInputType.emailAddress
                              ),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Edit43(
                              text: strings.get(44), // "Password",
                              controller: _editControllerPassword,
                              hint: strings.get(45), // "Enter your Password",
                              ),
                        ),

                        SizedBox(height: 10,),

                        Container(
                          margin: EdgeInsets.all(20),
                          //child: button2(strings.get(46), theme.mainColor, _login), /// "CONTINUE",
                          child: button2(strings.get(46), Colors.black, _login), /// "CONTINUE",
                        ),


                        Container(
                          margin: EdgeInsets.all(10),
                          //child: button2(strings.get(47), theme.mainColor, /// "REGISTER",
                          child: button2(strings.get(47), Colors.black54, /// "REGISTER",
                                  (){
                                route("register");
                              }),
                        ),

                       

                        /*
                        button134(strings.get(227), /// "Forgot password?",
                                (){
                              route("forgot");
                            }, style: theme.style14W400),
                        */



                        // SizedBox(height: 20,),

/*

                        Center(
                          child: Text(strings.get(48), // "or continue with",
                              style: theme.style14W600Grey),
                        ),

                        SizedBox(height: 10,),
                        if (Platform.isIOS)
                          buttonIOS("assets/apple.png", _appleLogin, windowWidth * 0.9, "Sign in with Apple"),
                        SizedBox(height: 10,),

                        Container(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(child: button195("Facebook", theme.mainColor, _facebookLogin, style: theme.style16W800White, )),
                                SizedBox(width: 1,),
                                Flexible(child: button196("Google", theme.mainColor, _googleLogin, style: theme.style16W800White)),
                              ],
                            )
                        )
                        */
                      ],
                  ),
                ),

              ],
            ),


            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {
                  goBack();
                  route("home");
            }),

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

  _login() async {
    if (_editControllerEmail.text.isEmpty) {
      _mainModel.openDialog("getError²" + strings.get(209));
      return messageError(context, strings.get(209));
      //return messageError(context, strings.get(135)); /// "Please Enter Email",
    }



    if (_editControllerPassword.text.isEmpty) {
      _mainModel.openDialog("getError²" + strings.get(136));
      return messageError(context, strings.get(136));
      //return messageError(context, strings.get(136)); /// "Please Enter Password",
    }


    _waits(true);
    LAST_PHONE = _editControllerEmail.text;
    LAST_PHONE1 = _editControllerEmail.text;
    var ret = await login1(appSettings.otpPrefix+_editControllerEmail.text, appSettings.otpPrefix+_editControllerEmail.text+"@modjidep.com", _editControllerPassword.text, true,
        strings.get(137), // User not found
        strings.get(173) // "User is disabled. Connect to Administrator for more information.",
        );
    _waits(false);
    if (ret != null)
      //return messageError(context, ret);
    _mainModel.openDialog("getError²"+strings.get(137));
    goBack();
  }

  Future<String?> login1(String phone, String email, String pass, bool _remember,
      String stringUserNotFound, // strings.get(177) User not found
      String stringUserDisabled  // strings.get(178) "User is disabled. Connect to Administrator for more information.",
      ) async {
    try {
      User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: pass)).user;


      if (user == null) {
        dprint("str");
        return stringUserNotFound;

        /// User not found
      }


      var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
      if (!querySnapshot.exists) {
        dprint("str1");
        logout();
        return stringUserNotFound; /// User not found
      }

      var t = querySnapshot.data()!["visible"];
      if (t != null)
        if (!t){
          dprint("str2");
          dprint("User not visible. Don't enter...");
          logout();
          return stringUserDisabled; /// "User is disabled. Connect to Administrator for more information.",
        }

      if (_remember)
        localSettings.saveLogin(email, pass, "email");
      else
        localSettings.saveLogin("", "", "");
    }catch(ex){
      return "login " + ex.toString();
    }
    return null;
  }


  _googleLogin() async {
    _waits(true);
    var ret = await googleLogin();
    _waits(false);
    if (ret != null)
      return messageError(context, ret);
    goBack();
  }

  _facebookLogin() async {
    _waits(true);
    var ret = await facebookLogin();
    _waits(false);
    if (ret != null)
      return messageError(context, ret);
    goBack();
  }

  //
  // Apple
  //


  _appleLogin() async {
    _waits(true);
    var ret = await appleLogin();
    _waits(false);
    if (ret != null)
      return messageError(context, ret);
    goBack();
  }
}


