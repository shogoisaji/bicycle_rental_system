import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:bicycle_rental_system/presentation/pages/detail_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatefulWidget {
  // String bicycleName;
  // int price;
  int index;
  TimeTag timeTagState;
  ItemCard(
      {super.key,
      // required this.bicycleName,
      // required this.price,
      required this.index,
      required this.timeTagState});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  var f = NumberFormat("#,###");

  Bicycle getBicycle() {
    return Bicycle(
      id: 'id',
      name: 'name',
      description: 'description',
      image: 'image',
      price: 1500,
    );
  }

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double cardWidth = 0;
    int showPrice = 0;
    String unit = '';
    double rate = 0;

    if (mWidth > BREAKPOINT2) {
      cardWidth = mWidth / 3;
      rate = cardWidth / 700;
    } else if (mWidth > BREAKPOINT1) {
      cardWidth = mWidth / 2;
      rate = cardWidth / 700;
    } else {
      cardWidth = mWidth;
      rate = cardWidth / 700;
    }

// set showPrice and unit
    switch (widget.timeTagState) {
      case TimeTag.month:
        unit = TimeTag.month.unit;
        showPrice = getBicycle().price * 28 * 24;
        break;
      case TimeTag.day:
        unit = TimeTag.day.unit;
        showPrice = getBicycle().price * 23;
        break;
      case TimeTag.hour:
        unit = TimeTag.hour.unit;
        showPrice = getBicycle().price;
        break;
    }

    return Container(
        decoration: BoxDecoration(
          color: MyTheme.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(15 * rate),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, '/detail');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailPage(index: widget.index),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/sample_bicycle.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mediumText(getBicycle().name, Colors.black, 24 * rate),
                    boldText('\$ ${f.format(showPrice)}/${unit}', Colors.black,
                        24 * rate),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      //
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 20 * rate, vertical: 15 * rate)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MyTheme.purple),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: boldText('SELECT', Colors.white, 24 * rate))
              ],
            )
          ]),
        ));
  }
}
