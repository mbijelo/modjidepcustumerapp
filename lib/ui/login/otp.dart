import 'dart:async';

import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/ui/theme.dart';
import '../../other_config.dart';
import '../splash.dart';
import '../strings.dart';
import 'package:ondemandservice/other_config.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'BeginUsingApp.dart';

class OTPScreen extends StatefulWidget {

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  String _verificationId = "";
  String _lastPhone = "";
  String _codeSent = "";


  double windowWidth = 0;
  double windowHeight = 0;
  final _editControllerCode = TextEditingController();

  @override
  void dispose() {
    _editControllerCode.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    dprint("deactivate est appele ici jean louis");
    dprint("debut _out()");
    _out();
    dprint("fin _out()");
    super.deactivate();
  }

  bool _continuePress = false;

  _out() {
    if (!_continuePress)
      logout();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

        ClipPath(
          clipper: ClipPathClass23(20),
          child: Container(
            color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
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
                      Text(strings.get(52), // "Verification",
                          style: theme.style25W800),
                      SizedBox(height: 5,),
                      Text(strings.get(50), // "in less than a minute",
                          style: theme.style16W600Grey),
                    ],
                  ))),

                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.bottomRight,
                      width: windowWidth*0.3,
                      child: Image.asset("assets/ondemands/ondemand4.png",
                          fit: BoxFit.contain
                      ))
                ],


              ),
            )),

            Container(
              margin: EdgeInsets.only(top: windowHeight*0.4),
              height: windowHeight*0.6,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(strings.get(54), // "We've sent 6 digit verification code.",
                          style: theme.style15W400),
                    ),

                    SizedBox(height: 50,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: edit42(strings.get(55), // "Enter code",
                          _editControllerCode,
                          strings.get(56), // "Enter 6 digits code",
                          type: TextInputType.number),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.all(20),
                      child: button2(strings.get(46), theme.mainColor, /// "CONTINUE",
                          (){_continue();}),
                    ),

                  ],
                ),
              ),
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {_out(); goBack(); }),

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








  /*
  _continue() async {
    if (_editControllerCode.text.isEmpty)
      return messageError(context, strings.get(234)); /// "Please enter code",

    _waits(true);
    var ret = await otp1(_editControllerCode.text, appSettings,
      strings.get(225), /// Please enter valid code
    );
    _waits(false);
    if (ret != null)
      return messageError(context, ret);

    _continuePress = true;
    goBack();
    goBack();
  }
*/
  _continue() async {
    if (_editControllerCode.text.isEmpty)
      return messageError(context, strings.get(234)); /// "Please enter code",

    _waits(true);
    var ret;

    try {
      ret = await otp1(_editControllerCode.text, appSettings,
        strings.get(225),

        /// Please enter valid code
      ).timeout(const Duration(seconds: 20));


      _waits(false);
      if (ret != null)
        return messageError(context, ret);

     // _continuePress = true;
     // goBack();
     // goBack();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BeginUsingAppScreen(),
        ),
      );



    }on TimeoutException catch (ee) {
      print('Timeout');
      return messageErrorInternet(context, strings.get(292));
    } on Error catch (e) {
      print('Error : $e');
    }




  }




  bool needOTPParam = false;

  Future<String?> otp1(String code, AppSettings appSettings,
      String stringPleaseEnterCode, // Please enter valid code
      ) async {
    try {

      //
      // Twilio
      //
      if (appSettings.otpTwilioEnable) {
        print("twilo is active");
        var serviceId = appSettings.twilioServiceId;

        var url = 'https://verify.twilio.com/v2/Services/$serviceId/VerificationCheck';
        Map<String, String> requestHeaders = {
          'Accept': "application/json",
          'Authorization' : "Basic ${base64Encode(
              utf8.encode("${appSettings.twilioAccountSID}:${appSettings.twilioAuthToken}"))}",
        };
        Map<String, dynamic> map = {};
        map['To'] = _lastPhone;
        map['Code'] = code;

        var response = await http.post(Uri.parse(url), headers: requestHeaders, body: map).timeout(const Duration(seconds: 30));
        if (response.statusCode == 200) {
          var jsonResult = json.decode(response.body);
          if (jsonResult['status'] != "approved")
            return stringPleaseEnterCode; /// Please enter valid code
          User? user = FirebaseAuth.instance.currentUser;
          if (user == null)
            return "user = null";
          await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
            "phoneVerified": true,
            "phone": _lastPhone,
          }, SetOptions(merge:true));
          needOTPParam = false;
          userAccountData.userPhone = _lastPhone;
          return null;
        }
        return response.reasonPhrase;
      }

      //
      // Firebase
      //
      if (appSettings.otpEnable) {
        print("firebase opt  is active");
        print("verificationId=$_verificationId");
        PhoneAuthCredential _credential = PhoneAuthProvider.credential(verificationId: VERIF_ID, smsCode: code);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          var user1 = await user.linkWithCredential(_credential);
          dprint("linkWithCredential =${user1.user!.uid}");

          await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
            "email":LAST_PHONE+"@modjidep.com",
            "phoneVerified": true,
            "phone": LAST_PHONE,
          }, SetOptions(merge:true));
          needOTPParam = false;
          userAccountData.userPhone = LAST_PHONE;
          setState(() {
            LAST_PHONE="ok";
          });


          var messageToAdmin = "Nouvelle inscription. Client : " + userAccountData.userName + " : " + userAccountData.userPhone;
          // send message to fjeanlouis
          sendMessage(messageToAdmin,  /// "From user:",
              messageToAdmin,  /// "New Booking was arrived",
              "SRbmrirkvvWxcTdU57JDJpYO34I2", true, appSettings.cloudKey);
          // send message to cjeanlouis
          sendMessage(messageToAdmin,  /// "From user:",
              messageToAdmin,  /// "New Booking was arrived",
              "Rb45fBE9WeX1nYvinDTRnJfMTvz2", true, appSettings.cloudKey);


        }
      }

      //
      // Nexmo
      //
      if (appSettings.otpNexmoEnable) {
        print("nexmo is active");
        if (_codeSent == code){
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
              "phoneVerified": true,
              "phone": _lastPhone,
            }, SetOptions(merge:true));
            needOTPParam = false;
            userAccountData.userPhone = _lastPhone;
          }else
            return stringPleaseEnterCode; /// "Please enter valid code",
        }
      }

      //
      // SMS to
      //
      if (appSettings.otpSMSToEnable) {
        print("SMSto is active");
        if (_codeSent == code){
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
              "phoneVerified": true,
              "phone": _lastPhone,
            }, SetOptions(merge:true));
            needOTPParam = false;
            userAccountData.userPhone = _lastPhone;
          }
        }else
          return stringPleaseEnterCode; /// "Please enter valid code",
      }

    }catch(ex){
      return "otp " + ex.toString();
    }
    return null;

  }// otp







}



