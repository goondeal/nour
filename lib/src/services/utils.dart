String majorDate(DateTime date) {
  return date.toLocal().toString().split(' ').first;
}

String majorDateModified(DateTime date) {
  return majorDate(date).replaceAll('-', '/');
}

bool isToday(DateTime date) {
  return majorDate(date) == majorDate(DateTime.now());
}

bool isYesterday(DateTime date) {
  return majorDate(date) ==
      majorDate(DateTime.now().subtract(Duration(days: 1)));
}