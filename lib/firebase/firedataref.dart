import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireDataRef {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(
      String email,
      String pass,
      String name,
      String phone,
      String make,
      String model,
      String year,
      String color,
      String tag,
      Function onSuccess,
      Function(String) onRegisterError) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((credentials) {
      //
      _createUser(credentials.user.uid, name, phone, make, model, year, color,
          tag, onSuccess, onRegisterError);
      print(credentials);
    }).catchError((err) {
      print(err);
      _onSignUpError(err.code, onRegisterError);
    });
  }

  _createUser(
      String userId,
      String name,
      String phone,
      String make,
      String model,
      String year,
      String color,
      String tag,
      Function onSuccess,
      Function(String) onRegisterError) {
    var user = {
      "name": name,
      "phone": phone,
      "make": make,
      "model": model,
      "year": year,
      "color": color,
      "tag": tag,
    };
    var ref = FirebaseDatabase.instance.reference().child("drivers");

    ref.child(userId).set(user).then((user) {
      // success
      onSuccess();
    }).catchError((err) {
      onRegisterError(err.toString());
    });
  }

  void request(
      List<LatLng> path,
      double startLat,
      double startLon,
      double endLat,
      double endLon,
      Function onSuccess,
      Function(String) onError) {
    var user = FirebaseAuth.instance.currentUser;
    var date = DateTime.now();
    var pathStr = "";
    path.forEach((element) {
      pathStr += "${element.latitude},${element.longitude}";
    });
    var request = {
      "start_lat": startLat,
      "start_lon": startLon,
      "end_lat": endLat,
      "end_lon": endLon,
      "request_date": date.millisecondsSinceEpoch,
      "state": "awaiting",
      "path": pathStr
    };
    var ref = FirebaseDatabase.instance.reference().child("requests");

    ref.child(user.uid).set(request).then((data) {
      // success
      onSuccess();
    }).catchError((err) {
      onError(err.toString());
    });
  }

  void getDriverProfile(Function(dynamic) onSuccess) {
    var user = FirebaseAuth.instance.currentUser;
    var ref =
        FirebaseDatabase.instance.reference().child("drivers").child(user.uid);
    ref.once().then((DataSnapshot data) {
      onSuccess(data.value);
    });
  }

  void getClientInfo(String clientId, Function(dynamic) onSuccess) {
    var ref =
        FirebaseDatabase.instance.reference().child("users").child(clientId);
    ref.once().then((DataSnapshot data) {
      onSuccess(data.value);
    });
  }

  void setLocation(double lat, double long) {
    var user = FirebaseAuth.instance.currentUser;

    var ref = FirebaseDatabase.instance.reference().child("drivers");

    var request = {"lat": lat, "long": long};

    ref.child(user.uid).update(request);
  }

  void uploadImage(Uint8List data, Function onSuccess) async {
    var user = FirebaseAuth.instance.currentUser;

    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(user.uid + ".jpg");

    try {
      await storageReference.putData(data);
      onSuccess();
    } catch (e) {
      print(e);
    }
  }

  void getProfileImage(String uid, Function(String) onSuccess) async {
    final ref =
        FirebaseStorage.instance.ref().child("profile").child(uid + ".jpg");
    try {
      String profileUrl = (await ref.getDownloadURL() ?? "").toString();
      onSuccess(profileUrl);
    } catch (error) {
      print(error.toString());
    }
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      print("on SignIn in success");
      onSuccess();
    }).catchError((err) {
      print(err);
      onSignInError("SignIn fail, please try again");
    });
  }

  void _onSignUpError(String code, Function(String) onRegisterError) {
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid Email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("Signup fail, please try again");
        break;
    }
  }

  void getRequests(Function(dynamic) onSuccess) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      var data = await ref
          .orderByChild("driver_id")
          .equalTo(uid)
          // .orderByChild("status")
          // .equalTo("waiting")
          .once();

      List<Map> maps = [];

      if (data.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(data.value);
        mapOfMaps.forEach((key, value) {
          if (value["status"] == "accepted") {
            value["data_id"] = key;
            maps.add(value);
          }
        });
      }

      onSuccess(maps);

      return;
    } catch (error) {
      print(error.toString());
    }
  }

  void getAllRequests(Function(dynamic) onSuccess) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      var data = await ref
          .orderByChild("driver_id")
          .equalTo(uid)
          // .orderByChild("status")
          // .equalTo("waiting")
          .once();

      Map<String, dynamic> mapOfMaps = Map.from(data.value);
      List<Map> maps = [];

      mapOfMaps.forEach((key, value) {
        // if (value["status"] == "accepted") {
        value["data_id"] = key;
        maps.add(value);
        // }
      });

      onSuccess(maps);

      return;
    } catch (error) {
      print(error.toString());
    }
  }

  void saveAboutMe(
      String aboutMe, Function onSuccess, Function(dynamic) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("drivers");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      await ref.child(uid).child("aboutme").set(aboutMe);
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  Future<String> getAboutMe() async {
    var ref = FirebaseDatabase.instance.reference().child("drivers");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      var aboutme = await ref.child(uid).child("aboutme").once();
      return aboutme.value;
    } catch (error) {
      return null;
    }
  }

  void acceptOffer(
      String id, Function onSuccess, Function(dynamic) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    try {
      await ref.child(id).child("status").set("accepted");
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  void rejectOffer(
      String id, Function onSuccess, Function(dynamic) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    try {
      await ref.child(id).child("status").set("rejected");
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  void completedOffer(
      String id, Function onSuccess, Function(dynamic) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    try {
      await ref.child(id).child("status").set("completed");
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }
}
