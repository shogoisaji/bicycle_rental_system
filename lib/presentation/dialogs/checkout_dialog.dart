import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutDialog extends StatelessWidget {
  const CheckoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    StateController stateController = Get.find<StateController>();

    String rentalPeriod() {
      DateTime currentDate = DateTime.now();
      if (stateController.timeUnitState == TimeUnit.month) {
        DateTime rentalPeriod = currentDate
            .add(Duration(days: stateController.rentPeriod.value * 30));
        return formatForDateTime(rentalPeriod);
      } else if (stateController.timeUnitState == TimeUnit.day) {
        DateTime rentalPeriod =
            currentDate.add(Duration(days: stateController.rentPeriod.value));
        return formatForDateTime(rentalPeriod);
      } else {
        DateTime rentalPeriod =
            currentDate.add(Duration(hours: stateController.rentPeriod.value));
        return formatForDateTime(rentalPeriod);
      }
    }

    return AlertDialog(
      title: boldText('Check Rental Info', Colors.black, 24),
      content: Container(
        height: 220,
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rental Bicycle'),
            Expanded(
              child: ListView.builder(
                itemCount: stateController.cart.length,
                itemBuilder: (context, index) {
                  return Text('・${stateController.cart[index].productName}');
                },
              ),
            ),
            Text('Rental Period'),
            Text('・${rentalPeriod()}'),
            Text(
                '・${stateController.rentPeriod.value} ${stateController.unit}'),
            SizedBox(
              height: 16,
            ),
            Text('Total Price'),
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
        TextButton(
            onPressed: () {
              // rental save firebase
            },
            child: Text('Rental')),
      ],
    );
  }
}
