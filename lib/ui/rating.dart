import 'dart:math';
import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemandservice/widgets/buttons/button200.dart';
import 'package:ondemandservice/widgets/buttons/button201.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import 'strings.dart';
import 'theme.dart';
import 'dialogs/no_internet.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final ScrollController _scrollController = ScrollController();
  final _editControllerReview = TextEditingController();

  late MainModel _mainModel;
  String _dialogName = "";


  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  double _scroller = 20;
  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    _scroller = 20-(_scrollPosition/(windowHeight*0.1/20));
    if (_scroller < 0)
      _scroller = 0;
    setState(() {
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _editControllerReview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);


    _mainModel.setMainWindow(_openDialog);


    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
    child: Stack(
              children: [
                NestedScrollView(
                  controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          expandedHeight: windowHeight*0.2,
                          automaticallyImplyLeading: false,
                          pinned: true,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: ClipPath(
                            clipper: ClipPathClass23((_scroller < 5) ? 5 : _scroller),
                              child: Container(
                              color: (theme.darkMode) ? Colors.black : Colors.white,
                              child: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: _title(),
                            titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                            title: _titleSmall()
                          )),
                        ))
                      ];
                    },
                  body: Container(
                    width: windowWidth,
                    height: windowHeight,
                    child: _body(),
                  ),
                ),
                appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.white,
                    "", context, () {Navigator.pop(context);}),



                IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
                  getBody: _getDialogBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),



                if (_wait)
                  Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

              ]),
        ));
  }

  _title() {
    return Container(
      color: (theme.darkMode) ? Colors.black : Colors.black54,
      height: windowHeight * 0.2,
      width: windowWidth/2,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              /*
              width: windowWidth*0.2,
              child: Image.asset("assets/ondemands/ondemand19.png", fit: BoxFit.cover),
              */
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          ),
        ],
      ),
    );
  }

  _titleSmall(){
    return Container(
        alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _scroller, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(83), // "Review",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(84), // "Leave a Review",
                style: theme.style10W600White),
          ],
        )
    );
  }

  _body(){

    List<Widget> list = [];
    list.add(Container(
        width: windowWidth,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Card49(
         // image: currentOrder.providerAvatar,
          image: getProviderById(currentOrder.providerId)!.logoServerPath,
          text: getTextByLocale(currentOrder.provider, strings.locale),
          text2: strings.get(88), /// "Click on the stars to rate this service",
          //text3: getTextByLocale(currentOrder.service, strings.locale),
          imageRadius: 50,
          initValue: _stars,
          callback: (int stars) { _setStar(stars); },)
    ));


    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: edit42(strings.get(86), // "Write your review",
        _editControllerReview,
        strings.get(87), // "Tell us something about this service",
        )));


    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
      children: [
        Expanded(child: Text(strings.get(90), // "Add Images",
          style: theme.style14W800,)),
        Container(
          /*
          width: windowSize/2,
          child: Image.asset("assets/ondemands/ondemand20.png",
            fit: BoxFit.contain
        )
      */),
    ],
    )));
    list.add(SizedBox(height: 2,));
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /*
        Flexible(child: button200(strings.get(91), /// "From Gallery",
            theme.style16W800,
            (theme.darkMode) ? Colors.black : Colors.white, (){_photo(ImageSource.gallery);}, true)),
        SizedBox(width: 2,),
        */
        /*
        Flexible(child: button201(strings.get(92), /// "From Camera",
            theme.style16W800,
            (theme.darkMode) ? Colors.black : Colors.white, (){_photo(ImageSource.camera);}, true)),
        */
      ],
    ));



    if (_images.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _images.map((e){
            return Container(
                width: windowSize/2-30,
                child: Image.memory(e,
                    fit: BoxFit.contain
                ));
          }).toList(),
        ),
      ));

    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
      child: button2(strings.get(91), Colors.grey, (){_photo(ImageSource.gallery);}), /// "add from galerie",
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
      child: button2(strings.get(92), Colors.grey, (){_photo(ImageSource.camera);}), /// "add from app photo",
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
      child: button2(strings.get(89), theme.mainColor, _confirm), /// "Submit Review",
    ));

    list.add(SizedBox(height: 120,));

    return Container(
      child: ListView(
        children: list,
      )
    );
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

  _confirm() async {
    dprint("rating confirm _stars=$_stars; text=${_editControllerReview.text}");

    if (_editControllerReview.text.isEmpty)
      return messageError(context, strings.get(233)); /// "Please enter text",

    _waits(true);
    var ret = await addReview(_stars, _editControllerReview.text, _images, currentOrder);
    _waits(false);
    if (ret != null) {
      return messageError(context, ret);
    }

    Navigator.pop(context);
  }

  final List<Uint8List> _images = [];

  _photo(ImageSource source) async {
      final pickedFile = await ImagePicker().getImage(
          maxWidth: 1000,
          maxHeight: 1000,
          source: source);
      if (pickedFile != null) {
        _images.add(await pickedFile.readAsBytes());
        setState(() {});
      }
  }

  int _stars = 5;
  _setStar(int stars){
    dprint("start $stars");
    _stars = stars;
    _redraw();
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




















}












