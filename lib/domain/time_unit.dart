enum TimeUnit {
  month,
  day,
  hour,
}

extension TimeUnitExtension on TimeUnit {
  String get timeUnitGetString {
    switch (this) {
      case TimeUnit.month:
        return 'month';
      case TimeUnit.day:
        return 'day';
      case TimeUnit.hour:
        return 'hour';
    }
  }
}
