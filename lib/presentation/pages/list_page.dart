import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/dialogs/checkout_dialog.dart';
import 'package:bicycle_rental_system/presentation/pages/account_page.dart';
import 'package:bicycle_rental_system/presentation/pages/cart_page.dart';
import 'package:bicycle_rental_system/presentation/pages/registration_page.dart';
import 'package:bicycle_rental_system/presentation/pages/rental_list_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/cart_into_card.dart';
import 'package:bicycle_rental_system/presentation/widgets/cart_period_count.dart';
import 'package:bicycle_rental_system/presentation/widgets/item_card.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_unit_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<ListPage> {
  FirebaseService firebase = FirebaseService();
  StateController stateController = Get.find();
  AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    authController.isAdmin.value =
        await firebase.getIsAdmin(authController.getUid());
  }

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###");
    MyDateFormat dateFormat = MyDateFormat();

    double mWidth = MediaQuery.of(context).size.width;
    double index1padding = 100;
    int columnCount = 1;
    if (mWidth > BREAKPOINT2) {
      columnCount = 6;
      index1padding = (mWidth - BREAKPOINT2) / 10 + 100;
    } else if (mWidth > BREAKPOINT1) {
      columnCount = 4;
      index1padding = (mWidth - BREAKPOINT1) / 8 + 70;
    } else {
      columnCount = 2;
    }

    Future<void> _selectDateTime(BuildContext context) async {
      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2033),
      );

      if (selectedDate != null) {
        final TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          DateTime selectedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute);

          stateController.rentStartDate.value = selectedDateTime;
        }
      }
    }

    return Scaffold(
        drawer: Obx(
          () => Drawer(
            backgroundColor: MyTheme.lightBlue,
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 48),
              child: Column(
                children: [
                  authController.isAdmin.value
                      ? Row(
                          children: [
                            Icon(Icons.directions_bike),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationPage()),
                                  );
                                },
                                child: Text('Registration',
                                    style: TextStyle(fontSize: 24))),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 16,
                  ),
                  authController.isAdmin.value
                      ? Row(
                          children: [
                            Icon(Icons.directions_bike),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RentalListPage()),
                                  );
                                },
                                child: Text('Rental List',
                                    style: TextStyle(fontSize: 24))),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Icon(Icons.directions_bike),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountPage()),
                            );
                          },
                          child:
                              Text('Account', style: TextStyle(fontSize: 24))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AccountPage(),
                    ),
                  );
                },
                child: Obx(() => Text(authController.loginUserName.value)),
              ),
              InkWell(
                  onTap: () {
                    //
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.grey,
                          size: 24,
                        ),
                        Obx(
                          () => Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: Text(
                                  stateController.cart.length.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  )),
            ],
            iconTheme: IconThemeData(color: Colors.white),
            title: Padding(
                padding: mWidth < BREAKPOINT1
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.only(left: 60),
                child: boldText('BICYCLE RENTAL', Colors.white,
                    mWidth < BREAKPOINT1 ? 28 : 32)),
            backgroundColor: MyTheme.blue,
            elevation: 0),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              return SingleChildScrollView(
                                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: StaggeredGrid.count(
                                    crossAxisCount: columnCount,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    children:
                                        List.generate(docs.length, (index) {
                                      Bicycle bicycle = Bicycle(
                                          productId: docs[index].id,
                                          productName: docs[index]
                                              ['productName'],
                                          description: docs[index]
                                              ['description'],
                                          pricePerHour: docs[index]
                                              ['pricePerHour'],
                                          imageUrl: docs[index]['imageUrl']);
                                      if (index == 1 && columnCount != 2) {
                                        return StaggeredGridTile.count(
                                            crossAxisCellCount: 2,
                                            mainAxisCellCount: 2.5,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: index1padding),
                                              child: ItemCard(
                                                bicycle: bicycle,
                                              ),
                                            ));
                                      }

                                      return StaggeredGridTile.count(
                                          crossAxisCellCount: 2,
                                          mainAxisCellCount: 2,
                                          child: ItemCard(
                                            bicycle: bicycle,
                                          ));
                                    })),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })),
                  // time unit
                  Positioned(
                    top: 10,
                    right: 10,
                    child: timeUintSelector(),
                  )
                ],
              ),
            ),
// right side cart
            mWidth > BREAKPOINT1
                ? Container(
                    constraints: BoxConstraints(maxWidth: 300, minWidth: 200),
                    width: mWidth * 0.35,
                    color: MyTheme.lightBlue,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // upper icons
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      Container(height: 3, color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.shopping_cart,
                                      color: Colors.white, size: 48),
                                ),
                                Expanded(
                                  child:
                                      Container(height: 3, color: Colors.white),
                                ),
                              ],
                            ),
                            Container(
                              child: Expanded(
                                  child: Obx(
                                () => ListView.builder(
                                  itemCount: stateController.cart.length,
                                  itemBuilder: (context, index) {
                                    print(stateController.cart.length);
                                    return CartIntoCard(
                                        bicycle: stateController.cart[index]);
                                  },
                                ),
                              )),
                            ),
// right under checkout
                            Container(
                                color: MyTheme.blue,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: mWidth < 800 ? 10 : 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        cartPeriodCount(),
                                        InkWell(
                                          onTap: () {
                                            _selectDateTime(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 8),
                                            child: Obx(
                                              () => mediumText(
                                                  dateFormat.formatForDateTime(
                                                      stateController
                                                          .rentStartDate.value),
                                                  Colors.black,
                                                  16),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              //
                                              if (stateController.cart.isEmpty)
                                                return;
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          CheckoutDialog());
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(MyTheme.orange),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              )),
                                            ),
                                            child: mWidth > 900
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 4),
                                                    child: boldText('checkout',
                                                        Colors.white, 20),
                                                  )
                                                : Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4,
                                                                horizontal: 0),
                                                        child: Text(
                                                            'check\nout',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ),
                                                    ],
                                                  )),
                                        (Obx(
                                          () => Container(
                                            constraints:
                                                BoxConstraints(minWidth: 70),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                4, 4, 10, 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                mediumText(
                                                    '￥', Colors.black, 22),
                                                mediumText(
                                                    '${f.format(stateController.totalPrice.value)}',
                                                    Colors.black,
                                                    22),
                                              ],
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
