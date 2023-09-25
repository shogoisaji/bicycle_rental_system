import 'dart:convert';

import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/list_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageEditPage extends StatefulWidget {
  final String productId;
  ImageEditPage({required this.productId});

  @override
  _ImageEditPageState createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    FirebaseService firebase = FirebaseService();

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListPage(),
                ),
              );
            },
          ),
          title: Padding(
              padding: mWidth < BREAKPOINT1
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 60),
              child: boldText(
                  'IMAGE EDIT', Colors.white, mWidth < BREAKPOINT1 ? 28 : 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
                margin: EdgeInsets.only(top: 30),
                constraints: BoxConstraints(maxWidth: 400),
                child: FutureBuilder(
                    future: firebase.fetchDocumentData(widget.productId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> bicycleMap = snapshot.data!;
                        List<dynamic>? imageList =
                            jsonDecode(bicycleMap['images']);
                        return Column(
                          children: [
                            Container(
                              width: mWidth - 50,
                              height: mWidth - 50,
                              padding: EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageList![selectedIndex]['url'],
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
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
                            SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.only(left: 8, top: 10),
                              height: 150,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(8),
                                          padding: EdgeInsets.all(2),
                                          width: 70,
                                          height: 70,
                                          child: index < imageList!.length
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: imageList[index] != ''
                                                      ? Image.network(
                                                          imageList[index]
                                                              ['url'],
                                                          fit: BoxFit.fitWidth,
                                                        )
                                                      : Container(),
                                                )
                                              : Container(),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  spreadRadius: 1.5,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 1),
                                                ),
                                              ]),
                                        ),
                                      ),
// button add or delete
                                      index < imageList.length
                                          ? ElevatedButton(
                                              onPressed: () async {
                                                await firebase.deleteOneImage(
                                                    widget.productId, index);
                                                setState(() {});
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.red),
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
                                                  'delete', Colors.white, 18))
                                          : ElevatedButton(
                                              onPressed: () async {
                                                Map<String, dynamic> imageMap =
                                                    await firebase.pickImage()
                                                        as Map<String, dynamic>;
                                                bool result =
                                                    await firebase.addImage(
                                                        widget.productId,
                                                        imageMap);
                                                if (result) {
                                                  setState(() {});
                                                } else {
                                                  Get.snackbar(
                                                    'Error',
                                                    'Image add failed',
                                                    backgroundColor: Colors.red,
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    maxWidth: 500,
                                                  );
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.blue),
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
                                                  'add', Colors.white, 18)),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
          ),
        ));
  }
}
