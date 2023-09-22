import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

var f = NumberFormat("#,###");

class MyDateFormat {
  StateController stateController = Get.find();

  final now = DateTime.now();

  String getCurrentDateIso() {
    // 2023-08-20T06:00:00.000Z
    return now.toIso8601String();
  }

  DateTime getEndDateTime(
      DateTime startDate, int rentalPeriod, TimeUnit timeUnitState) {
    DateTime endDate;
    if (timeUnitState == TimeUnit.month) {
      endDate =
          startDate.add(Duration(days: stateController.rentPeriod.value * 30));
    } else if (timeUnitState == TimeUnit.day) {
      endDate = startDate.add(Duration(days: stateController.rentPeriod.value));
    } else {
      endDate =
          startDate.add(Duration(hours: stateController.rentPeriod.value));
    }
    return endDate;
  }

  String getFormatEndDate(DateTime startDate, int rentalPeriod) {
    DateTime endDate;
    if (stateController.timeUnitState == TimeUnit.month) {
      endDate =
          startDate.add(Duration(days: stateController.rentPeriod.value * 30));
    } else if (stateController.timeUnitState == TimeUnit.day) {
      endDate = startDate.add(Duration(days: stateController.rentPeriod.value));
    } else {
      endDate =
          startDate.add(Duration(hours: stateController.rentPeriod.value));
    }
    return formatForDateTime(endDate);
  }

  String formatForDisplay(String isoDateString) {
    final dateTime = DateTime.parse(isoDateString);
    final year = dateTime.year % 100;
    final month = dateTime.month;
    final day = dateTime.day;
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    return '\'$year.${month.toString().padLeft(2, '0')}.${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String formatForDateTime(DateTime dateTime) {
    final year = dateTime.year % 100;
    final month = dateTime.month;
    final day = dateTime.day;
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    return '\'$year.${month.toString().padLeft(2, '0')}.${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  DateTime parseDateTime(String dateTimeString) {
    final year = int.parse(dateTimeString.substring(1, 3));
    final month = int.parse(dateTimeString.substring(5, 7));
    final day = int.parse(dateTimeString.substring(8, 10));
    final hour = int.parse(dateTimeString.substring(11, 13));
    final minute = int.parse(dateTimeString.substring(14, 16));

    return DateTime(year + 2000, month, day, hour, minute);
  }
}
