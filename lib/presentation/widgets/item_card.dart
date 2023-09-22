import 'package:bicycle_rental_system/animations/fade_animation.dart';
import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/detail_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatefulWidget {
  final Bicycle bicycle;

  ItemCard({
    super.key,
    required this.bicycle,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  var f = NumberFormat("#,###");
  FirebaseService firebase = FirebaseService();

  @override
  Widget build(BuildContext context) {
    StateController stateController = Get.find<StateController>();
    double mWidth = MediaQuery.of(context).size.width;
    double cardWidth = 0;
    double rate = 0;

    if (mWidth > BREAKPOINT2) {
      cardWidth = mWidth / 3;
      rate = cardWidth / BREAKPOINT1;
    } else if (mWidth > BREAKPOINT1) {
      cardWidth = mWidth / 2;
      rate = cardWidth / BREAKPOINT1;
    } else {
      cardWidth = mWidth;
      rate = cardWidth / BREAKPOINT1 * 1.5;
    }

    return FadeAnimation(
        delay: 0.7,
        child: Container(
            decoration: BoxDecoration(
              color: MyTheme.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(15 * rate),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(bicycle: widget.bicycle),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.bicycle.imageUrl,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mediumText(widget.bicycle.productName, Colors.black,
                              24 * rate),
                          Obx(() => boldText(
                              '￥${f.format(widget.bicycle.pricePerHour * stateController.priceRate)}/${stateController.unit}',
                              Colors.black,
                              24 * rate)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          //
                          stateController.addCart(widget.bicycle);
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: 20 * rate, vertical: 15 * rate)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(MyTheme.purple),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: boldText('SELECT', Colors.white, 24 * rate))
                  ],
                )
              ]),
            )));
  }
}
