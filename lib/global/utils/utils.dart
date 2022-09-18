bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

String fetchTime(int timeStamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  return "${date.day}-${date.month}-${date.year}";
}
