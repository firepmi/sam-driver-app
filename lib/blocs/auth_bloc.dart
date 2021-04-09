import 'dart:async';

import 'package:sam_driver_app/firebase/firedataref.dart';

class AuthBloc {
  var _fireAuth = FireDataRef();
  StreamController _nameController = StreamController();
  StreamController _emailController = StreamController();
  StreamController _passController = StreamController();
  StreamController _phoneController = StreamController();
  StreamController _carMakeController = StreamController();
  StreamController _carModelController = StreamController();
  StreamController _carYearController = StreamController();
  StreamController _carColorController = StreamController();
  StreamController _carTagController = StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get emailStram => _emailController.stream;
  Stream get passStream => _passController.stream;
  Stream get phoneStream => _phoneController.stream;
  Stream get carMakeStream => _carMakeController.stream;
  Stream get carModelStream => _carModelController.stream;
  Stream get carYearStream => _carYearController.stream;
  Stream get carColorStream => _carColorController.stream;
  Stream get carTagStream => _carTagController.stream;

  bool isValid(String name, String email, String pass, String phone,
      String make, String model, String year, String color, String tag) {
    if (name == null || name.length == 0) {
      _nameController.sink.addError("Enter your name");
      return false;
    }
    _nameController.sink.add("");

    if (phone == null || phone.length == 0) {
      _phoneController.sink.addError("Enter your phone number");
      return false;
    }
    _phoneController.sink.add("");

    if (email == null || email.length == 0) {
      _emailController.sink.addError("Enter your email");
      return false;
    }
    _emailController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink
          .addError("Password must be longer than 6 characters");
      return false;
    }
    _passController.sink.add("");

    if (make == null || make.length == 0) {
      _carMakeController.sink.addError("Enter your Car Make");
      return false;
    }
    _carMakeController.sink.add("");

    if (model == null || model.length == 0) {
      _carModelController.sink.addError("Enter your Car Model");
      return false;
    }
    _carModelController.sink.add("");

    if (year == null || year.length == 0) {
      _carYearController.sink.addError("Enter your Car Year");
      return false;
    }
    _carYearController.sink.add("");

    if (color == null || color.length == 0) {
      _carColorController.sink.addError("Enter your Car Color");
      return false;
    }
    _carColorController.sink.add("");

    if (tag == null || tag.length == 0) {
      _carTagController.sink.addError("Enter your Tag number");
      return false;
    }
    _carTagController.sink.add("");
    return true;
  }

  void signUp(
      String email,
      String pass,
      String phone,
      String name,
      String make,
      String model,
      String year,
      String color,
      String tag,
      Function onSuccess,
      Function(String) onRegisterError) {
    _fireAuth.signUp(email, pass, name, phone, make, model, year, color, tag,
        onSuccess, onRegisterError);
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _fireAuth.signIn(email, pass, onSuccess, onSignInError);
  }

  void dispose() {
    _nameController.close();
    _emailController.close();
    _passController.close();
    _phoneController.close();
    _carMakeController.close();
    _carModelController.close();
    _carYearController.close();
    _carColorController.close();
    _carTagController.close();
  }
}
