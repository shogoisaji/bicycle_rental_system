import 'package:bicycle_rental_system/animations/fade_animation.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartIntoCard extends StatefulWidget {
  final Bicycle bicycle;

  CartIntoCard({
    super.key,
    required this.bicycle,
  });

  @override
  State<CartIntoCard> createState() => _CartIntoCardState();
}

class _CartIntoCardState extends State<CartIntoCard> {
  var f = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    StateController stateController = Get.find<StateController>();

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
                                  widget.bicycle.imageUrl,
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
                                Expanded(
                                  child: Container(
                                    child: mediumText(
                                        widget.bicycle.productName,
                                        Colors.black,
                                        18),
                                  ),
                                ),
                                Container(
                                  child: mediumText(
                                      '￥${f.format(widget.bicycle.pricePerHour * stateController.priceRate)}/${stateController.unit}',
                                      Colors.black,
                                      18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 7, 20, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                stateController.removeCart(widget.bicycle);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red[200],
                                size: 26,
                              ),
                            ),
                            Text(
                                '￥${f.format((stateController.rentPeriod * widget.bicycle.pricePerHour * stateController.priceRate))}',
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
