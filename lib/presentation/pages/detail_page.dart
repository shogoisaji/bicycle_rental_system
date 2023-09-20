import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/cart_into_card.dart';
import 'package:bicycle_rental_system/presentation/widgets/cart_period_count.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_unit_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final Bicycle bicycle;
  DetailPage({super.key, required this.bicycle});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TimeUnit timeTagState = TimeUnit.hour;
  var f = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double cardWidth = 0;
    double rate = 0;
    StateController stateController = Get.find<StateController>();

    if (mWidth > BREAKPOINT1) {
      cardWidth = mWidth / 2;
      rate = cardWidth / 700;
    } else {
      cardWidth = mWidth;
      rate = cardWidth / 700;
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Padding(
              padding: const EdgeInsets.only(left: 100),
              child: boldText('BICYCLE RENTAL', Colors.white, 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0,
          actions: [
            InkWell(
                onTap: () {
                  //
                  print('go to cart');
                },
                child: Container(
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
                            child: Text(stateController.cart.length.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500))),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 700 * rate,
                              height: 700 * rate,
                              margin: EdgeInsets.only(left: 20),
                              padding: EdgeInsets.all(20),
                              child: Image.network(
                                widget.bicycle.imageUrl,
                                fit: BoxFit.fitWidth,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      spreadRadius: 1.5,
                                      blurRadius: 4,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ]),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20, top: 10),
                              // width: 500 * rate,
                              height: 90,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                // shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.all(8),
                                    padding: EdgeInsets.all(8),
                                    width: 70,
                                    height: 70,
                                    child: Image.network(
                                      widget.bicycle.imageUrl,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.6),
                                            spreadRadius: 1.5,
                                            blurRadius: 4,
                                            offset: Offset(0,
                                                1), // changes position of shadow
                                          ),
                                        ]),
                                  );
                                },
                              ),
                            ),
                            // under card
                            Stack(
                              children: [
                                Container(
                                    constraints: BoxConstraints(
                                        minHeight: 200, maxWidth: 800),
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: MyTheme.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  boldText(
                                                      widget
                                                          .bicycle.productName,
                                                      Colors.black,
                                                      32),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 130.0),
                                                    child: regularText(
                                                        widget.bicycle
                                                            .description,
                                                        Colors.black87,
                                                        20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                            top: 0,
                                            right: 20,
                                            child: Obx(() => boldText(
                                                '￥${f.format(widget.bicycle.pricePerHour * stateController.priceRate)}/${stateController.unit}',
                                                Colors.black,
                                                32))),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                //select
                                                stateController
                                                    .addCart(widget.bicycle);
                                              },
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsets>(
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 10)),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(MyTheme.purple),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                              child: boldText(
                                                  'SELECT', Colors.white, 24)),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        )),
                  ),
                  Positioned(top: 10, right: 10, child: timeUintSelector()),
                ],
              ),
            ),
// right side cart
            mWidth > BREAKPOINT1
                ? Container(
                    constraints: BoxConstraints(maxWidth: 300, minWidth: 200),
                    width: mWidth * 0.35,
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
                                    return CartIntoCard(
                                        bicycle: stateController.cart[index]);
                                  },
                                ),
                              )),
                            ),
// right under checkout
                            Container(
                                color: MyTheme.blue,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    cartPeriodCount(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              //
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(MyTheme.orange),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              )),
                                            ),
                                            child: mWidth > 900
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 4),
                                                    child: boldText('checkout',
                                                        Colors.white, 20),
                                                  )
                                                : Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4,
                                                                horizontal: 0),
                                                        child: Text(
                                                            'check\nout',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
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
                                            padding: EdgeInsets.fromLTRB(
                                                4, 4, 10, 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                mediumText(
                                                    '￥', Colors.black, 22),
                                                mediumText(
                                                    '${f.format(stateController.totalPrice.value)}',
                                                    Colors.black,
                                                    22),
                                              ],
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
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
