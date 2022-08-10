import 'dart:io';

class GetConnection {
  final String _baseUrl = "e-warung.my.id";

  getConnection() async {
    try {
      final result = await InternetAddress.lookup(_baseUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
