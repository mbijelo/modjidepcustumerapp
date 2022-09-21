import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/cards/card48.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

int _lastPage = 0;


class _BookingScreenState extends State<BookingScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: appSettings.statuses.length);
    if (_tabController != null)
      _tabController!.addListener(() {
        _lastPage = _tabController!.index;
        _redraw();
      });
    _tabController!.animateTo(_lastPage);
    super.initState();
  }

  _redraw(){
    if(mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    _tabController!.dispose();
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
          children: <Widget>[

            Container(
              height: windowHeight,
              width: windowWidth,
              margin: EdgeInsets.only(top: 130),
              child: TabBarView(
                controller: _tabController,
                children: _tabBody()
              ),
            ),

            ClipPath(
                clipper: ClipPathClass23(20),
                child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: windowWidth,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.get(63), // "Booking",
                      style: theme.style20W800),
                  SizedBox(height: 20,),
                  TabBar(
                    labelColor: Colors.black,
                    indicatorWeight: 4,
                    isScrollable: true,
                    indicatorColor: theme.mainColor,
                    tabs: _tabHeaders(),
                    controller: _tabController,
                  ),
                ],
              ),
            )),


          ],
        ))

    );
  }

  _tabHeaders(){
    List<Widget> list = [];
    var i = 1;
    for (var item in appSettings.statuses) {
      list.add(
          Text(
            //getTextByLocale(item.name, strings.locale),
              i == 1 ? strings.get(67) : i == 2 ? strings.get(298) : i == 3
                  ? strings.get(295)
                  : i == 4 ? strings.get(296) : strings.get(297),
              textAlign: TextAlign.center, style: theme.style12W800));
      i++;
    }
    return list;
  }












  _tabBody(){
    List<Widget> list = [];
    for (var item in appSettings.statuses)
        list.add(_tabChild(item.id, getTextByLocale(item.name, strings.locale)));
    return list;
  }

  _tabChild(String sort, String _text){
    List<Widget> list = [];

    bool _empty = true;
    for (var item in ordersDataCache){

      var provider = getProviderById(item.providerId);

      if (item.status != sort)
        continue;
      // var _date = strings.get(109); /// "Any Time",
      // if (!item.anyTime)
      //   _date = appSettings.getDateTimeString(item.selectTime);
      String categoriName = "";
      for (var service in product){
        if(service.name[0].text == item.name){
           for(var cateName in service.category){
             categoriName = cateName;
             categoriName = getCategoryNameById(categoriName);
             var index = 0;
             var i = 0;
             var CNameFrench = "";
             var CNameEnglish = "";
             var CNameArabic = "";
             while (i < categoriName.length) {
               if (categoriName[i] != "²") {
                 CNameFrench = CNameFrench + categoriName[i];
               }
               else {
                 break;
               }
               i++;
             }
             dprint("CNameFrench : " + CNameFrench);


             i++;
             CNameEnglish = "";
             while (i < categoriName.length) {
               if (categoriName[i] != '²') {
                 CNameEnglish = CNameEnglish + categoriName[i];
               }
               else {
                 break;
               }
               i++;
             }
             dprint("CNameEnglish : " + CNameEnglish);


             i++;
             CNameArabic = "";
             while (i < categoriName.length) {
               CNameArabic = CNameArabic + categoriName[i];
               i++;
             }
             dprint("CNameArabic : " + CNameArabic);

             if (strings.locale == "en") {
               categoriName = CNameEnglish;
             }
             else if (strings.locale == "fr") {
               categoriName = CNameFrench;
             }
             else if (strings.locale == "ar") {
               categoriName = CNameArabic;
             }
             else {
               categoriName = "";
             }

           }
        }
      }


      list.add(InkWell(
          onTap: () async {
            waitInMainWindow(true);
            var ret = await bookingGetItem(item);
            waitInMainWindow(false);
            if (ret != null)
              return messageError(context, ret);
            route("jobinfo");
          },
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child:  Card43( //image: item.providerImage,
                image: provider != null ? provider.logoServerPath : "",
                text1: getTextByLocale(item.providerName, strings.locale),
                text2: categoriName,
                //text2: "",
                //text3: getPriceString(item.total),
                text3: "",
                date: ".",
                // bookingAt: _date,
                dateCreating: appSettings.getDateTimeString(item.time),
                bookingId: item.id,
               // icon: Icon(Icons.payment, color: theme.mainColor, size: 15,),
                icon: Icon(Icons.payment, color: theme.mainColor, size: 0,),
                //bkgColor: (theme.darkMode) ? Colors.black : Colors.white,
                bkgColor: Color(0xfff1f6fe),
                stringBookingId: strings.get(232), /// "Booking ID",
                stringTimeCreation: strings.get(231), /// Time creation

              ))
      ));
      list.add(SizedBox(height: 30,));
      _empty = false;
    }

    if (_empty) {
      list.add(Center(child:
      Container(
        /*
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.bookingNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.bookingNotFoundImage,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            )
        ),
        // Image.network(
        //     theme.logo,
       */ //     fit: BoxFit.cover),
      ),

      //Image.asset("assets/nofound.png"))
      ));
      list.add(SizedBox(height: 10,));
    //  list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 200,));
    return ListView(
      children: list,
    );
  }

}






/*

import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/cards/card48.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

int _lastPage = 0;


class _BookingScreenState extends State<BookingScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: appSettings.statuses.length);
    if (_tabController != null)
      _tabController!.addListener(() {
        _lastPage = _tabController!.index;
        _redraw();
      });
    _tabController!.animateTo(_lastPage);
    super.initState();
  }

  _redraw(){
    if(mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    _tabController!.dispose();
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
          children: <Widget>[

            Container(
              height: windowHeight,
              width: windowWidth,
              margin: EdgeInsets.only(top: 130),
              child: TabBarView(
                controller: _tabController,
                children: _tabBody()
              ),
            ),

            ClipPath(
                clipper: ClipPathClass23(20),
                child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: windowWidth,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.get(63), // "Booking",
                      style: theme.style20W800),
                  SizedBox(height: 20,),
                  TabBar(
                    labelColor: Colors.black,
                    indicatorWeight: 4,
                    isScrollable: true,
                    indicatorColor: theme.mainColor,
                    tabs: _tabHeaders(),
                    controller: _tabController,
                  ),
                ],
              ),
            )),


          ],
        ))

    );
  }

  _tabHeaders(){
    List<Widget> list = [];
    var i = 1;
    for (var item in appSettings.statuses) {
      list.add(
          Text(
            //getTextByLocale(item.name, strings.locale),
              i == 1 ? strings.get(67) : i == 2 ? strings.get(298) : i == 3
                  ? strings.get(295)
                  : i == 4 ? strings.get(296) : strings.get(297),
              textAlign: TextAlign.center, style: theme.style12W800));
      i++;
    }
    return list;
  }




  _Card48(
   String image,
   String text1,
   String text2,
   String text3,
   String date,
   String dateCreating,
   String bookingId,
   //bool shadow,
      Widget icon,
   Color bkgColor,
  // double imageRadius,
  // double padding,
   //Widget icon,
   //String bookingAt,
      String stringBookingId,
   String stringTimeCreation,
   //String stringBookingId,
     // String stringBookingAt,
  ){
    bool shadow = false;
    double padding = 5;
    String stringBookingAt = "";
    String bookingAt = "";
    double imageRadius = 50;
    return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: bkgColor,
          borderRadius: BorderRadius.circular(aTheme.radius),
          boxShadow: (shadow) ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ] : null,
        ),
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(text1, style: aTheme.style14W800,),
                      SizedBox(height: 5,),
                      if (text2.isNotEmpty)
                        Text(text2, style: aTheme.style12W600Grey,),
                      if (text2.isNotEmpty)
                        SizedBox(height: 5,),
                      Row(children: [
                        Text(stringTimeCreation, style: aTheme.style12W800), /// Time creation
                        SizedBox(width: 10,),
                        Expanded(child: Text(dateCreating, style: aTheme.style12W400, overflow: TextOverflow.ellipsis))
                      ],),
                      SizedBox(height: 5,),
                      if (bookingAt.isNotEmpty)
                        Row(children: [
                          Text(stringBookingAt, style: aTheme.style12W800), /// Booking At
                          SizedBox(width: 10,),
                          Expanded(child: Text(bookingAt, style: aTheme.style12W400, overflow: TextOverflow.ellipsis))
                        ],),
                      if (bookingAt.isNotEmpty)
                        SizedBox(height: 5,),
                      Row(children: [
                        Text(stringBookingId, style: aTheme.style12W800), /// "Booking ID",
                        SizedBox(width: 10,),
                        Expanded(child: Text(bookingId, style: aTheme.style12W400, overflow: TextOverflow.ellipsis,)),
                      ],),
                      SizedBox(height: 15,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          icon,
                          SizedBox(width: 5,),
                          Text(text3, style: aTheme.style12W400,),
                          SizedBox(width: 5,),
                          Container(
                              height: 15,
                              alignment: Alignment.center,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              )),
                          SizedBox(width: 5,),
                          Flexible(child: FittedBox(child: Text(date, style: aTheme.style13W800Blue))),
                        ],
                      )
                    ],)),
              SizedBox(width: 20,),
              Container(
                height: 60,
                width: 60,
                //padding: EdgeInsets.only(left: 10, right: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(imageRadius),
                    child: showImage(image, fit: BoxFit.cover)
                  // image.isNotEmpty ? CachedNetworkImage(
                  //             imageUrl: image,
                  //             imageBuilder: (context, imageProvider) => Container(
                  //               width: double.maxFinite,
                  //               alignment: Alignment.bottomRight,
                  //               child: Container(
                  //                 //width: height,
                  //                 decoration: BoxDecoration(
                  //                     image: DecorationImage(
                  //                       image: imageProvider,
                  //                       fit: BoxFit.cover,
                  //                     )),
                  //               ),
                  //             )
                  //         ) : Container(),
                ),
              ),
              SizedBox(width: 10,),
            ],
          ),

        ));
  }










  _tabBody(){
    List<Widget> list = [];
    for (var item in appSettings.statuses)
        list.add(_tabChild(item.id, getTextByLocale(item.name, strings.locale)));
    return list;
  }

  _tabChild(String sort, String _text){
    List<Widget> list = [];

    bool _empty = true;
    for (var item in ordersDataCache){

      var provider = getProviderById(item.providerId);

      if (item.status != sort)
        continue;
      // var _date = strings.get(109); /// "Any Time",
      // if (!item.anyTime)
      //   _date = appSettings.getDateTimeString(item.selectTime);
      list.add(InkWell(
          onTap: () async {
            waitInMainWindow(true);
            var ret = await bookingGetItem(item);
            waitInMainWindow(false);
            if (ret != null)
              return messageError(context, ret);
            route("jobinfo");
          },
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child:  _Card48(
                provider != null ? provider.logoServerPath : "",
               getTextByLocale(item.providerName, strings.locale),
                //text2: item.name,
                 "",
                //text3: getPriceString(item.total),
                 "",
                 ".",
                // bookingAt: _date,
                appSettings.getDateTimeString(item.time),
                item.id,
               // icon: Icon(Icons.payment, color: theme.mainColor, size: 15,),
               Icon(Icons.payment, color: theme.mainColor, size: 0,),
                //bkgColor: (theme.darkMode) ? Colors.black : Colors.white,
               Color(0xfff1f6fe),
                strings.get(232), /// "Booking ID",
                strings.get(231), /// Time creation

              ))
      ));
      list.add(SizedBox(height: 30,));
      _empty = false;
    }

    if (_empty) {
      list.add(Center(child:
      Container(
        /*
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.bookingNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.bookingNotFoundImage,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            )
        ),
        // Image.network(
        //     theme.logo,
       */ //     fit: BoxFit.cover),
      ),

      //Image.asset("assets/nofound.png"))
      ));
      list.add(SizedBox(height: 10,));
    //  list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 200,));
    return ListView(
      children: list,
    );
  }

}



 */