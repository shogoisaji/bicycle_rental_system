import 'package:bicycle_rental_system/domain/bicycle_model.dart';

class RentData {
  final Bicycle bicycle;
  final String rentDate;
  final int rentPeriod;
  final String currentRentUser;
  final String previousRentUser;

  RentData({
    required this.bicycle,
    required this.rentDate,
    required this.rentPeriod,
    required this.currentRentUser,
    required this.previousRentUser,
  });
}
