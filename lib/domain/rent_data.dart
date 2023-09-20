import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';

class RentData {
  final Bicycle bicycle;
  final String rentDate;
  final int rentPeriod;
  final TimeUnit timeTag;
  final String currentRentUser;
  final String previousRentUser;

  RentData({
    required this.bicycle,
    required this.rentDate,
    required this.rentPeriod,
    required this.timeTag,
    required this.currentRentUser,
    required this.previousRentUser,
  });
}
