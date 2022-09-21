import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/search.dart';
import 'package:ondemandservice/ui/service_item.dart';
import 'package:ondemandservice/widgets/buttons/button202m.dart';
import 'package:ondemandservice/widgets/horizontal_articles.dart';
import 'devab.dart';
import 'strings.dart';
import 'elements/address.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/buttons/button202nn.dart';
import 'package:provider/provider.dart';

class IndicatorScreen extends StatefulWidget {
  const IndicatorScreen({Key? key}) : super(key: key);

  @override
  _IndicatorScreenState createState() => _IndicatorScreenState();
}

class _IndicatorScreenState extends State<IndicatorScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  final _controllerSearch = TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late MainModel _mainModel;

  @override
  void initState() {
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

                if (!_mainModel.searchActivate)
                  NestedScrollView(
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
                          })),

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
  _titleSmall() {
    /*
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
            style: theme.style16W800,),

          Text(strings.get(94), // Find what you need
              style: theme.style10W600Grey111),
          SizedBox(height: 15,),
        ],
      ),


    );
*/
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

  bool _wait = true;

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
