// covert dateTime object to a string yymmdd

String convertDateTimeToString(DateTime dateTime){
  // year in the format -> yyy
  String year = dateTime.year.toString();

  // month in the format -> mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }  
  
  // dat in the format -> dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }


  // final format -> yyymmdd
  String yyymmdd = year + month + day;

  return yyymmdd;
}