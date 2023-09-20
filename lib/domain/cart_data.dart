import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';

class CartData {
  final Bicycle bicycle;
  final int rentPeriod;
  final TimeUnit timeTag;

  CartData({
    required this.bicycle,
    required this.rentPeriod,
    required this.timeTag,
  });
}
