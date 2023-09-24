import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/rent_data.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';

class RentalListCard extends StatefulWidget {
  final RentalData rentalData;
  final Bicycle? bicycleData;
  RentalListCard(
      {super.key, required this.rentalData, required this.bicycleData});

  @override
  State<RentalListCard> createState() => _RentalListCardState();
}

class _RentalListCardState extends State<RentalListCard> {
  String rentalUserName = 'none';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final firebaseService = FirebaseService();
    Map<String, dynamic>? userData =
        await firebaseService.fetchUserData(widget.rentalData.rentalUserID);
    if (userData != null) {
      setState(() {
        rentalUserName = userData['userName'];
      });
    } else {
      setState(() {
        rentalUserName = 'none';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MyDateFormat dateFormat = MyDateFormat();
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
      constraints: BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.bicycleData == null
                  ? Container()
                  : Image.network(
                      widget.bicycleData!.imageUrls[0],
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mediumText('Bicycle', Colors.black, 12),
                        widget.bicycleData == null
                            ? Container()
                            : mediumText('・${widget.bicycleData!.productName}',
                                Colors.black, 16),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mediumText('User', Colors.black, 12),
                        mediumText('・${rentalUserName}', Colors.black, 16),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        mediumText(
                            dateFormat.formatForDisplay(
                                widget.rentalData.rentalStartDate),
                            Colors.black,
                            14),
                        Icon(
                          Icons.arrow_downward,
                          size: 10,
                        ),
                        mediumText(
                            dateFormat.formatForDisplay(
                                widget.rentalData.rentalEndDate),
                            Colors.black,
                            14),
                      ],
                    ),
                    boldText('￥${f.format(widget.rentalData.rentalPrice)}',
                        Colors.black, 22),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
