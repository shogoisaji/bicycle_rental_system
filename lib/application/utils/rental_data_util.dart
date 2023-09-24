import 'package:bicycle_rental_system/domain/rent_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentalDataUtil {
  static RentalData rentalDataFromMap(DocumentSnapshot<Object?> rentalDataMap) {
    return RentalData(
      rentalID: rentalDataMap.id,
      bicycleID: rentalDataMap['bicycleID'],
      rentalStartDate: rentalDataMap['rentalStartDate'],
      rentalEndDate: rentalDataMap['rentalEndDate'],
      rentalUserID: rentalDataMap['rentalUserID'],
      rentalPrice: rentalDataMap['rentalPrice'],
    );
  }
}
