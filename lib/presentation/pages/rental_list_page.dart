import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/utils/rental_data_util.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/rent_data.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/rental_List_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RentalListPage extends StatelessWidget {
  const RentalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    FirebaseService firebase = FirebaseService();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Padding(
              padding: mWidth < BREAKPOINT1
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 60),
              child: boldText(
                  'RENTAL LIST', Colors.white, mWidth < BREAKPOINT1 ? 28 : 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0,
        ),
        body: Center(
          child: Container(
            width: 600,
            child: Expanded(
              child: Container(
// fetch rental data
                  child: FutureBuilder(
                      future: firebase
                          .fetchAllRentData()
                          .timeout(Duration(seconds: 5)),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                                      future: firebase
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
                                          print('Error: ${snapshot.error}');
                                          return Container();
                                        } else if (snapshot.hasData) {
                                          Bicycle bicycleData = snapshot.data!;
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
                          return Center(child: CircularProgressIndicator());
                        }
                      })),
            ),
          ),
        ));
  }
}
