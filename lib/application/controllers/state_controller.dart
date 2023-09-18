import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  static StateController instance = Get.find();
  TimeTag _timeTagState = TimeTag.hour;

  void changeTimeTagState(TimeTag timeTag) {
    _timeTagState = timeTag;
    update();
  }

  TimeTag get timeTagState {
    return _timeTagState;
  }

  String get unit {
    switch (_timeTagState) {
      case TimeTag.month:
        return 'M';
      case TimeTag.day:
        return 'D';
      case TimeTag.hour:
        return 'H';
    }
  }

  int get priceRate {
    switch (_timeTagState) {
      case TimeTag.month:
        return 23 * 28;
      case TimeTag.day:
        return 23;
      case TimeTag.hour:
        return 1;
    }
  }
}
