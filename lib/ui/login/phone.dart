import 'dart:async';

import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/ui/login/otp.dart';
import '../splash.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:ondemandservice/other_config.dart';
import '../login/login.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'BeginUsingApp.dart';

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {

  String _verificationId = "";
  String _lastPhone = "";
  String _codeSent = "";


  double windowWidth = 0;
  double windowHeight = 0;
  final _editControllerPhone = TextEditingController();
  final _editControllerCode = TextEditingController();

  bool _alreadySent = false;
  bool _codeComparaisonInProcess = false;

  @override
  void dispose() {
    _editControllerPhone.dispose();
    super.dispose();
  }


  @override
  void initState() {
    _waits(true);
    dprint("TEXT_OTPjean:"+ TEXT_OTP);
    if(TEXT_OTP=="TEXT_OTP") {
       dprint("TEXT_OTPcontinue:"+ TEXT_OTP);
      _continue1();
      super.initState();
    }else{
      dprint("TEXT_OTPgoback:"+ TEXT_OTP);
      setState(() {
        TEXT_OTP="TEXT_OTP";
      });
      dprint("TEXT_OTPgoback1:"+ TEXT_OTP);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
      /*
      dprint("TEXT_OTPgoback:"+ TEXT_OTP);
      setState(() {
        TEXT_OTP="TEXT_OTP";
      });
      dprint("TEXT_OTPgoback1:"+ TEXT_OTP);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
      */
    }

  }


  @override
  Widget build(BuildContext context) {
    _waits(true);
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
                      )),
                ],


              ),
            )),


            if(!_alreadySent)
            Container(
              margin: EdgeInsets.only(top: windowHeight*0.3),
              height: windowHeight*0.9,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(height: 20,),

                   /*
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(appSettings.otpPrefix,
                              style: theme.style18W800),
                          SizedBox(width: 10,),
                          Expanded(child: edit42(strings.get(25), // "Phone number",
                              _editControllerPhone,
                              //strings.get(26),  //"Enter your Phone number",
                              LAST_PHONE1,
                              type: TextInputType.phone)),
                        ],
                      )
                    ),
                    */

                    SizedBox(height: 50,),

                    Center(
                      child:
                      Text(strings.get(53), // "We'll sent verification code.",
                          style: theme.style15W400),
                    ),

                    SizedBox(height: 50,),
/*
                    Container(
                      margin: EdgeInsets.all(20),
                      child: button2(strings.get(46), theme.mainColor, _continue), /// "CONTINUE",
                    ),

*/

                  ],
                ),
              ),
            ),


            if(_alreadySent)
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
                                (){_continue2();}),
                      ),

                    ],
                  ),
                ),
              ),


            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {_out(); goBack();}),

            if (_wait && !_alreadySent)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

            if (_wait && _codeComparaisonInProcess)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),


          ],
        )

    ));
  }

  bool _wait = true;
  _waits(bool value){
    _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  bool _continuePress = false;
  @override
  void deactivate() {
    dprint("deactivate de phone.dart debut");
    _out();
    dprint("deactivate de phone.dart fin");
    super.deactivate();
  }

  _out() {
    if (!_continuePress)
      logout();
  }


  _continue1() async {
    /*
    if (_editControllerPhone.text.isEmpty)
      return messageError(context, strings.get(26)); /// "Enter your phone number",
   */
    _continuePress = true;

    login(){
      goBack();
    }

    _goToCode(){
      //route("otp");
      _alreadySent = true;
      _redraw();
    }

    _waits(true);
    var ret = await sendOTPCode1(LAST_PHONE1, context, login, _goToCode,
        appSettings, strings.get(143)); /// Code sent. Please check your phone for the verification code.
    _waits(false);


    if (ret != null)
      messageError(context, ret);


  }



  _continue() async {
    if (_editControllerPhone.text.isEmpty)
      return messageError(context, strings.get(26)); /// "Enter your phone number",

    _continuePress = true;

    login(){
      goBack();
    }

    _goToCode(){
      route("otp");
    }

    _waits(true);
    var ret = await sendOTPCode1(_editControllerPhone.text, context, login, _goToCode,
        appSettings, strings.get(143)); /// Code sent. Please check your phone for the verification code.
    _waits(false);


    if (ret != null)
      messageError(context, ret);


  }




  Future<String?> sendOTPCode1(String phone, BuildContext context,
      Function() login, Function() _goToCode, AppSettings appSettings,
      String stringCodeSent, //  Code sent. Please check your phone for the verification code.
      ) async { // parent.appSettings

    _lastPhone = checkPhoneNumber("${appSettings.otpPrefix}$phone");
    // var _sym = localAppSettings.otpPrefix.length+localAppSettings.otpNumber;
    // if (_lastPhone.length != _sym)
    //   return "${strings.get(141)} $_sym ${strings.get(142)}"; /// "Phone number must be xx symbols",

    try {

      //
      // Twilio
      //
      if (appSettings.otpTwilioEnable) {
        dprint("Twilio");
        var serviceId = appSettings.twilioServiceId;
        var url = 'https://verify.twilio.com/v2/Services/$serviceId/Verifications';
        Map<String, String> requestHeaders = {
          'Accept': "application/json",
          'Authorization' : "Basic ${base64Encode(
              utf8.encode("${appSettings.twilioAccountSID}:${appSettings.twilioAuthToken}"))}",
        };

        Map<String, dynamic> map = {};
        map['To'] = _lastPhone;
        map['Channel'] = "sms";

        var response = await http.post(Uri.parse(url), headers: requestHeaders,
            body: map).timeout(const Duration(seconds: 30));
        if (response.statusCode == 201) {
          messageOk(context, stringCodeSent); /// Code sent. Please check your phone for the verification code.
          _goToCode();
          return null;
        }else
          return response.reasonPhrase;
      }




      //firebase send code otp
      if (appSettings.otpEnable) {
        dprint("fcm");
        _verificationId = "";
        dprint("sendOTPCode $_lastPhone}");

        if (kIsWeb){
          dprint("sendOTPCode $_lastPhone}");
          ConfirmationResult? result;
          result = await FirebaseAuth.instance.signInWithPhoneNumber(_lastPhone);
          _verificationId = result.verificationId;
          _goToCode();
        }else{
          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: _lastPhone,
              timeout: const Duration(seconds: 60),
              verificationCompleted: (PhoneAuthCredential credential) async {
                /*s
                dprint("Verification complete. number=$_lastPhone code=${credential.smsCode}");
                await FirebaseAuth.instance.signInWithCredential(credential);
                login();
                */
              },
              verificationFailed: (FirebaseAuthException e) {
                dprint('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
                messageError(context, 'Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
              },
              codeSent: (String _verificationId, int? resendToken) {
                _verificationId = _verificationId;
                dprint('Code sent. Please check your phone for the verification code. verificationId=$_verificationId');

                dprint("VERIF_ID :"  +  VERIF_ID);
                dprint("LAST_PHONE :"  +  LAST_PHONE);
                dprint("TEXT_OTP :"  +  TEXT_OTP);
                setState(() {
                   VERIF_ID = _verificationId;
                   LAST_PHONE = checkPhoneNumber("${appSettings.otpPrefix}$phone");
                   TEXT_OTP = "ok";
                 });
                dprint("VERIF_ID :"  +  VERIF_ID);
                dprint("LAST_PHONE :"  +  LAST_PHONE);
                dprint("TEXT_OTP :"  +  TEXT_OTP);


                messageOk(context, stringCodeSent); /// 'Code sent. Please check your phone for the verification code.'
                _goToCode();
              },
              codeAutoRetrievalTimeout: (String _verificationId) {
                dprint('codeAutoRetrievalTimeout Time Out');
                _verificationId = "";
                messageError(context, 'Time Out');
              }
          );
        }
      }

      //
      // Nexmo
      //
      if (appSettings.otpNexmoEnable) {
        dprint("nexmo");
        _codeSent = generateCode6();
        var _text = appSettings.nexmoText.replaceFirst("{code}", _codeSent);
        dprint("otpNexmoEnable $_text}");
        if (_lastPhone.startsWith("+"))
          _lastPhone = _lastPhone.substring(1);

        Response response;
        if (kIsWeb){
          Map<String, dynamic> _body = {};
          _body['url'] = "https://rest.nexmo.com/sms/json";
          _body['backurl'] = currentHost;
          _body['from'] = appSettings.nexmoFrom;
          _body['text'] = "$_text ";
          _body['to'] = _lastPhone;
          _body['api_key'] = appSettings.nexmoApiKey;
          _body['api_secret'] = appSettings.nexmoApiSecret;
          response = await http.post(Uri.parse("https://www.abg-studio.com/proxyNexmo.php"),
              body: _body,
              headers: {
                'Accept': "application/json",
              });
          final body = convert.jsonDecode(response.body);
          print("otpNexmo Send body=$body");
          if (body["code"] == 200){
            messageOk(context, stringCodeSent); /// 'Code sent. Please check your phone for the verification code.'
            _goToCode();
          }
        }else{
          response = await http.post(Uri.parse("https://rest.nexmo.com/sms/json"),
              body: convert.jsonEncode({
                "from": appSettings.nexmoFrom,
                "text" : "$_text ",
                "to" : _lastPhone,
                "api_key": appSettings.nexmoApiKey,
                "api_secret": appSettings.nexmoApiSecret
              }),
              headers: {
                "content-type": "application/json",
              });
          final body = convert.jsonDecode(response.body);
          dprint("otpNexmo Send body=$body");
          if (response.statusCode == 200){
            messageOk(context, stringCodeSent); /// 'Code sent. Please check your phone for the verification code.'
            _goToCode();
          }
        }


      }

      //
      // SMS.to
      //
      if (appSettings.otpSMSToEnable) {
        dprint("sms.to");
        _codeSent = generateCode6();
        // DEBUG
        // messageOk(context, strings.get(179)); /// 'Code sent. Please check your phone for the verification code.'
        // return _goToCode();

        var _text = appSettings.smsToText.replaceFirst("{code}", _codeSent);

        Response response;
        if (kIsWeb){
          //curl -L -X GET "https://api.sms.to/sms/send?api_key={api_key}&to=+35794000001&message=This is test and %0A this is a new line&sender_id=smsto"\
          response = await http.get(Uri.parse(
              "https://api.sms.to/sms/send?api_key=${appSettings.smsToApiKey}&to=$_lastPhone"
                  "&message=$_text&sender_id=${appSettings.smsToFrom}"),
          );
        }else {
          dprint("otpSMSToEnable $_text}");
          response = await http.post(Uri.parse("https://api.sms.to/sms/send"),
              body: convert.jsonEncode({
                "message": _text,
                "to": _lastPhone,
                "bypass_optout": false,
                "sender_id": appSettings.smsToFrom,
                "callback_url": ""
              }),
              headers: {
                "content-type": "application/json",
                "Authorization": "Bearer ${appSettings.smsToApiKey}",
              });
        }
        final body = convert.jsonDecode(response.body);
        dprint("SMSTo Send body=$body");
        if (response.statusCode == 200){
          messageOk(context, stringCodeSent); /// 'Code sent. Please check your phone for the verification code.'
          _goToCode();
        }
      }

    }catch(ex){
      return "sendOTPCode " + ex.toString();
    }

    return null;

  }// end sendOTPCode





  _continue2() async {
    if (_editControllerCode.text.isEmpty)
      return messageError(context, strings.get(234)); /// "Please enter code",
    _codeComparaisonInProcess = true;
    _waits(true);
    var ret;

    try {
      ret = await otp1(_editControllerCode.text, appSettings,
        strings.get(225),

        /// Please enter valid code
      ).timeout(const Duration(seconds: 20));



      if (ret != null) {
        _codeComparaisonInProcess = false;
        _waits(false);
        return messageError(context, ret);
      }

      // _continuePress = true;
      // goBack();
      // goBack();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BeginUsingAppScreen(),
        ),
      );
      _codeComparaisonInProcess = false;


    }on TimeoutException catch (ee) {
      _codeComparaisonInProcess = false;
      _waits(false);
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
        print("verificationId1="+VERIF_ID);
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

  }




}


