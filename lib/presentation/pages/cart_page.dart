import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/presentation/dialogs/checkout_dialog.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/cart_period_count.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_unit_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    StateController stateController = Get.find<StateController>();
    double mWidth = MediaQuery.of(context).size.width;
    MyDateFormat dateFormat = MyDateFormat();

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

          // pickedで選択した日時をセット
          stateController.rentStartDate.value = selectedDateTime;
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Padding(
              padding: mWidth < BREAKPOINT1
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 60),
              child: boldText(
                  'MY CART', Colors.white, mWidth < BREAKPOINT1 ? 28 : 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: 600,
                child: Expanded(
                  child: ListView.builder(
                      itemCount: stateController.cart.length,
                      itemBuilder: (context, index) {
                        return Obx(() => Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 24),
                              padding: EdgeInsets.all(8),
                              constraints: BoxConstraints(maxWidth: 600),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 134,
                                      height: 134,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: EdgeInsets.only(right: 20),
                                      padding: EdgeInsets.all(2),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          stateController.cart[index].imageUrl,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            boldText(
                                                stateController
                                                    .cart[index].productName,
                                                Colors.black,
                                                32),
                                            mediumText(
                                                '￥${f.format(stateController.cart[index].pricePerHour * stateController.priceRate)}/${stateController.unit}',
                                                Colors.black,
                                                24)
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
                                              '￥${f.format((stateController.rentPeriod * stateController.cart[index].pricePerHour * stateController.priceRate))}',
                                              Colors.black,
                                              32),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ));
                      }),
                ),
              ),
            ),
// footer
            Container(
                width: double.infinity,
                // height: 100,
                color: MyTheme.lightBlue,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _selectDateTime(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        child: Obx(
                          () => mediumText(
                              dateFormat.formatForDateTime(
                                  stateController.rentStartDate.value),
                              Colors.black,
                              16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 330,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          timeUintSelector(),
                          SizedBox(
                            width: 16,
                          ),
                          cartPeriodCount(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 330,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CheckoutDialog());
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        MyTheme.orange),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                child: Text('checkout',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              )),
                          SizedBox(
                            width: 16,
                          ),
                          (Obx(
                            () => Container(
                              constraints: BoxConstraints(minWidth: 70),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.fromLTRB(4, 4, 10, 4),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  mediumText('Total ',
                                      Colors.black.withOpacity(0.7), 20),
                                  mediumText('￥', Colors.black, 22),
                                  mediumText(
                                      '${f.format(stateController.totalPrice.value)}',
                                      Colors.black,
                                      28),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
