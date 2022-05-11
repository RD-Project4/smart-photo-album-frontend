import 'package:geocoding/geocoding.dart';

class GeoUtil {
  static Future<String?> locationFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude,localeIdentifier: "en_us");
    return placemarks.first.locality;
  }
}
