import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/account_edit_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/account_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    String uid = authController.getUid();
    double mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Padding(
              padding: mWidth < BREAKPOINT1
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 60),
              child: boldText(
                  'ACCOUNT', Colors.white, mWidth < BREAKPOINT1 ? 28 : 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
// Account Data
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8.0),
                      child: boldText('Account Data', Colors.grey, 24),
                    ),
                    Stack(
                      children: [
                        FutureBuilder(
                          future: FirebaseService().fetchUserData(uid),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 500, minWidth: 300),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: MyTheme.lightBlue,
                                  ),
                                  // height: 500,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      accountTextBox('Name',
                                          snapshot.data['userName'] ?? ''),
                                      accountTextBox('Email',
                                          snapshot.data['userEmail'] ?? ''),
                                      accountTextBox('Address',
                                          '〒${snapshot.data['postalCode'] ?? ''} ${snapshot.data['userAddress'] ?? ''}'),
                                    ],
                                  ));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                        Positioned(
                          top: 2,
                          right: 4,
                          child: IconButton(
                            icon:
                                Icon(Icons.edit, color: Colors.grey, size: 24),
                            onPressed: () {
                              print('go to edit page');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AccountEditPage(
                                    name: 'name',
                                    postalCode: 'postalCode',
                                    address: 'address',
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
// History
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: boldText('Rental History', Colors.grey, 24),
                    ),
                    Container(
                        constraints:
                            BoxConstraints(maxWidth: 500, minWidth: 300),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: MyTheme.lightBlue,
                        ),
                        margin: EdgeInsets.only(bottom: 16),
                        height: 400,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 80,
                                margin: EdgeInsets.fromLTRB(
                                    8, index == 0 ? 8 : 0, 8, 8),
                                padding: EdgeInsets.all(8),
                                // constraints: BoxConstraints(maxWidth: 600),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(2),
                                        // child: ClipRRect(
                                        //   borderRadius: BorderRadius.circular(15),
                                        //   child: Image.network(
                                        //     stateController.cart[index].imageUrl,
                                        //     fit: BoxFit.fitWidth,
                                        //   ),
                                        // ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              mediumText(
                                                  '111111111', Colors.black, 24)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            boldText(
                                                '121212', Colors.black, 32),
                                          ],
                                        ),
                                      ),
                                    ]),
                              );
                            },
                          ),
                        )),
                  ],
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 6)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(MyTheme.purple),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )),
                    onPressed: () {
                      authController.logout();
                    },
                    child: boldText('Log out', Colors.white, 24)),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          )),
        ));
  }
}
