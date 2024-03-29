import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sam_driver_app/firebase/firedataref.dart';

class DataBloc {
  var _fireData = FireDataRef();

  void request(List<LatLng> path, startLat, startLon, endLat, endLon, onSuccess,
      onError) {
    _fireData.request(
        path, startLat, startLon, endLat, endLon, onSuccess, onError);
  }

  void getDriverProfile(Function(dynamic) onSuccess) {
    _fireData.getDriverProfile(onSuccess);
  }

  void uploadProfile(Uint8List data, Function onSuccess) {
    _fireData.uploadImage(data, onSuccess);
  }

  void setLocation(double lat, double long) {
    _fireData.setLocation(lat, long);
  }

  void getProfileImage(Function(String) onSuccess, {String uid = ""}) {
    if (uid == "") uid = FirebaseAuth.instance.currentUser.uid;
    _fireData.getProfileImage(uid, onSuccess);
  }

  void getRequests(Function(dynamic) onSuccess) async {
    _fireData.getRequests(onSuccess);
  }

  void getAllRequests(Function(dynamic) onSuccess) async {
    _fireData.getAllRequests(onSuccess);
  }

  void getClientInfo(String clientId, Function(dynamic) onSuccess) async {
    _fireData.getClientInfo(clientId, onSuccess);
  }

  Future<String> getAboutMe() async {
    var aboutMe = await _fireData.getAboutMe();
    return aboutMe;
  }

  void saveAboutMe(
      String aboutMe, Function onSuccess, Function(dynamic) onError) {
    _fireData.saveAboutMe(aboutMe, onSuccess, onError);
  }

  void acceptOffer(String id, Function onSuccess, Function(dynamic) onError) {
    _fireData.acceptOffer(id, onSuccess, onError);
  }

  void rejectOffer(String id, Function onSuccess, Function(dynamic) onError) {
    _fireData.rejectOffer(id, onSuccess, onError);
  }

  void completedOffer(
      String id, Function onSuccess, Function(dynamic) onError) {
    _fireData.completedOffer(id, onSuccess, onError);
  }
}
