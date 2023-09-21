import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';

class RentalData {
  final int rentID;
  final Bicycle bicycle;
  final String rentStartDate;
  final int rentPeriod;
  final TimeUnit timeUnit;
  final String rentUser;

  RentalData({
    required this.rentID,
    required this.bicycle,
    required this.rentStartDate,
    required this.rentPeriod,
    required this.timeUnit,
    required this.rentUser,
  });
}
