import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/registration_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/item_card.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_tag_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    firebase.fetchAllData();
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
            padding: const EdgeInsets.all(16.0),
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
                        child: Text('Registration')),
                  ],
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Padding(
                padding: const EdgeInsets.only(left: 100),
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
                                  return Padding(
                                    padding: index % columnCount == 1
                                        ? const EdgeInsets.only(top: 72.0)
                                        : const EdgeInsets.only(bottom: 72.0),
                                    child: ItemCard(
                                      productId: docs[index]['productId'],
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
            Container(
              constraints: BoxConstraints(maxWidth: 350),
              width: mWidth * 0.3,
              color: MyTheme.lightBlue,
              child: Column(
                children: [
                  // SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 3, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.shopping_cart,
                            color: Colors.white, size: 32),
                      ),
                      Expanded(
                        child: Container(height: 3, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
