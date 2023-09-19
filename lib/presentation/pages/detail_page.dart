import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  Bicycle bicycle;
  DetailPage({super.key, required this.bicycle});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TimeTag timeTagState = TimeTag.hour;

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
        drawer: Drawer(
          backgroundColor: MyTheme.lightBlue,
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Padding(
              padding: const EdgeInsets.only(left: 100),
              child: boldText('BICYCLE RENTAL', Colors.white, 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 500 * rate,
                            height: 500 * rate,
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
                                                    widget.bicycle.productName,
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
                                                      widget
                                                          .bicycle.description,
                                                      Colors.black54,
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
                                          child: boldText(
                                              '\$ ${widget.bicycle.pricePerHour * stateController.priceRate}',
                                              Colors.black,
                                              32)),
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
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      // color: MyTheme.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new,
                          size: 24, color: Colors.black87),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            mWidth > BREAKPOINT1
                ? Container(
                    constraints: BoxConstraints(maxWidth: 350),
                    width: mWidth * 0.3,
                    color: MyTheme.lightBlue,
                    child: Column(
                      children: [Text('aaaaaaaaaaa')],
                    ),
                  )
                : Container()
          ],
        ));
  }
}
