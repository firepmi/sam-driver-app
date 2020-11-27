import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sam_driver_app/blocs/data_bloc.dart';
import 'package:sam_driver_app/ui/widgets/profilewidget.dart';
import 'package:sam_driver_app/util/globals.dart';
import 'package:sam_driver_app/util/utils.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileView();
  }
}

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  DataBloc dataBloc = DataBloc();
  String name = "Welcome! Driver";
  var profileUrl = "";
  var rating = "-";
  File _image;
  final picker = ImagePicker();
  final aboutMeController = TextEditingController();
  var isEditable = false;
  @override
  void initState() {
    super.initState();
    dataBloc.getDriverProfile((data) {
      name = data["name"];
      if (data["aboutme"] == null) {
        isEditable = false;
      } else {
        isEditable = true;
        aboutMeController.text = data["aboutme"];
      }
      if (mounted) {
        setState(() => null);
      }
    });
    dataBloc.getProfileImage((url) {
      setState(() {
        profileUrl = url;
      });
    });
  }

  void onProfileUpdate() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Image from..."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    onCamera();
                  },
                  child: Text("Camera"),
                ),
                FlatButton(
                  onPressed: () {
                    onGallery();
                  },
                  child: Text("Gallery"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, "cancel");
                  },
                  child: Text("Cancel"),
                )
              ],
            ));
  }

  void onCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState(() {
      Navigator.pop(context, "camera");
    });
    uploadProfileImage();
  }

  void onGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState(() {
      Navigator.pop(context, "gallery");
    });
    uploadProfileImage();
  }

  void uploadProfileImage() {
    if (_image == null) {
      return;
    }
    dataBloc.uploadProfile(_image.readAsBytesSync(), () {
      print("image upload completed");
      Fluttertoast.showToast(
          msg: "Profile image uploaded successfully.",
          toastLength: Toast.LENGTH_LONG);
    });
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  void saveAboutMe() {
    dataBloc.saveAboutMe(aboutMeController.text, () {
      print("about me saved");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Successfully saved!"),
        ),
      );
    }, (error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          body: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
              elevation: 0.0,
              leading: FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, size: 26, color: Colors.white)),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: signOut,
                    child: Icon(
                      Icons.logout,
                      size: 26.0,
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.main),
                    child: Center(
                      child: ProfileWidget(
                        onPressed: () => onProfileUpdate(),
                        profileUrl: profileUrl,
                        name: name,
                        rating: "4.88",
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "3,914",
                                    style: TextStyle(
                                      fontSize: AppConfig.size(context, 10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Trips",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: AppConfig.size(context, 6)),
                                  ),
                                ],
                              ),
                              Container(
                                height: AppConfig.size(context, 20),
                                width: 1,
                                decoration: BoxDecoration(
                                    border: Border(
                                        right:
                                            BorderSide(color: Colors.black12))),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "4",
                                    style: TextStyle(
                                      fontSize: AppConfig.size(context, 10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Years",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: AppConfig.size(context, 6)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 20),
                        isEditable
                            ? Column(
                                children: [
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[300], width: 1),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(4.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Container(
                                          height: AppConfig.size(context, 44),
                                          width: AppConfig.size(context, 200),
                                          child: TextField(
                                            controller: aboutMeController,
                                            maxLength: 500,
                                            maxLines: 10,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Tell customers a little about yourself"),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: saveAboutMe,
                                    child: Container(
                                        width: AppConfig.size(context, 80),
                                        height: AppConfig.size(context, 20),
                                        margin: EdgeInsets.only(bottom: 10),
                                        alignment: FractionalOffset.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blue, width: 2),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(4.0)),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            // Navigator.pushNamed(context, "/edit_profile");
                                            isEditable = true;
                                            setState(() {});
                                          },
                                          child: Text('Save',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: AppConfig.size(
                                                      context, 6),
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: AppConfig.size(context, 6),
                                  ),
                                  Text(
                                    "Tell customers a little about yourself",
                                    style: TextStyle(
                                        fontSize: AppConfig.size(context, 7)),
                                  ),
                                  SizedBox(
                                    height: AppConfig.size(context, 10),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        width: AppConfig.size(context, 80),
                                        height: AppConfig.size(context, 20),
                                        margin: EdgeInsets.only(bottom: 10),
                                        alignment: FractionalOffset.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blue, width: 2),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(4.0)),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            // Navigator.pushNamed(context, "/edit_profile");
                                            isEditable = true;
                                            setState(() {});
                                          },
                                          child: Text('ADD DETAILS',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: AppConfig.size(
                                                      context, 6),
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                        SizedBox(height: 20),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Complements",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: AppConfig.size(context, 8),
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "VIEW ALL",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: AppConfig.size(context, 8),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        makeComplimentsList(context, "Cool Car"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

Widget makeComplimentsList(BuildContext context, String title) {
  return Container(
    padding: EdgeInsets.only(left: 5, right: 5),
    height: AppConfig.size(context, 121),
    child: Column(
      children: <Widget>[
        Container(
          height: AppConfig.size(context, 120),
          child: ListView(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            children: makeContainers(context, title),
          ),
        )
      ],
    ),
  );
}

int counter = 0;
List<Widget> makeContainers(BuildContext context, String title) {
  List<Container> complimentsList = [];
  for (var i = 0; i < 6; i++) {
    counter++;
    complimentsList.add(Container(
      margin: EdgeInsets.only(right: 10),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  "assets/images/sam_logo.png",
                  width: AppConfig.size(context, 36),
                  height: AppConfig.size(context, 36),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: AppConfig.size(context, 6),
                      color: Colors.black),
                ),
              ),
            ],
          ),
          Positioned(
            left: AppConfig.size(context, 26),
            top: -1,
            child: Container(
              width: AppConfig.size(context, 10),
              height: AppConfig.size(context, 10),
              decoration: BoxDecoration(
                color: AppColors.main,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Center(
                child: Text("1",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    ));
    if (counter == 12) {
      counter = 0;
    }
  }
  return complimentsList;
}
