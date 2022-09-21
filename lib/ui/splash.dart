import 'dart:async';
import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import 'login/login.dart';
import 'strings.dart';
import 'lang.dart';
import 'theme.dart';
import 'dialogs/no_internet.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  late MainModel _mainModel;
  String _dialogName = "";

  _startNextScreen(){
    dprint("sdebut12");
    if (_loaded) {
      dprint("sdebut13");
      if (!_startLoaded) {
        dprint("sdebut15");
        _startLoaded = true;
        Navigator.pop(context);
        /*
        if (localSettings.locale.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LanguageScreen(openFromSplash: true),
            ),
          );
        }else
          Navigator.pushNamed(context, "/ondemandservice_main");
        */
        _mainModel.lang.setLang("fr", context);

         Navigator.pushNamed(context, "/ondemandservice_main");

      }
    }else{
      dprint("sdebut14");
    }
  }





  @override
  void initState() {
    dprint("sdebut1");

    _mainModel = Provider.of<MainModel>(context,listen:false);
    dprint("sdebut2");
    super.initState();
    dprint("sdebut3");
    _load();
    dprint("sdebut4");
    startTime();
    dprint("sdebut5");
  }

  bool _loaded = false;
  bool _startLoaded = false;

  _load() async {
    dprint("sdebut6");
    var ret = await _mainModel.init(context);
    dprint("sdebut7");
    if (ret != null) {
      dprint("sdebut8");
      messageError(context, ret);
      dprint("sdebut9");
      _loaded = true;
      dprint("sdebut10");
      return startTime();
    }
    dprint("SplashScreen");
    _loaded = true;
    _startNextScreen();
  }




  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  double _show = 0;

  _openDialog(String val){
    _dialogName = val;
    _show = 1;
    _redraw();
  }



  Widget _getDialogBody(){

    var i = 0;
    var dialogName = "";
    var text = "";
    while(i < _dialogName.length){
      if(_dialogName[i] != '²') {
        dialogName = dialogName+_dialogName[i];

      }
      else{
        break;
      }
      i++;
    }
    dprint("dialogName : " + dialogName);

    i++;
    while(i < _dialogName.length){
      text = text+_dialogName[i];
      i++;
    }
    dprint("text : " + text);


    var trouve = false;



    if(text=="otp [firebase_auth/invalid-verification-code] The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user."){
      text= strings.get(225);
      trouve = true;
    }

    else if(text=="model login [firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."){
      text= strings.get(137);
      trouve = true;
    }

    else if(text=="model login [firebase_auth/wrong-password] The password is invalid or the user does not have a password."){
      text= strings.get(45);
      trouve = true;
    }

    else if(text=="model login [firebase_auth/unknown] com.google.firebase.FirebaseException: An internal error has occurred. [ unexpected end of stream on com.android.okhttp.Address@92f413c0 ]"){
      text= strings.get(292);
      trouve = true;
    }
    else {
      var increment = 0;
      while (increment < 1000) {
        if (strings.get(increment) == text){
          trouve = true;
          break;
        }
        increment++;
      }
    }



    dprint("trouve:"+text);

    if(trouve) {
      if (dialogName == "getError")
        return getError(() {
          _show = 0;
          _redraw();
        }, _mainModel, context, text);
    }else {
        return getError(() {
          _show = 0;
          _redraw();
        }, _mainModel, context, "");
    }


    if (dialogName == "AfterOtpConfirmWell")
      return getMessageAfterOtpWell((){
        _show = 0;
        _redraw();
      }, _mainModel, context, text);



    return getBodyDialogExit(strings.get(178), strings.get(179), strings.get(180),
            (){_show = 0;_redraw();});  /// Are you sure you want to exit? No Exit
  }



  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, _startNextScreen);
  }

  @override
  Widget build(BuildContext context) {

    _mainModel.setMainWindow(_openDialog);

    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    dprint("splash theme.logoAsset=${theme.logoAsset} theme.logo=${theme.logo}");
    return Scaffold(
        body: Stack(
          children: <Widget>[

         // Container(color: (theme.darkMode) ? Colors.black : theme.colorBackground),
            Container(color: (theme.darkMode) ? Colors.black : Colors.white),

          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: windowWidth*0.2,
                    height: windowWidth*0.2,
                    child: theme.logoAsset ? Image.asset("assets/ondemands/ondemand1.png", fit: BoxFit.contain) :
                    CachedNetworkImage(
                      imageUrl: theme.logo,
                      imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(strings.get(1), /// "SERVICE",
                      style: theme.style10W600Grey1),
                  SizedBox(height: 20,),

                  Text(strings.get(287), /// "COPYRIGHT",
                      style: theme.style10W600Grey11),

                  SizedBox(height: 20,),

                  Text(strings.get(293), /// "COPYRIGHT",
                      style: theme.style10W600Grey11),

                  SizedBox(height: 20,),
                  //Loader7v1(color: theme.splashColor)
                  Loader7v1(color: Colors.black)
                ],
              ),
            ),
            /*
            Container(
              alignment: Alignment.bottomCenter,
              child: UnconstrainedBox(
                  child: Container(
                      width: windowWidth,
                      height: windowWidth/2,
                      child: theme.splashImageAsset ?
                      Image.asset("assets/ondemands/ondemand2.png",
                          fit: BoxFit.cover
                      ) :
                      Image.network(
                          theme.splashImage,
                          fit: BoxFit.cover)
                  )
                  )
            )
             */
            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
              getBody: _getDialogBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),
          ],
        )

    );
  }

}


