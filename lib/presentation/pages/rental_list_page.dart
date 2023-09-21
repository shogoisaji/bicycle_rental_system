import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RentalListPage extends StatelessWidget {
  const RentalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    FirebaseService firebase = FirebaseService();
    MyDateFormat dateFormat = MyDateFormat();
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
//fetch bicycle data
                                return FutureBuilder(
                                    future: firebase
                                        .fetchBicycleData(
                                            rentalDataMap['bicycleID'])
                                        .timeout(Duration(seconds: 5)),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Bicycle bicycleData = snapshot.data!;
                                        return Container(
                                          height: 110,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 24),
                                          padding: EdgeInsets.all(8),
                                          constraints:
                                              BoxConstraints(maxWidth: 600),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin:
                                                    EdgeInsets.only(right: 16),
                                                padding: EdgeInsets.all(2),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    bicycleData.imageUrl,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        mediumText('Bicycle',
                                                            Colors.black, 14),
                                                        mediumText(
                                                            '・${bicycleData.productName}',
                                                            Colors.black,
                                                            16),
                                                        mediumText('User',
                                                            Colors.black, 14),
                                                        mediumText(
                                                            '・${rentalDataMap['rentalUser']}',
                                                            Colors.black,
                                                            16),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        mediumText(
                                                            dateFormat
                                                                .formatForDisplay(
                                                                    docs[index][
                                                                        'rentalStartDate']),
                                                            Colors.black,
                                                            14),
                                                        boldText('   ↓',
                                                            Colors.black, 20),
                                                        mediumText(
                                                            dateFormat
                                                                .getFormatEndDate(
                                                              DateTime.parse(docs[
                                                                      index][
                                                                  'rentalStartDate']),
                                                              docs[index][
                                                                  'rentalPeriod'],
                                                            ),
                                                            Colors.black,
                                                            14),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 80,
                                                      child: Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          height:
                                                              double.infinity,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 4,
                                                                    right: 16),
                                                            child: boldText(
                                                                'Price',
                                                                Colors.black,
                                                                24),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    });
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
