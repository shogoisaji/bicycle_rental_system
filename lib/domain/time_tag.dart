enum TimeTag {
  month,
  day,
  hour,
}

extension TimeTagExtension on TimeTag {
  String get unit {
    switch (this) {
      case TimeTag.month:
        return 'M';
      case TimeTag.day:
        return 'D';
      case TimeTag.hour:
        return 'H';
    }
  }
}
