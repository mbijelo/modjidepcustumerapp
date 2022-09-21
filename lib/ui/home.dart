import 'dart:io';
import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/login/BeginUsingApp.dart';
import 'package:ondemandservice/ui/search.dart';
import 'package:ondemandservice/ui/service_item.dart';
import 'package:ondemandservice/widgets/buttons/button202m.dart';
import 'package:ondemandservice/widgets/horizontal_articles.dart';
import 'OffDate.dart';
import 'devab.dart';
import 'strings.dart';
import 'elements/address.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/buttons/button202nn.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  final _controllerSearch = TextEditingController();
  String _version = "v2.7.0+29";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late MainModel _mainModel;

  @override
  void initState() {
    /*
    DateTime dt1 = DateTime.parse(appSettings.adminEmail);
    DateTime dt2 = DateTime.now();
    dprint(dt2.toString());
    if(dt1.compareTo(dt2) < 0){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OffDateScreen(),
        ),
      );
    }
    */
    _mainModel = Provider.of<MainModel>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    comboBoxInitAddress(_mainModel);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var t = routeGetPosition();
      dprint("position : " + t.toString());
      if (t != 0)
        _scrollController2.animateTo(t, duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
    });
    super.initState();
  }

  double _scroller = 20;

  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    _scroller = 20 - (_scrollPosition / (windowHeight * 0.1 / 20));
    if (_scroller < 0)
      _scroller = 0;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controllerSearch.dispose();
    super.dispose();
  }















  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);


    return Scaffold(
        //backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
        body: Directionality(
          textDirection: strings.direction,
          child: Stack(
              children: [

              if (_mainModel.searchActivate)
                SearchScreen(
                  jump: () {
                    _scrollController.jumpTo(96);
                  }, close: () {
                  _mainModel.searchActivate = false;
                  _redraw();
                },
                ),

              if(appSettings.adminEmail == _version || appSettings.adminEmail == "waitingForServerAdminEmail")
              if (!_mainModel.searchActivate)
                _showHomeScreen(),


                if(appSettings.adminEmail != _version && appSettings.adminEmail != "waitingForServerAdminEmail")
                 _showOffDateScreen(),






              ]),
        ));
  }


  /*
  _title() {
    return Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      height: windowHeight * 0.3,
      width: windowWidth / 2,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              width: windowWidth * 0.3,
              height: windowWidth * 0.3,
              child: theme.homeLogoAsset ? Image.asset(
                  "assets/ondemands/ondemand23.png", fit: BoxFit.contain) :
              CachedNetworkImage(
                  imageUrl: theme.homeLogo,
                  imageBuilder: (context, imageProvider) =>
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
              ),
              //Image.asset("assets/ondemands/ondemand23.png", fit: BoxFit.cover),
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          ),
        ],
      ),
    );
  }
*/


  _showHomeScreen(){
    _mainModel.showBottomBar = true;
    setState(() {});
    return  NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context,
            bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
                expandedHeight: windowHeight * 0.16,
                automaticallyImplyLeading: false,
                pinned: true,
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                flexibleSpace: ClipPath(
                  clipper: ClipPathClass23(
                      (_scroller < 5) ? 5 : _scroller),
                  child: Container(
                      color: (theme.darkMode) ? Colors.black : Colors.white,
                      child: Stack(
                        children: [
                          FlexibleSpaceBar(
                              collapseMode: CollapseMode.pin,
                              //background: _title(),
                              titlePadding: EdgeInsets.only(
                                  left: 20, right: 20),

                              title: _titleSmall()
                          )
                        ],
                      )),
                ))
          ];
        },
        body: Builder(
            builder: (BuildContext context) {
              _scrollController2 = PrimaryScrollController.of(context)!;
              _scrollController2.addListener(() {
                routeSavePosition(_scrollController2.position.pixels);
              });

              return Container(
                width: windowWidth,
                height: windowHeight,
                child: Stack(
                  children: [
                    _body(),
                    if (_wait)
                      Center(child: Container(
                        //child: Loader7v1(color: theme.mainColor,))),
                          child: Loader7v1(color: Colors.black,))),
                  ],
                ),
              );
            })) ;

  }













  _showOffDateScreen(){
    _mainModel.showBottomBar = false;
    setState(() {});
   return  ListView(
      children: [

        ClipPath(
            clipper: ClipPathClass23(20),
            child: Container(
              //color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
              color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
              width: windowWidth,
              height: windowHeight/3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Text("", // "SERVICE",
                      style: theme.style10W600Grey11),
                ],
              ),
            )),

        Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Column(
            children: [
              Center(
                child: Text(strings.get(302), // "",
                  style: theme.style16W800,
                ),
              ),

              SizedBox(height: 20,),

              Container(
                margin: EdgeInsets.all(20),
                //child: button2(strings.get(46), theme.mainColor, _login), /// "CONTINUE",
                child: button2(strings.get(114), Colors.green,
                        (){





                      if (Platform.isAndroid) {
                        try {
                          launch("market://details?id=" + "com.abg.modjiapp");
                        } on PlatformException catch(e) {
                          launch("https://play.google.com/store/apps/details?id=" + "com.abg.modjiapp");
                        } finally {
                          launch("https://play.google.com/store/apps/details?id=" + "com.abg.modjiapp");
                        }
                      } else if (Platform.isIOS) {
                        exit(0);
                      }

                      /*
                                if (Platform.isAndroid) {
                                  SystemNavigator.pop();
                                } else if (Platform.isIOS) {
                                  exit(0);
                                }
                                */






                    }
                ), /// "CONTINUE",
              ),

              SizedBox(height: 10,),

            ],
          ),
        ),

      ],
    );
  }

  _titleSmall() {
    return InkWell(
      //  alignment: Alignment.bottomLeft,
       // padding: EdgeInsets.only( bottom: _scroller, left: 20, right: 20, top: 25),
      onTap: () {
        ontaptitle();
      },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              !_mainModel.searchActivate ? strings.get(93) : strings.get(122), /// "Home services", // "Search",
              style: theme.stylee16W800,),

            Text(strings.get(94), // Find what you need
                style: theme.style10W600Grey111),
            SizedBox(height: 15,),
          ],
        ),


    );

  }




  int _counter = 0;
  int hour=0;
  int minute=0;
  int seconde=0;
  ontaptitle(){
    DateTime now = DateTime.now();
    int h = now.hour;
    int m = now.minute;
    int s = now.second;
    if(hour == h && minute == m){
      if(s-seconde < 10){
        print(h.toString() + "=" + hour.toString());
        print(m.toString() + "=" + minute.toString());
        print(s.toString() + "=" + seconde.toString());
        setState(() {
          hour=h;
          minute=m;
          seconde=s;
          _counter++;
        });
        print("counter" + _counter.toString() + "valider");
      }else{
        print(h.toString() + "=" + hour.toString());
        print(m.toString() + "=" + minute.toString());
        print(s.toString() + "=" + seconde.toString());
        setState(() {
          hour=h;
          minute=m;
          seconde=s;
          _counter=0;
        });
        print("counter" + _counter.toString() + "initialisé à 1 first");
      }
    }else{
      print(h.toString() + "=" + hour.toString());
      print(m.toString() + "=" + minute.toString());
      print(s.toString() + "=" + seconde.toString());
      setState(() {
        hour=h;
        minute=m;
        seconde=s;
        _counter=0;
      });
      print("counter" + _counter.toString() + "initialisé à 1");
    }
    if(_counter > 10){
      _counter=0;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return DevabScreen();
          }));
    }
  }







  _body() {
    List<Widget> list = [];

    //
    // address
    //

    /*
    list.add(Row(
      children: [

        Expanded(
          flex: 2,
          child: comboBoxAddress(_mainModel)),
        SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: button2(strings.get(222), theme.mainColor, (){ /// "Nearby you",
            route("nearby");
          }),
        ),
        SizedBox(width: 10),
      ],
    ));
*/



    list.add(SizedBox(height: 0,));

    for (var item in appSettings.customerAppElements) {

      //
      // search
      //
      /*
      if (item == "search") {
        list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Edit26(
            hint: strings.get(95),  /// "Search service",
            color: (theme.darkMode) ? Colors.black : Colors.white,
            style: theme.style14W400,
            decor: decor,
            useAlpha: false,
            icon: Icons.search,
            controller: _controllerSearch,
            onTap: () {
              _mainModel.searchActivate = true;
              _redraw();
            },
            onChangeText: (String val) {
            },
          ),),
        );
        list.add(SizedBox(height: 10,));
      }
      */

      //
      // Providers
      //
    /*
      if (item == "providers" && blog.isNotEmpty) {
        list.add(Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(child: Text(strings.get(224), style: theme.style14W800,)), /// "Providers",
                InkWell(
                    onTap: () {
                      route("providers_all");
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(strings.get(175), style: theme.style12W600Blue,) /// View all
                    ))
              ],
            )));
        list.add(SizedBox(height: 10,));
        _addProviders(list);
        list.add(SizedBox(height: 10,));
      }
    */
      //
      // blog
      //
    /*
      if (item == "blog" && blog.isNotEmpty) {
        list.add(Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                    child: Text(strings.get(174), style: theme.style14W800,)), /// "Blog",
                InkWell(
                    onTap: () {
                      route("blog_all");
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          strings.get(175), style: theme.style12W600Blue,) /// View all
                    ))
              ],
            )));
        _addBlog(list);
        list.add(SizedBox(height: 10,));
      }
    */
      //
      // banner
      //
    /*
      if (item == "banner") {
        list.add(SizedBox(height: 10,));
        if (banners.isNotEmpty)
          list.add(IBanner(
            banners,
            width: windowWidth,
            height: windowWidth * 0.35,
            colorActive: theme.mainColor,
            colorProgressBar: theme.mainColor,
            radius: theme.radius,
            shadow: 0,
            callback: _openBanner,
            seconds: 3,
          ));
        list.add(SizedBox(height: 0,));
      }
    */

      // category
      //
      /*
      if (item == "category") {
        List<Widget> list2 = [];
        for (var e in categories){
          if (e.parent.isNotEmpty)
            continue;
          list2.add(button157(
              getTextByLocale(e.name, strings.locale),
              e.color,
              e.serverPath, () {
                _mainModel.categoryData = e;
                route("category");
              },
              windowWidth / 2 - 20,
              windowWidth * 0.25, direction: strings.direction),
          );
        }
        list.add(Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: list2,
            )));
        list.add(SizedBox(height: 20,));
      }

*/




      if (item == "category") {
        User? user = FirebaseAuth.instance.currentUser;
        List<Widget> list1 = [];
        List<Widget> list2 = [];
        List<CategoryData> ListCategorieAvecTextPlusGrandQue22 = [];
        var index = 0;
        var i = 0;
        var CNameFrench = "";
        var CNameEnglish = "";
        var CNameArabic = "";
        for (var e in categories) {
          i = 0;
          CNameFrench = "";
          while (i < e.name[0].text.length) {
            if (e.name[0].text[i] != "²") {
              CNameFrench = CNameFrench + e.name[0].text[i];
            }
            else {
              break;
            }
            i++;
          }
          dprint("CNameFrench : " + CNameFrench);


          i++;
          CNameEnglish = "";
          while (i < e.name[0].text.length) {
            if (e.name[0].text[i] != '²') {
              CNameEnglish = CNameEnglish + e.name[0].text[i];
            }
            else {
              break;
            }
            i++;
          }
          dprint("CNameEnglish : " + CNameEnglish);


          i++;
          CNameArabic = "";
          while (i < e.name[0].text.length) {
            CNameArabic = CNameArabic + e.name[0].text[i];
            i++;
          }
          dprint("CNameArabic : " + CNameArabic);


          String realText = "";
          if (strings.locale == "en") {
            realText = CNameEnglish;
          }
          else if (strings.locale == "fr") {
            realText = CNameFrench;
          }
          else if (strings.locale == "ar") {
            realText = CNameArabic;
          }
          else {
            realText = "";
          }


          if (e.parent.isNotEmpty)
            continue;
          var _tag = UniqueKey().toString();
          if (realText.length <= 22){
          if (index <= 2) {
            list1.add(Hero(
                tag: _tag,
                child: Container(

                    width: windowSize / 3,
                    //height: windowHeight*100,
                    child: Stack(
                      children: [
                        button157(
                          // getTextByLocale(e.name, strings.locale),
                            "",
                            // e.color,
                            Colors.white,
                            e.serverPath,
                                () {
                              _mainModel.categoryData = e;
                              route("category");
                            },
                            windowWidth / 3,
                            windowWidth * 0.22,
                            direction: strings.direction),


                        Container(

                            margin: EdgeInsets.only(
                                left: 0, top: windowWidth / 5),
                            padding: EdgeInsets.only(
                                left: 20, right: 00, top: 0, bottom: 0)
                            ,
                            alignment: Alignment.center,
                            child: Text(
                              //getTextByLocale(e.name, strings.locale),
                                  strings.locale == "en" ? CNameEnglish
                                  : strings.locale == "fr" ? CNameFrench
                                  : strings.locale == "ar" ? CNameArabic
                                  : "",
                              style: theme.style10W600Grey1112,)

                          /// View all
                        )

                      ],
                    ))
            ));

            if (index == 2) {
              index = 0;
              list.add(Container(
                height: windowSize * 0.7 * 0.5,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: list1,
                ),
              ),
              );
              list1 = [];
              list.add(SizedBox(height: windowSize / 25,));
            }
            else {
              index ++;
            }
          }
        }
          else
            {

              ListCategorieAvecTextPlusGrandQue22.add(e);
              dprint("il a plus de 22 caracteres :" + realText );
            }
        }












        for(var x in ListCategorieAvecTextPlusGrandQue22){
          i = 0;
          CNameFrench = "";
          while (i < x.name[0].text.length) {
            if (x.name[0].text[i] != "²") {
              CNameFrench = CNameFrench + x.name[0].text[i];
            }
            else {
              break;
            }
            i++;
          }
          dprint("CNameFrench : " + CNameFrench);


          i++;
          CNameEnglish = "";
          while (i < x.name[0].text.length) {
            if (x.name[0].text[i] != '²') {
              CNameEnglish = CNameEnglish + x.name[0].text[i];
            }
            else {
              break;
            }
            i++;
          }
          dprint("CNameEnglish : " + CNameEnglish);


          i++;
          CNameArabic = "";
          while (i < x.name[0].text.length) {
            CNameArabic = CNameArabic + x.name[0].text[i];
            i++;
          }
          dprint("CNameArabic : " + CNameArabic);


          String realText = "";
          if (strings.locale == "en") {
            realText = CNameEnglish;
          }
          else if (strings.locale == "fr") {
            realText = CNameFrench;
          }
          else if (strings.locale == "ar") {
            realText = CNameArabic;
          }
          else {
            realText = "";
          }


          if (x.parent.isNotEmpty)
            continue;
          var _tag = UniqueKey().toString();
            if (index <= 2) {
              list1.add(Hero(
                  tag: _tag,
                  child: Container(

                      width: windowSize / 3,


                      //height: windowHeight*100,
                      child: Stack(
                        children: [
                          button157(
                            // getTextByLocale(e.name, strings.locale),
                              "",
                              // e.color,
                              Colors.white,
                              x.serverPath,
                                  () {
                                _mainModel.categoryData = x;
                                route("category");
                              },
                              windowWidth / 3,
                              windowWidth * 0.22,
                              direction: strings.direction),


                          Container(

                              margin: EdgeInsets.only(
                                  left: 0, top: windowWidth / 5),
                              padding: EdgeInsets.only(
                                  left: 20, right: 00, top: 10, bottom: 0)
                              ,
                              alignment: Alignment.center,
                              child: Text(
                                //getTextByLocale(e.name, strings.locale),
                                strings.locale == "en" ? CNameEnglish
                                    : strings.locale == "fr" ? CNameFrench
                                    : strings.locale == "ar" ? CNameArabic
                                    : "",
                                style: theme.style10W600Grey11120,)

                            /// View all
                          )

                        ],
                      ))
              ));

              if (index == 2) {
                index = 0;
                list.add(Container(
                  height: windowSize * 0.7 * 0.5,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: list1,
                  ),
                ),
                );
                list1 = [];
                list.add(SizedBox(height: windowSize / 25,));
              }
              else {
                index ++;
              }
            }
        }

        list.add(SizedBox(height: windowSize /3,));

        /*
        User? user = FirebaseAuth.instance.currentUser;
        List<Widget> list1 = [];
        List<Widget> list2 = [];
        List<Widget> list3 = [];
        var index = 0;
        var i = 0;
        var CNameFrench = "";
        var CNameEnglish = "";
        var CNameArabic = "";
        for (var e in categories) {





           i = 0;
          CNameFrench = "";
          while(i < e.name[0].text.length){
            if(e.name[0].text[i] != "²") {
              CNameFrench = CNameFrench+e.name[0].text[i];
            }
            else{
              break;
            }
            i++;
          }
          dprint("CNameFrench : " + CNameFrench);


          i++;
          CNameEnglish = "";
          while(i < e.name[0].text.length){
            if(e.name[0].text[i] != '²') {
              CNameEnglish = CNameEnglish+e.name[0].text[i];
            }
            else{
              break;
            }
            i++;
          }
          dprint("CNameEnglish : " + CNameEnglish);


          i++;
          CNameArabic = "";
          while(i < e.name[0].text.length){
            CNameArabic = CNameArabic+e.name[0].text[i];
            i++;
          }
          dprint("CNameArabic : " + CNameArabic);








          if (e.parent.isNotEmpty)
            continue;
          var _tag = UniqueKey().toString();

          if (index <= 7){
            list1.add(Hero(
                tag: _tag,
                child: Container(

                    width: windowSize / 3,
                    //height: windowHeight*100,
                    child: Stack(
                      children: [
                        button157(
                          // getTextByLocale(e.name, strings.locale),
                            "",
                            // e.color,
                            Colors.white,
                            e.serverPath,
                                () {
                          _mainModel.categoryData = e;
                          route("category");
                        },
                            windowWidth / 3,
                            windowWidth * 0.22,
                            direction: strings.direction),


                        Container(

                            margin: EdgeInsets.only(
                                left: 0, top: windowWidth / 5),
                            padding: EdgeInsets.only(
                                left: 20, right: 00, top: 0, bottom: 0),
                            alignment: Alignment.center,
                            child: Text(
                              //getTextByLocale(e.name, strings.locale),
                              strings.locale  == "en" ? CNameEnglish : strings.locale == "fr" ? CNameFrench : strings.locale == "ar" ? CNameArabic : "",
                              style: theme.style10W600Grey1112,)

                          /// View all
                        )

                      ],
                    ))
            ));
        }

          else if (index > 7 && index <= 15){
            list2.add(Hero(
                tag: _tag,
                child: Container(

                    width: windowSize / 3,
                    //height: windowHeight*100,
                    child: Stack(
                      children: [
                        button157(
                          // getTextByLocale(e.name, strings.locale),
                            "",
                            // e.color,
                            Colors.white,
                            e.serverPath, () {
                          _mainModel.categoryData = e;
                          route("category");
                        },
                            windowWidth / 3,
                            windowWidth * 0.22,
                            direction: strings.direction),


                        Container(

                            margin: EdgeInsets.only(
                                left: 0, top: windowWidth / 5),
                            padding: EdgeInsets.only(
                                left: 20, right: 00, top: 0, bottom: 0),
                            alignment: Alignment.center,
                            child: Text(
                              //getTextByLocale(e.name, strings.locale),
                              strings.locale  == "en" ? CNameEnglish : strings.locale == "fr" ? CNameFrench : strings.locale == "ar" ? CNameArabic : "",
                              style: theme.style10W600Grey1112,)

                          /// View all
                        )

                      ],
                    ))
            ));
          }



          else{
            list3.add(Hero(
                tag: _tag,
                child: Container(

                    width: windowSize / 3,
                    //height: windowHeight*100,
                    child: Stack(
                      children: [
                        button157(
                          // getTextByLocale(e.name, strings.locale),
                            "",
                            // e.color,
                            Colors.white,
                            e.serverPath, () {
                          _mainModel.categoryData = e;
                          route("category");
                        },
                            windowWidth / 3,
                            windowWidth * 0.22,
                            direction: strings.direction),


                        Container(

                            margin: EdgeInsets.only(
                                left: 0, top: windowWidth / 5),
                            padding: EdgeInsets.only(
                                left: 20, right: 00, top: 0, bottom: 0),
                            alignment: Alignment.center,
                            child: Text(
                              //getTextByLocale(e.name, strings.locale),
                              strings.locale  == "en" ? CNameEnglish : strings.locale == "fr" ? CNameFrench : strings.locale == "ar" ? CNameArabic : "",
                              style: theme.style10W600Grey1112,)

                          /// View all
                        )

                      ],
                    ))
            ));
          }


          index++;
          if (index >= 100)
            break;
        }










        list.add( Container(
          height: windowSize * 0.7 * 0.5,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: list1,
          ),
        ),
        );

        list.add(SizedBox(height: windowSize/25,));

        list.add( Container(
          height: windowSize * 0.7 * 0.5,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: list2,
          ),
        ),
        );


        list.add(SizedBox(height: windowSize/25,));

        list.add( Container(
          height: windowSize * 0.7 * 0.5,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: list3,
          ),
        ),
        );




*/
      }





/*

      if (item == "category_details") {
        var i = 1;
        for (var item in categories) {
          var t = _horizontalCategoryDetails(item);
          if (t != null) {
            if(i==1){
              i=2;
            list.add(Container(
                child: Container(
                  color: item.color.withAlpha(20),
                  width: windowSize,
                  height: 60,
                  child: button157(
                      //getTextByLocale(item.name, strings.locale),
                      strings.get(278),
                      item.color,
                      //item.serverPath, () {},
                      "", () {},
                      windowSize,
                      60),
                )
            )

            );

            //list.add(t);
            //list.add(SizedBox(height: 10,));
          }
        }

        }

        list.add(Container(
          height: windowSize * 0.7 * 0.6,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: listProduct,
          ),
        ),
        );
        list.add(SizedBox(height: 10,));


      }

*/




      //
      // category_details
      //
  /*
      if (item == "category_details") {
        for (var item in categories) {
          var t = _horizontalCategoryDetails(item);
          if (t != null) {
            list.add(Container(
                child: Container(
                  color: item.color.withAlpha(20),
                  width: windowSize,
                  height: 60,
                  child: button157(
                      getTextByLocale(item.name, strings.locale),
                      item.color,
                      item.serverPath, () {},
                      windowSize ,
                      60),
                )
            )
            );
            list.add(t);
            list.add(SizedBox(height: 10,));
          }
        }
      }
*/
      //
      // related products
      //
      /*
      if (item == "related_products"){
        list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
          child: Row(
            children: [
              Expanded(
                  child:

                  Text(
                    "",
                    //strings.get(282), /// "Related products",
                style: theme.style13W800,)

        ),
            ],
          )));
          list.add(SizedBox(height: 20,));
          list.add(articleHorizontalBar("root", windowWidth, context, _mainModel));
        }
    */
      //
      // Top Services
      //
      /*
      if (item == "top_service") {
        if (appSettings.inMainScreenServices.isNotEmpty) {
          list.add(Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Text(strings.get(172), style: theme.style16W800,),));  /// "Top Services",
          list.add(SizedBox(height: 10,));
          _addTopServices(list);
        }
        list.add(SizedBox(height: 20,));
      }
*/
      //
      // favorites
      //
      /*
      if (item == "favorites") {
        if (userAccountData.userFavorites.isNotEmpty) {
          list.add(Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Text(strings.get(170), style: theme.style14W800,)),

                  /// "Your Favorites",
                  InkWell(
                      onTap: () {
                        route("favorite");
                      },
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            strings.get(175), style: theme.style12W600Blue,)

                        /// View all
                      ))
                ],
              )));
          list.add(SizedBox(height: 10,));
          _listFavorites(list);
          list.add(SizedBox(height: 20,));
        }
      }
      */
    }


    //list.add(SizedBox(height: 150,));
    return Container(
        child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              _waits(true);
              var ret = await _mainModel.init2(_redraw);
              if (ret != null)
                messageError(context, ret);
              _waits(false);
              ret = await loadBlog(true);
              if (ret != null)
                messageError(context, ret);
              _redraw();
            },
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: list,
            )
        ));
  }

  _listFavorites(List<Widget> list) {

    var _count = 0;
    for (var item in product) {
      if (!userAccountData.userFavorites.contains(item.id))
        continue;

      list.add(serviceItem(item, _mainModel, windowWidth));

      list.add(SizedBox(height: 10,));
      _count++;
      if (_count == 3)
        break;
    }
  }

  _addTopServices(List<Widget> list) {

    for (var item in product) {
      if (!appSettings.inMainScreenServices.contains(item.id))
        continue;

      list.add(serviceItem(item, _mainModel, windowWidth));

      // var _prov = getProviderById(item.providers[0]);
      // _prov ??= ProviderData.createEmpty();
      //
      // var _tag = UniqueKey().toString();
      // list.add(InkWell(onTap: () {
      //   _openDetails(_tag, item);
      // },
      //     child: Hero(
      //         tag: _tag,
      //         child: Container(
      //             width: windowWidth,
      //             margin: EdgeInsets.only(left: 10, right: 10),
      //             child: Stack(
      //               children: [
      //                 Card50(item: item,
      //                   locale: strings.locale,
      //                   direction: strings.direction,
      //                   category: _mainModel.categories,
      //                   providerData: _prov,
      //                 ),
      //                 if (user != null)
      //                   Container(
      //                     margin: EdgeInsets.all(6),
      //                     alignment: strings.direction == TextDirection.ltr
      //                         ? Alignment.topRight
      //                         : Alignment.topLeft,
      //                     child: IconButton(
      //                       icon: userAccountData.userFavorites.contains(item.id)
      //                           ? Icon(Icons.favorite, size: 25,)
      //                           : Icon(Icons.favorite_border, size: 25,),
      //                       color: Colors.orange,
      //                       onPressed: () {
      //                         changeFavorites(item);
      //                       },),
      //                   )
      //               ],
      //             )
      //         ))));
      list.add(SizedBox(height: 10,));
    }
  }

  _openBanner(String id, String heroId, String image) {
    for (var item in banners)
      if (item.id == id) {
        if (item.type == "provider") {
          for (var pr in providers)
            if (pr.id == item.open) {
              _mainModel.currentProvider = pr;
              route("provider");
              break;
            }
        }
        if (item.type == "category") {
          for (var cat in categories)
            if (cat.id == item.open) {
              _mainModel.categoryData = cat;
              route("category");
              break;
            }
        }
        if (item.type == "service") {
          for (var ser in product)
            if (ser.id == item.open) {
              _mainModel.currentService = ser;
              route("service");
              break;
            }
        }
      }
  }

  bool _wait = false;

  _waits(bool value) {
    _wait = value;
    _redraw();
  }

  _redraw() {
    if (mounted)
      setState(() {});
  }

  //
  // Services
  //





/*
  Widget? _horizontalCategoryDetails(CategoryData parent) {
    User? user = FirebaseAuth.instance.currentUser;
    List<Widget> list = [];
    var index = 0;
    for (var item in product) {
      if (!item.category.contains(parent.id))
        continue;
      var _tag = UniqueKey().toString();
      list.add(Hero(
          tag: _tag,
          child: Container(
              width: windowSize * 0.7,
              child: Stack(
                children: [
                  button202N(item, _mainModel,
                    windowWidth - 20, windowSize / 2, () {
                      _mainModel.currentService = item;
                      route("service");
                    },),

                  if (user != null)
                    Container(
                      margin: EdgeInsets.all(6),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: userAccountData.userFavorites.contains(item.id)
                            ? Icon(Icons.favorite, size: 25,)
                            : Icon(Icons.favorite_border, size: 25,),
                        color: Colors.orange,
                        onPressed: () {
                          changeFavorites(item);
                        },),
                    )
                ],
              ))
      ));
      index++;
      if (index >= 10)
        break;
    }
    if (list.isEmpty)
      return null;
    return Container(
      height: windowSize * 0.7 * 0.6,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

*/




  List<Widget> listProduct = [];

  Widget? _horizontalCategoryDetails(CategoryData parent) {
    User? user = FirebaseAuth.instance.currentUser;
    List<Widget> list = [];
    var index = 0;
    var i = 1;
    for (var item in product) {
      if (!item.category.contains(parent.id))
        continue;
      var _tag = UniqueKey().toString();
      list.add(Hero(
          tag: _tag,
          child: Container(
              width: windowSize * 0.7,
              child: Stack(
                children: [
                  button202N(item, _mainModel,
                    windowWidth - 20, windowSize / 2, () {
                      _mainModel.currentService = item;
                      route("service");
                    },),

                  if (user != null)
                    Container(
                      margin: EdgeInsets.all(6),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: userAccountData.userFavorites.contains(item.id)
                            ? Icon(Icons.favorite, size: 25,)
                            : Icon(Icons.favorite_border, size: 25,),
                        color: Colors.orange,
                        onPressed: () {
                          changeFavorites(item);
                        },),
                    )
                ],
              ))
      ));
      listProduct.add(Hero(
          tag: _tag,
          child: Container(
              width: windowSize * 0.7,
              child: Stack(
                children: [
                  button202N(item, _mainModel,
                    windowWidth - 20, windowSize / 2, () {
                      _mainModel.currentService = item;
                      route("service");
                    },),

                  if (user != null)
                    Container(
                      margin: EdgeInsets.all(6),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: userAccountData.userFavorites.contains(item.id)
                            ? Icon(Icons.favorite, size: 25,)
                            : Icon(Icons.favorite_border, size: 25,),
                        color: Colors.orange,
                        onPressed: () {
                          changeFavorites(item);
                        },),
                    )
                ],
              ))
      ));
      index++;
      if (index >= 10)
        break;
    }
    if (list.isEmpty)
      return null;
    return Container(
      height: windowSize * 0.7 * 0.6,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

















  _addBlog(List<Widget> list) {
    list.add(SizedBox(height: 10,));
    var _count = 0;
    for (var item in blog) {
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: button202Blog(item,
            (theme.darkMode) ? Colors.black : Colors.white,
            windowWidth, windowWidth * 0.35, () {
              _mainModel.openBlog = item;
              route("blog_details");
            }),
      )
      );
      list.add(SizedBox(height: 10,));
      _count++;
      if (_count == 3)
        break;
    }
  }

  _addProviders(List<Widget> list) {
    var _count = 0;
    for (var item in providers) {
      list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(bottom: 5, top: 5),
        child: button202m(item,
          windowWidth * 0.26, _mainModel, _redraw, () {
            _mainModel.currentProvider = item;
            route("provider");
          },)),
      );
      list.add(SizedBox(height: 1,));
      _count++;
      if (_count == 5)
        break;
    }
  }

}
