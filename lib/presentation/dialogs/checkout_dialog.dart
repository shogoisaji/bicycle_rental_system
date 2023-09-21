import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/rent_data.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/list_page.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutDialog extends StatelessWidget {
  const CheckoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    StateController stateController = Get.find<StateController>();
    MyDateFormat dateFormat = MyDateFormat();

    // String rentEndDate() {
    //   DateTime rentStartDate = stateController.rentStartDate.value;
    //   DateTime rentEndDate;
    //   if (stateController.timeUnitState == TimeUnit.month) {
    //     rentEndDate = rentStartDate
    //         .add(Duration(days: stateController.rentPeriod.value * 30));
    //     return dateFormat.formatForDateTime(rentEndDate);
    //   } else if (stateController.timeUnitState == TimeUnit.day) {
    //     rentEndDate =
    //         rentStartDate.add(Duration(days: stateController.rentPeriod.value));
    //     return dateFormat.formatForDateTime(rentEndDate);
    //   } else {
    //     rentEndDate = rentStartDate
    //         .add(Duration(hours: stateController.rentPeriod.value));
    //     return dateFormat.formatForDateTime(rentEndDate);
    //   }
    // }

    return AlertDialog(
      title: boldText('Check Rental Info', Colors.black, 24),
      content: Container(
        padding: EdgeInsets.only(left: 16),
        height: 300,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boldText('Rental Bicycle', Colors.black, 16),
            Expanded(
              child: ListView.builder(
                itemCount: stateController.cart.length,
                itemBuilder: (context, index) {
                  return Text('・${stateController.cart[index].productName}');
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            boldText('Rental Period', Colors.black, 16),
            Text(
                '・${dateFormat.formatForDateTime(stateController.rentStartDate.value)}'),
            Text('          ↓'),
            Text(
                '　${dateFormat.getFormatEndDate(stateController.rentStartDate.value, stateController.rentPeriod.value)}'),
            Text(
                '・${stateController.rentPeriod.value} ${stateController.unitString}'),
            SizedBox(
              height: 16,
            ),
            boldText('Total Price', Colors.black, 16),
            Text('・￥${f.format(stateController.totalPrice.value)}'),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        ElevatedButton(
            onPressed: () async {
              // rental save firebase
              if (stateController.cart.isEmpty) return;
              FirebaseService firebase = FirebaseService();
              bool uploadResult = false;
              for (Bicycle b in stateController.cart) {
                int rentID = await firebase.incrementRentId();
                RentalData rentData = RentalData(
                  rentID: rentID,
                  bicycle: b,
                  timeUnit: stateController.timeUnitState.value,
                  rentUser: stateController.userName.value,
                  rentStartDate:
                      stateController.rentStartDate.value.toIso8601String(),
                  rentPeriod: stateController.rentPeriod.value,
                );
                uploadResult = await firebase.uploadRentalData(rentData);
              }
              if (uploadResult) {
                stateController.clearCart();
                Get.snackbar(
                  "Success",
                  "Rental information has been registered",
                  backgroundColor: Colors.blue,
                  snackPosition: SnackPosition.BOTTOM,
                  maxWidth: 500,
                );
                Navigator.pop(context);
                Get.to(() => ListPage());
              } else {
                print('errro');
                Get.snackbar(
                  "Error",
                  "Failed to upload data",
                  backgroundColor: Colors.red,
                  snackPosition: SnackPosition.BOTTOM,
                  maxWidth: 500,
                );
              }
            },
            child: Text('Rental')),
      ],
    );
  }
}
