import 'package:bicycle_rental_system/domain/bicycle_model.dart';

class CartItem {
  final Bicycle bicycle;
  int rentPeriod;

  CartItem({
    required this.bicycle,
    required this.rentPeriod,
  });
}
