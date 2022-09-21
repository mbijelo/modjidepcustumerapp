import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/service_item.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class CategoryScreen extends StatefulWidget {

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  String _searchText = "";
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _scrollController.addListener(_scrollListener);
    goDirectlyToServive();
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
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      //backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,

      body: Directionality(
      textDirection: strings.direction,
    child: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                      expandedHeight: windowHeight*0.15,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: ClipPath(
                        clipper: ClipPathClass23((_scroller < 5) ? 5 : _scroller),
                        child: Container(
                           // color: _mainModel.categoryData.color,
                          color:Colors.black54,
                            child: Stack(
                              children: [
                                FlexibleSpaceBar(
                                    collapseMode: CollapseMode.pin,
                                    background: _title(),
                                    titlePadding: EdgeInsets.only(bottom: 0, left: 20, right: 20),
                                    title: _titleSmall()
                                )
                              ],
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

            /*
            appbar1(Colors.transparent, Colors.white,
                "", context, () {goBack();})
                */
            appbar1(Colors.transparent, Colors.white,
                "", context, () {route("home");})

          ]),
      ));
  }

  _title() {
    return Container(
      //color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Stack(
        children: [
          Container(
                //color: _mainModel.categoryData.color,
                color: Colors.black54,
                alignment: strings.direction == TextDirection.ltr
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
                child: Container(
                  width: windowWidth*0.2,
                  margin: EdgeInsets.only(bottom: 0),
                  child: _mainModel.categoryData.serverPath.isNotEmpty ? CachedNetworkImage(
                      imageUrl: _mainModel.categoryData.serverPath,
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.maxFinite,
                        alignment: Alignment.bottomRight,
                        child: Container(
                          //width: height,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              )),
                        ),
                      )
                  ) : Container(),

                  //Image.asset(widget.data.image, fit: BoxFit.cover),
                )),
        ],
      ),
    );
  }

  _titleSmall(){




    var i = 0;
    var CNameFrench = "";
    var CNameEnglish = "";
    var CNameArabic = "";
    i = 0;
    CNameFrench = "";
    while(i < _mainModel.categoryData.name[0].text.length){
      if(_mainModel.categoryData.name[0].text[i] != "²") {
        CNameFrench = CNameFrench+_mainModel.categoryData.name[0].text[i];
      }
      else{
        break;
      }
      i++;
    }
    dprint("CNameFrench : " + CNameFrench);


    i++;
    CNameEnglish = "";
    while(i < _mainModel.categoryData.name[0].text.length){
      if(_mainModel.categoryData.name[0].text[i] != '²') {
        CNameEnglish = CNameEnglish+_mainModel.categoryData.name[0].text[i];
      }
      else{
        break;
      }
      i++;
    }
    dprint("CNameEnglish : " + CNameEnglish);


    i++;
    CNameArabic = "";
    while(i < _mainModel.categoryData.name[0].text.length){
      CNameArabic = CNameArabic+_mainModel.categoryData.name[0].text[i];
      i++;
    }
    dprint("CNameArabic : " + CNameArabic);






    return Container(
        alignment: strings.direction == TextDirection.ltr
            ? Alignment.bottomLeft
            : Alignment.bottomRight,

        padding: EdgeInsets.only(bottom: _scroller, left: 20, right: 20, top: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              //getTextByLocale(_mainModel.categoryData.name, strings.locale),
              strings.locale  == "en" ? CNameEnglish : strings.locale == "fr" ? CNameFrench : strings.locale == "ar" ? CNameArabic : "",
              style: TextStyle( letterSpacing: 0,
                  fontSize: 12,  fontWeight: FontWeight.w500, color: Colors.white),),
              SizedBox(height: 10,),
          ],
        )
    );
  }








goDirectlyToServive(){
  if (ifCategoryHaveSubcategories(_mainModel.categoryData.id)){
    for (var item in categories) {
      if (item.parent != _mainModel.categoryData.id)
        continue;
      var _tag = UniqueKey().toString();

      _mainModel.categoryData = item;


    }

  }

}


















  _body(){
    List<Widget> list = [];



    if (!ifCategoryHaveSubcategories(_mainModel.categoryData.id)) {
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Edit26(
          hint: strings.get(95),

          /// "Search service",
          color: (theme.darkMode) ? Colors.black : Colors.white,
          style: theme.style14W400,
          decor: decor,
          useAlpha: false,
          icon: Icons.search,
          controller: _controllerSearch,
          onChangeText: (String val) {
            _scrollController.jumpTo(96);
            _searchText = val;
          },
          onTap: () {
            Future.delayed(const Duration(milliseconds: 500), () {
              _scrollController.jumpTo(96);
            });
          },
        ),),
      );
      list.add(Container(
        //color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        color: Color(0xfff1f6fe),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Text( _mainModel.categoryData.desc.isEmpty ? "" : _mainModel.categoryData.desc[0].text, /// "price",
          style: theme.style14W400,),
      ));
    }

    list.add(SizedBox(height: 20,));

    //
    // subcategory
    //
    if (ifCategoryHaveSubcategories(_mainModel.categoryData.id)){

      list.add(Container(
          padding: EdgeInsets.all(10),
          child: Text(strings.get(237), style: theme.style14W800) /// "Subcategory",
      ));
      List<Widget> list2 = [];

      var i = 0;
      var CNameFrench = "";
      var CNameEnglish = "";
      var CNameArabic = "";



      for (var item in categories) {
        if (item.parent != _mainModel.categoryData.id)
          continue;
          var _tag = UniqueKey().toString();


        windowWidth = MediaQuery.of(context).size.width;
        windowHeight = MediaQuery.of(context).size.height;
        windowSize = min(windowWidth, windowHeight);



        i = 0;
        CNameFrench = "";
        while(i < item.name[0].text.length){
          if(item.name[0].text[i] != "²") {
            CNameFrench = CNameFrench+item.name[0].text[i];
          }
          else{
            break;
          }
          i++;
        }
        dprint("CNameFrench : " + CNameFrench);


        i++;
        CNameEnglish = "";
        while(i < item.name[0].text.length){
          if(item.name[0].text[i] != '²') {
            CNameEnglish = CNameEnglish+item.name[0].text[i];
          }
          else{
            break;
          }
          i++;
        }
        dprint("CNameEnglish : " + CNameEnglish);


        i++;
        CNameArabic = "";
        while(i < item.name[0].text.length){
          CNameArabic = CNameArabic+item.name[0].text[i];
          i++;
        }
        dprint("CNameArabic : " + CNameArabic);




        /*

        list2.add(button157(
            getTextByLocale(item.name, strings.locale),
            item.color,
            item.serverPath, () {
              _mainModel.categoryData = item;
              route("category");
            },
            windowWidth / 2 - 20,
            windowWidth * 0.25, direction: strings.direction),
        );


         */



        list2.add(Hero(
            tag: _tag,
            child: Container(

                width: windowSize / 3,
                margin: EdgeInsets.only(right: windowWidth/10),
                //height: windowHeight*100,
                child: Stack(
                  children: [
                    button157(
                      // getTextByLocale(e.name, strings.locale),
                        "",
                        // e.color,
                        Colors.white,
                        item.serverPath,
                            () {
                          _mainModel.categoryData = item;
                          route("category");
                        },
                        windowWidth / 3,
                        windowWidth * 0.22,
                        direction: strings.direction),


                    Container(

                        margin: EdgeInsets.only(
                            left: 0, top: windowWidth / 4),
                        padding: EdgeInsets.only(
                            left: 20, right: 00, top: 0, bottom: 0),
                        alignment: Alignment.center,
                        child: Text(
                          //getTextByLocale(item.name, strings.locale),
                          strings.locale  == "en" ? CNameEnglish : strings.locale == "fr" ? CNameFrench : strings.locale == "ar" ? CNameArabic : "",
                          style: theme.style10W600Grey1112,)

                      /// View all
                    )

                  ],
                ))
        ));





      }
      list.add(Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: list2)
      ));


      list.add(SizedBox(height: 30,));
    }

    //
    var count = 0;
    for (var item in product) {
      if (!item.category.contains(_mainModel.categoryData.id))
        continue;
      if (_searchText.isNotEmpty)
        if (!getTextByLocale(item.name, strings.locale).toUpperCase().contains(_searchText.toUpperCase()))
          continue;

      list.add(serviceItem(item, _mainModel, windowWidth));

      // var _prov = getProviderById(item.providers[0]);
      // _prov ??= ProviderData.createEmpty();
      //
      // var _tag = UniqueKey().toString();
      // list.add(InkWell(onTap: (){_openDetails(_tag, item);},
      //     child: Hero(
      //         tag: _tag,
      //         child: Container(
      //             width: windowWidth,
      //             margin: EdgeInsets.only(left: 10, right: 10),
      //             child: Stack(
      //               children: [
      //                 Card50(item: item,
      //                   locale: strings.locale,
      //                   category: _mainModel.categories,
      //                   direction: strings.direction,
      //                   providerData: _prov,
      //                 ),
      //                 if (user != null)
      //                   Container(
      //                     margin: EdgeInsets.all(6),
      //                     alignment: strings.direction == TextDirection.ltr ? Alignment.topRight : Alignment.topLeft,
      //                     child: IconButton(icon: userAccountData.userFavorites.contains(item.id)
      //                         ? Icon(Icons.favorite, size: 25,)
      //                         : Icon(Icons.favorite_border, size: 25,), color: Colors.orange,
      //                       onPressed: (){changeFavorites(item);}, ),
      //                   )
      //           ],
      //       )
      // ))));

      list.add(SizedBox(height: 20,));
      count++;
    }



    if(count == 0){
      list.add( Container(

          margin: EdgeInsets.only(
              left: 0, top: windowWidth / 4),
          padding: EdgeInsets.only(
              left: 20, right: 00, top: 0, bottom: 0),
          alignment: Alignment.center,
          child: Text(
            strings.get(303),
            style: theme.style10W600Grey1112,)

        /// View all
      )
      );
    }


    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  // _openDetails(String _tag, ProductData item){
  //   _mainModel.currentService = item;
  //   route("service");
  // }
}
