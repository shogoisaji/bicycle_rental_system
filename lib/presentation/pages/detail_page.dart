import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/cart_page.dart';
import 'package:bicycle_rental_system/presentation/pages/image_edit_page.dart';
import 'package:bicycle_rental_system/presentation/pages/list_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/cart_into_card.dart';
import 'package:bicycle_rental_system/presentation/widgets/cart_period_count.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_unit_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  final Bicycle bicycle;
  DetailPage({super.key, required this.bicycle});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  AuthController authController = Get.find();
  String selectedImageUrl = '';

  @override
  void initState() {
    selectedImageUrl = widget.bicycle.images[0]['url'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double cardWidth = 0;
    double rate = 0;
    AuthController authController = Get.find<AuthController>();
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
              padding: mWidth < BREAKPOINT1
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 60),
              child: boldText(
                  'DETAIL', Colors.white, mWidth < BREAKPOINT1 ? 28 : 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ),
                  );
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
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.all(8),
                              child: selectedImageUrl == ''
                                  ? Container()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        selectedImageUrl,
                                        fit: BoxFit.fitWidth,
                                      ),
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
                              padding: EdgeInsets.only(left: 8, top: 10),
                              // width: 500 * rate,
                              height: 90,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.bicycle.images.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedImageUrl =
                                            widget.bicycle.images[index]['url'];
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(2),
                                      width: 70,
                                      height: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          widget.bicycle.images[index]['url'],
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              spreadRadius: 1.5,
                                              blurRadius: 4,
                                              offset: Offset(0, 1),
                                            ),
                                          ]),
                                    ),
                                  );
                                },
                              ),
                            ),
// go to image edit page
                            authController.isAdmin.value
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageEditPage(
                                                      productId: widget
                                                          .bicycle.productId,
                                                    )),
                                          );
                                          // Map<String, dynamic>? imageMap =
                                          //     await FirebaseService()
                                          //         .pickImage();
                                          // if (imageMap == null) return;
                                          // bool result = await FirebaseService()
                                          //     .addImage(
                                          //         widget.bicycle.productId,
                                          //         imageMap);
                                          // if (result) {
                                          //   Get.snackbar(
                                          //     "Success",
                                          //     "Image added",
                                          //     backgroundColor: Colors.blue,
                                          //     snackPosition:
                                          //         SnackPosition.BOTTOM,
                                          //     maxWidth: 500,
                                          //   );
                                          //   Get.to(() => ListPage());
                                          // } else {
                                          //   print('error');
                                          //   Get.snackbar(
                                          //     "Error",
                                          //     "Failed to add Image",
                                          //     backgroundColor: Colors.red,
                                          //     snackPosition:
                                          //         SnackPosition.BOTTOM,
                                          //     maxWidth: 500,
                                          //   );
                                          // }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  MyTheme.orange),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        child: boldText(
                                            'edit image', Colors.white, 18)),
                                  )
                                : Container(),
// under card
                            Obx(() => Container(
                                constraints: BoxConstraints(
                                    minHeight: 200, maxWidth: 800),
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: MyTheme.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Expanded(
                                            child: boldText(
                                                widget.bicycle.productName,
                                                Colors.black,
                                                mWidth < BREAKPOINT1 ? 24 : 32),
                                          ),
                                        ),
                                        boldText(
                                            '￥${f.format(widget.bicycle.pricePerHour * stateController.priceRate)}/${stateController.unit}',
                                            Colors.black,
                                            mWidth < BREAKPOINT1 ? 24 : 32),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    regularText(widget.bicycle.description,
                                        Colors.black87, 20),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          authController.isAdmin.value
                                              ? ElevatedButton(
                                                  onPressed: () async {
                                                    //select
                                                    var result =
                                                        await FirebaseService()
                                                            .deleteData(widget
                                                                .bicycle
                                                                .productId);
                                                    if (result) {
                                                      Get.snackbar(
                                                        'Delete',
                                                        'Delete success',
                                                        backgroundColor:
                                                            Colors.blue,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        maxWidth: 500,
                                                      );
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ListPage()),
                                                      );
                                                    } else {
                                                      Get.snackbar(
                                                        'Error',
                                                        'Delete failed',
                                                        backgroundColor:
                                                            Colors.red,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        maxWidth: 500,
                                                      );
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    padding: MaterialStateProperty
                                                        .all<EdgeInsets>(
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        10)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.red),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                  child: boldText('DELETE',
                                                      Colors.white, 24))
                                              : Container(),
                                          ElevatedButton(
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
                                        ],
                                      ),
                                    )
                                  ],
                                ))),
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
