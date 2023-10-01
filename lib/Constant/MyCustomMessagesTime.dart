import 'package:get_time_ago/get_time_ago.dart'; 

class ArabicMessagesTime implements Messages {
  @override
  String prefixAgo() => 'منذ';

  @override
  String suffixAgo() => '';

  @override
  String secsAgo(int seconds) => ' $seconds ثواني';

  @override
  String minAgo(int minutes) => ' دقيقة';

  @override
  String minsAgo(int minutes) => '$minutes دقايق';

  @override
  String hourAgo(int minutes) => 'ساعة';

  @override
  String hoursAgo(int hours) => '$hours ساعات';

  @override
  String dayAgo(int hours) => 'يوم';

  @override
  String daysAgo(int days) => '$days ايام';

  @override
  String wordSeparator() => ' ';

  String prefixFromNow() => '';

  String suffixFromNow()  => '';
}