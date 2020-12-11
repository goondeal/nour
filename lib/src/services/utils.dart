/// Returns only the date from the provided [datetime].
String majorDate(DateTime datetime) {
  return datetime.toLocal().toString().split(' ').first;
}
/// Decorates the date by replacing '-' by '/'.
String majorDateModified(DateTime datetime) {
  return majorDate(datetime).replaceAll('-', '/');
}
/// Checks if the provided [datetime] is today or not. 
bool isToday(DateTime datetime) {
  return majorDate(datetime) == majorDate(DateTime.now());
}
/// Checks if the provided [datetime] is yesterday or not.
bool isYesterday(DateTime datetime) {
  return majorDate(datetime) ==
      majorDate(DateTime.now().subtract(Duration(days: 1)));
}