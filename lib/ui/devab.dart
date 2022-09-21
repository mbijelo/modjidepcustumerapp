import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:provider/provider.dart';
import 'strings.dart';
import 'theme.dart';

class DevabScreen extends StatefulWidget {
  @override
  _DevabScreenState createState() => _DevabScreenState();
}

class _DevabScreenState extends State<DevabScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  String _searchText = "";
  late MainModel _mainModel;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final _controllerSearch = TextEditingController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    _loadMessages();
    _mainModel.updateNotify = _loadMessages;
    super.initState();
  }

  _loadMessages() async {
    _waits(true);
    var ret = await loadMessages();
    if (ret != null)
      messageError(context, ret);
    _waits(false);
    _mainModel.numberOfUnreadMessages = 0;
    redrawMainWindow();
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
    _mainModel.updateNotify = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
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
                       /*
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
                            )
                        )
                        */
                      ];
                    },
                    body: Stack(
                      children: [
                        Container(
                          width: windowWidth,
                          height: windowHeight,
                          child: _body(),
                        ),
                        if (_wait)
                          Center(child: Container(child: Loader7v1(color: theme.mainColor,))),
                      ],
                    )
                ),

                if (_mainModel.currentPage != "notify")
                  appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                      "", context, () {goBack();})

              ]),
        ));
  }

  _title() {
    return Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      height: windowHeight * 0.3,
      width: windowWidth/2,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              width: windowWidth*0.3,
              height: windowWidth*0.3,
              //child: Image.asset("assets/ondemands/ondemand17.png", fit: BoxFit.cover),
              child: theme.notifyLogoAsset ? Image.asset("assets/ondemands/ondemand17.png", fit: BoxFit.contain) :
              CachedNetworkImage(
                  imageUrl: theme.notifyLogo,
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
            Text(strings.get(19), // "Notifications",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(20), // "Lots of important information",
                style: theme.style10W600Grey),
          ],
        )

    );
  }


  _body(){
    List<Widget> list = [];
/*
    list.add(Edit26(
        hint: strings.get(122), /// "Search",
        color: (theme.darkMode) ? Colors.black : Colors.white,
        style: theme.style14W400,
        icon: Icons.search,
        useAlpha: false,
        decor: decor,
        controller: _controllerSearch,
        onChangeText: (String value){
          _searchText = value;
          setState(() {
          });
        }
    ));
    */

    list.add(SizedBox(height: 20,));

    //
    //
    //

      list.add(Center(child:
      Container(
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.notifyNotFoundImageAsset ? Image.asset("assets/devab.jpg", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.notifyNotFoundImage,
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
      ));
      list.add(SizedBox(height: 10,));
      list.add(Center(
        child: Text(
          //strings.get(150),
          " A propos du développeur de cette application:"
          " Jean Louis Roger BIKELE MBUEMBUE : "
              " Analyste Concepteur des Systèmes Informatiques / Consultant et Formateur"
                  " Tel1:+22242900378/26723801 whatsapp:+22242900378 ",
          style: theme.style18W800Grey,
        ),
      )); /// "Not found ...",


    list.add(SizedBox(height: 120,));

    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){return _loadMessages();},
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            children: list,
          ),
        ));
  }
}

