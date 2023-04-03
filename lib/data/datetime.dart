int getDayNumber(DateTime time) {
  // Return a unique number identifying this day starting January 1st, 1970
  return time.millisecondsSinceEpoch ~/ 86400000;
}

int getMonthNumber(DateTime time) {
  return time.month + time.year * 12;
}

int getMonthNumberFromDay(int dayNumber) {
  return getMonthNumber(
      DateTime.fromMillisecondsSinceEpoch(dayNumber * 86400000));
}

List<int> getDaysInMonth(int monthNumber) {
  int firstDayInMonth =
      getDayNumber(DateTime(monthNumber ~/ 12, monthNumber % 12, 1));
  int firstDayInNextMonth =
      getDayNumber(DateTime(monthNumber ~/ 12, monthNumber % 12 + 1, 1));

  List<int> days = [];
  for (int i = firstDayInMonth; i < firstDayInNextMonth; i++) {
    days.add(i);
  }

  return days;
}

List<int> getLast30Days(int todayDayNumber) {
  List<int> days = [];
  for (int i = todayDayNumber - 29; i <= todayDayNumber; i++) {
    days.add(i);
  }

  return days;
}
