import 'package:intl/intl.dart'; // nhớ thêm vào pubspec.yaml: intl: ^0.18.0

String formatDateTime(String isoString) {
  try {
    final dateTime = DateTime.parse(isoString);
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  } catch (e) {
    return isoString; // nếu lỗi thì trả nguyên chuỗi
  }
}
