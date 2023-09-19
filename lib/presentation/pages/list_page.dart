import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/cart_item.dart';
import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/registration_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/cart_card.dart';
import 'package:bicycle_rental_system/presentation/widgets/item_card.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_tag_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<ListPage> {
  TimeTag timeTagState = TimeTag.hour;
  FirebaseService firebase = FirebaseService();

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###");
    StateController stateController = Get.find();

    double mWidth = MediaQuery.of(context).size.width;
    int columnCount = 1;
    if (mWidth > BREAKPOINT2) {
      columnCount = 3;
    } else if (mWidth > BREAKPOINT1) {
      columnCount = 2;
    } else {
      columnCount = 1;
    }

    return Scaffold(
        drawer: Drawer(
          backgroundColor: MyTheme.lightBlue,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 48),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_bike),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()),
                          );
                        },
                        child: Text('Registration',
                            style: TextStyle(fontSize: 24))),
                  ],
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
            actions: [
              InkWell(
                  onTap: () {
                    //
                    print('go to cart');
                  },
                  child: Container(
                    // width: 70,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.grey,
                          size: 24,
                        ),
                        Obx(
                          () => Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: Text(
                                  stateController.cart.length.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  )),
            ],
            iconTheme: IconThemeData(color: Colors.white),
            title: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: boldText('BICYCLE RENTAL', Colors.white, 32)),
            backgroundColor: MyTheme.blue,
            elevation: 0),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                      child: FutureBuilder(
                          future: firebase.fetchAllData(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List<DocumentSnapshot> docs = snapshot.data!;
                              return GridView.builder(
                                itemCount: docs.length,
                                padding: EdgeInsets.all(20 * (mWidth / 600)),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing:
                                            20 * (mWidth / 800), //ボックス左右間のスペース
                                        mainAxisSpacing:
                                            0 * (mWidth / 800), //ボックス上下間のスペース
                                        crossAxisCount: columnCount //横に並べるボックス数
                                        ),
                                itemBuilder: (context, index) {
                                  Bicycle bicycle = Bicycle(
                                      productId: docs[index]['productId'],
                                      productName: docs[index]['productName'],
                                      description: docs[index]['description'],
                                      pricePerHour: docs[index]['pricePerHour'],
                                      imageUrl: docs[index]['imageUrl']);
                                  return Padding(
                                    padding: index % columnCount == 1
                                        ? const EdgeInsets.only(top: 72.0)
                                        : const EdgeInsets.only(bottom: 72.0),
                                    child: ItemCard(
                                      bicycle: bicycle,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })),
// time tag
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: 150,
                      decoration: BoxDecoration(
                        color: MyTheme.celeste,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 1.5,
                            blurRadius: 4,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      stateController
                                          .changeTimeTagState(TimeTag.month);
                                      setState(() {});
                                    },
                                    child: timeTagButton(TimeTag.month)),
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  stateController
                                      .changeTimeTagState(TimeTag.day);
                                  print(stateController.timeTagState);
                                  setState(() {});
                                },
                                child: timeTagButton(TimeTag.day)),
                            InkWell(
                                onTap: () {
                                  stateController
                                      .changeTimeTagState(TimeTag.hour);
                                  setState(() {});
                                },
                                child: timeTagButton(TimeTag.hour)),
                          ]),
                    ),
                  )
                ],
              ),
            ),
            mWidth > BREAKPOINT1
                ? Container(
                    constraints: BoxConstraints(maxWidth: 300, minWidth: 200),
                    width: mWidth * 0.3,
                    color: MyTheme.lightBlue,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // upper icons
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      Container(height: 3, color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.shopping_cart,
                                      color: Colors.white, size: 48),
                                ),
                                Expanded(
                                  child:
                                      Container(height: 3, color: Colors.white),
                                ),
                              ],
                            ),
                            Container(
                              child: Expanded(
                                  child: Obx(
                                () => ListView.builder(
                                  itemCount: stateController.cart.length,
                                  itemBuilder: (context, index) {
                                    print(stateController.cart.length);
                                    return CartCard(cartIndex: index);
                                  },
                                ),
                              )),
                            ),
                            Container(
                                color: MyTheme.blue,
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          //
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  MyTheme.orange),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          )),
                                        ),
                                        child: mWidth > 800
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 4),
                                                child: boldText('checkout',
                                                    Colors.white, 20),
                                              )
                                            : Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 0),
                                                    child: Text('check\nout',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                ],
                                              )),
                                    (Obx(
                                      () => Container(
                                        constraints:
                                            BoxConstraints(minWidth: 70),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(4, 4, 10, 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            mediumText('￥', Colors.black, 22),
                                            mediumText(
                                                ' ${f.format(stateController.totalPrice.value * stateController.priceRate)}',
                                                Colors.black,
                                                22),
                                          ],
                                        ),
                                      ),
                                    ))
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
