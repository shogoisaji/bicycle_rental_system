import 'package:bicycle_rental_system/animations/fade_animation.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/cart_item.dart';
import 'package:bicycle_rental_system/presentation/pages/detail_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartCard extends StatefulWidget {
  // CartItem cartItem;
  int cartIndex;

  CartCard({
    super.key,
    required this.cartIndex,
  });

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  var f = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    StateController stateController = Get.find<StateController>();
    String unit = stateController.unit;

    return FadeAnimation(
        delay: 0.5,
        child: Obx(
          () => Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: MyTheme.grey,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  stateController
                                      .cart[widget.cartIndex].bicycle.imageUrl,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                mediumText(
                                    stateController.cart[widget.cartIndex]
                                        .bicycle.productName,
                                    Colors.black,
                                    18),
                                mediumText(
                                    '￥${f.format(stateController.cart[widget.cartIndex].bicycle.pricePerHour * stateController.priceRate)}/${unit}',
                                    Colors.black,
                                    18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 13, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              height: 30,
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            stateController.removeRentPeriod(
                                                stateController
                                                    .cart[widget.cartIndex]);
                                            setState(() {});
                                          },
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 3),
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.red[300],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: stateController
                                                          .cart[
                                                              widget.cartIndex]
                                                          .rentPeriod ==
                                                      1
                                                  ? Icon(Icons.delete,
                                                      color: Colors.white,
                                                      size: 20)
                                                  : Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    )),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            stateController.addRentPeriod(
                                                stateController
                                                    .cart[widget.cartIndex]);
                                            setState(() {});
                                          },
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  EdgeInsets.only(right: 3),
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[300],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 20)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            spreadRadius: 0.5,
                                            blurRadius: 3,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              stateController
                                                  .cart[widget.cartIndex]
                                                  .rentPeriod
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                          Text(unit,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(
                                '￥${f.format((stateController.cart[widget.cartIndex].rentPeriod * stateController.cart[widget.cartIndex].bicycle.pricePerHour * stateController.priceRate))}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400)),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
