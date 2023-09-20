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

    String rentEndDate() {
      DateTime rentStartDate = stateController.rentStartDate.value;
      DateTime rentEndDate;
      if (stateController.timeUnitState == TimeUnit.month) {
        rentEndDate = rentStartDate
            .add(Duration(days: stateController.rentPeriod.value * 30));
        return formatForDateTime(rentEndDate);
      } else if (stateController.timeUnitState == TimeUnit.day) {
        rentEndDate =
            rentStartDate.add(Duration(days: stateController.rentPeriod.value));
        return formatForDateTime(rentEndDate);
      } else {
        rentEndDate = rentStartDate
            .add(Duration(hours: stateController.rentPeriod.value));
        return formatForDateTime(rentEndDate);
      }
    }

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
            Text('・${formatForDateTime(stateController.rentStartDate.value)}'),
            Text('          ↓'),
            Text('　${rentEndDate()}'),
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
            onPressed: () {
              // rental save firebase
            },
            child: Text('Rental')),
      ],
    );
  }
}
