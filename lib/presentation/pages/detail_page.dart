import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_tag_button.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  int index;
  DetailPage({super.key, required this.index});

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

    if (mWidth > BREAKPOINT1) {
      cardWidth = mWidth / 2;
      rate = cardWidth / 700;
    } else {
      cardWidth = mWidth;
      rate = cardWidth / 700;
    }

    // final index = ModalRoute.of(context)!.settings.arguments as int;
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
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_new,
                                size: 24, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          // time tag
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            width: 150,
                            decoration: BoxDecoration(
                              color: MyTheme.celeste,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  spreadRadius: 1.5,
                                  blurRadius: 4,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              timeTagState = TimeTag.month;
                                            });
                                          },
                                          child: timeTagButton(TimeTag.month,
                                              timeTagState == TimeTag.month)),
                                    ],
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          timeTagState = TimeTag.day;
                                        });
                                      },
                                      child: timeTagButton(TimeTag.day,
                                          timeTagState == TimeTag.day)),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          timeTagState = TimeTag.hour;
                                        });
                                      },
                                      child: timeTagButton(TimeTag.hour,
                                          timeTagState == TimeTag.hour)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 500 * rate,
                      height: 500 * rate,
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/sample_bicycle.png',
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
                              offset:
                                  Offset(0, 1), // changes position of shadow
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
                        itemCount: 7,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            width: 70,
                            height: 70,
                            child: Image.asset(
                              'assets/images/sample_bicycle.png',
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
                          );
                        },
                      ),
                    ),
                    Container(
                        constraints: BoxConstraints(maxWidth: 1000),
                        // width: 700,
                        padding: EdgeInsets.all(15),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: MyTheme.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  boldText('Bicycle Name', Colors.black, 32),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  regularText(
                                      'A new sports bike by Wanderbal. It achieves incredible power and agility with a lightweight carbon frame and direct drive motor. It can reach an astonishing top speed of 320km/h. It has an aggressive and sharp design',
                                      Colors.black,
                                      20),
                                ],
                              ),
                            ),
                            Container(
                              // width: 200,
                              color: Colors.red,
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  boldText('\$ 1200', Colors.black, 32),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        //
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                MyTheme.purple),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      child:
                                          boldText('SELECT', Colors.white, 24))
                                ],
                              ),
                            ),
                          ],
                        )),
                    Center(child: Text(widget.index.toString())),
                  ],
                ),
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
