import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude = 37.421632;
  double longitude = 122.084664;
  bool permissionAllowed = false;
  var selectedAddress;
  bool loading = false;

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;

      final coordinates = new Coordinates(this.latitude, this.longitude);
      //TODO: changes i made add if statement

      // print('coordinates: $coordinates');
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      // print('=> => => => => => => => ' + "${addresses.first}");

      this.selectedAddress = addresses.first;

      this.permissionAllowed = true;

      // print('permissionAllowed => => => => => => => =>' + '$permissionAllowed');
      notifyListeners();
    } else {
      print('Permission not allowed');
    }

    return position;
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final coordinates = new Coordinates(this.latitude, this.longitude);
    //TODO: changes i made add if statement

    if (coordinates != null) {
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.selectedAddress = addresses.first;
      notifyListeners();
      // print("${selectedAddress.featureName} : ${selectedAddress.addressLine}");
    }
  }

  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', this.latitude);
    prefs.setDouble('longitude', this.longitude);
    prefs.setString('address', this.selectedAddress.addressLine);
    prefs.setString('location', this.selectedAddress.featureName);
  }
}