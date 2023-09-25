import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/application/utils/rental_data_util.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/rent_data.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/account_edit_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/account_text_box.dart';
import 'package:bicycle_rental_system/presentation/widgets/rental_List_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<AccountPage> {
  String name = '';
  String postalCode = '';
  String address = '';
  String email = '';
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
                              name = snapshot.data['userName'] ?? '';
                              postalCode = snapshot.data['postalCode'] ?? '';
                              address = snapshot.data['userAddress'] ?? '';
                              email = snapshot.data['userEmail'];
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
                                      accountTextBox('Name', name),
                                      accountTextBox('Email', email),
                                      accountTextBox('Address',
                                          '〒${postalCode}\n${address}'),
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
                                    name: name,
                                    postalCode: postalCode,
                                    address: address,
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
                      constraints: BoxConstraints(maxWidth: 500, minWidth: 300),
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
                        child: FutureBuilder(
                            future: FirebaseService().fetchSortedByUser(uid),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> docs = snapshot.data!;
                                return ListView.builder(
                                    itemCount: docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot<Object?> rentalDataMap =
                                          docs[index];
                                      RentalData rentalData =
                                          RentalDataUtil.rentalDataFromMap(
                                              rentalDataMap);
//fetch bicycle data
                                      return Padding(
                                        padding: index == 0
                                            ? const EdgeInsets.only(top: 8.0)
                                            : const EdgeInsets.all(0),
                                        child: FutureBuilder(
                                            future: FirebaseService()
                                                .fetchBicycleData(
                                                    rentalData.bicycleID)
                                                .timeout(Duration(seconds: 5)),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                print(
                                                    'Error: ${snapshot.error}');
                                                return Container();
                                              } else if (snapshot.hasData) {
                                                Bicycle bicycleData =
                                                    snapshot.data!;
                                                return RentalListCard(
                                                  rentalData: rentalData,
                                                  bicycleData: bicycleData,
                                                );
                                              } else {
                                                return RentalListCard(
                                                  rentalData: rentalData,
                                                  bicycleData: null,
                                                );
                                              }
                                            }),
                                      );
                                    });
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      ),
                    ),
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
