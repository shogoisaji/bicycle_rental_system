import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/rent_data.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/list_page.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutDialog extends StatelessWidget {
  const CheckoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    StateController stateController = Get.find();
    AuthController authController = Get.find();
    MyDateFormat dateFormat = MyDateFormat();

    return AlertDialog(
      title: boldText('Check Rental Info', Colors.black, 24),
      content: Container(
        padding: EdgeInsets.only(left: 16),
        height: 280 + stateController.cart.length * 16,
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
              String rentalEndDate = MyDateFormat()
                  .getEndDateTime(
                      stateController.rentStartDate.value,
                      stateController.rentPeriod.value,
                      stateController.timeUnitState.value)
                  .toIso8601String();
              for (Bicycle b in stateController.cart) {
                String rentalID = await firebase.incrementRentalID();
                int rentalPrice = b.pricePerHour *
                    stateController.priceRate *
                    stateController.rentPeriod.value;
                RentalData rentData = RentalData(
                  rentalID: rentalID,
                  bicycleID: b.productId,
                  rentalUserID: authController.getUid(),
                  rentalStartDate:
                      stateController.rentStartDate.value.toIso8601String(),
                  rentalEndDate: rentalEndDate,
                  rentalPrice: rentalPrice,
                );
                uploadResult = await firebase.uploadRentalData(rentData);
              }
              if (uploadResult) {
                Get.snackbar(
                  "Success",
                  "Rental information has been registered",
                  backgroundColor: Colors.blue,
                  snackPosition: SnackPosition.BOTTOM,
                  maxWidth: 500,
                );
                Navigator.pop(context);
                Get.offAll(() => ListPage());
                stateController.clearCart();
              } else {
                print('error');
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
