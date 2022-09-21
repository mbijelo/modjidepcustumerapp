import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/strings.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';






_Card50(
    item,
    locale,
    direction,
    category,
    providerData,
    textNodispo,
    sendDemandText,
    mainModel
    ){
  String image = "";
  String text1 = providerData.name[0].text;
  String text2= "";
  String text3= "";
  String date= ".";
  String dateCreating= "qdqsd";
  String bookingId= "";
  Widget icon = Container();
  Color bkgColor = Color(0xfff1f6fe);
  String stringBookingId= "";
  String stringTimeCreation= "";
  bool shadow = false;
  double padding = 5;
  String stringBookingAt = "";
  String bookingAt = "";
  double imageRadius = 50;
  image = providerData.logoServerPath;
  bool categoryEnable = true;

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
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 0),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [



            Container(
              height: 70,
              width: 70,
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
                      card51(item.rating.toInt(), Colors.orange, 16),
                      Text(item.rating.toStringAsFixed(1), style: aTheme.style12W600Orange, textAlign: TextAlign.center,),
                      SizedBox(width: 5,),
                      Text("(${item.countRating.toString()})", style: aTheme.style12W800, textAlign: TextAlign.center,),
                    ],),

                    SizedBox(height: 5,),



                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.orange, size: 15,),
                        SizedBox(width: 5,),
                        Expanded(child: Text(providerData.address, style: aTheme.style10W400),)
                      ],
                    ),


                    SizedBox(height: 5,),

                    if (categoryEnable)
                      Row(children: [
                        InkWell(
                            onTap: item.visible ?
                                () async {

                                  mainModel.currentService = item;
                                  mainModel.account.addAddressByCurrentPosition();

                            }
                                :
                                (){
                            }
                            ,
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: item.visible ? Colors.green : Colors.black54 ,
                                borderRadius: BorderRadius.circular(aTheme.radius),
                              ),
                              child:

                              item.visible ? Text(
                                strings.get(290),

                                style: aTheme.style12W600White,)
                              :
                              Text(
                                strings.get(289),

                                style: aTheme.style12W600White,)
                              ,
                            )
                        )
                      ],),



                  ],)),
            SizedBox(width: 10,),
          ],
        ),

      ));
}





serviceItem(ProductData item, MainModel _mainModel, double windowWidth){

  User? user = FirebaseAuth.instance.currentUser;

  var _prov = getProviderById(item.providers.isNotEmpty ? item.providers[0] : "");
  _prov ??= ProviderData.createEmpty();

  bool available = _prov.available;


  return InkWell(onTap: () {
    /*
          if (available) {
            _mainModel.currentService = item;
            route("service");
          }

     */
  },
      child: Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            children: [
              _Card50(
                  item,
                  strings.locale,
                  strings.direction,
                  categories,
                  _prov,
                  strings.get(289),
                  strings.get(290),
                  _mainModel
              ),
              if (user != null)
                Container(
                  margin: EdgeInsets.all(6),
                  alignment: strings.direction == TextDirection.ltr
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: IconButton(
                    icon: userAccountData.userFavorites.contains(item.id)
                        ? Icon(Icons.favorite, size: 25,)
                        : Icon(Icons.favorite_border, size: 25,),
                    color: Colors.orange,
                    onPressed: () {
                      changeFavorites(item);
                    },),
                ),


              Container(
                margin: strings.direction == TextDirection.ltr
                    ? EdgeInsets.only(bottom: 0, left: 0, right: 50, top: 6)
                : EdgeInsets.only(bottom: 0, left: 50, right: 50, top: 6) ,
                alignment: strings.direction == TextDirection.ltr
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined, size: 25,),
                  color: Colors.black,
                  onPressed: () {
                    /*
                        if (available) {
                          _mainModel.currentService = item;
                          route("service");
                        }
                        */
                    /*
                        if (available) {
                          _mainModel.currentService = item;
                           route("service");
                        }
                        */
                    _mainModel.currentService = item;
                    for (var item in _mainModel.currentService.providers){
                      for (var item2 in providers){
                        if (item == item2.id){
                          _mainModel.currentProvider = item2;
                          route("provider");
                        }
                      }
                    }


                  },


                ),
              ),

              if (!available)
                Positioned.fill(child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: BorderRadius.circular(aTheme.radius),
                  ),
                  child: Center(child: Text(strings.get(259),
                    style: theme.style10W800White, textAlign: TextAlign.center,)), /// Not available Now
                ))
            ],
          )
      )
  );
}


