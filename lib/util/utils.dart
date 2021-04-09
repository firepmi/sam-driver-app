import 'package:flutter/material.dart';

class AppConfig {
  static const appName = "Sam Will Do It";
  static const apiKey = 'AIzaSyB94toBjU5Ne7fz3xfjjS1PsgwaCabFKXg';
  static const checkingURL = "https://completecriminalchecks.com/api/json/?";
  static const checkingKey = "svq9xw50p12f5h6j21t1n1";

  static double size(BuildContext context, double s) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (height / width > 812 / 375) {
      return MediaQuery.of(context).size.width / 812 * s;
    } else {
      return MediaQuery.of(context).size.height / 375 * s;
    }
  }

  static void showAlertDialog(
      BuildContext context, String title, String content, Function onPressed) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        onPressed();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class AvailableFonts {
  static const primaryFont = "Quicksand";
}

class AppColors {
  static const main = Color.fromRGBO(81, 175, 51, 1);
  static const greyColor2 = Color(0xffE8E8E8);
  static const themeColor = Color(0xfff5a623);
  static const greyColor = Color(0xffaeaeae);
}

class AvailableImages {
  static const emptyState = {
    'assetImage': AssetImage('assets/images/empty.png'),
    'assetPath': 'assets/images/empty.png',
  };

  static const homePage = const AssetImage('assets/images/home_page.png');
  static const appLogo = const AssetImage('assets/images/sam_logo.png');
  static const appLogo1 =
      const AssetImage('assets/images/sam_logo_transparent.png');
  static const bgWelcome = const AssetImage('assets/images/bg_welcome.png');
}

class AppIcons {
  static const cars = [
    'assets/svg/automobile.svg',
    'assets/svg/suv.svg',
    'assets/svg/pickup.svg',
    'assets/svg/van.svg',
    'assets/svg/trailer.svg',
    'assets/svg/truck.svg',
  ];
}

class AppStyle {
  static Widget label(
    BuildContext context,
    String text, {
    double size = 8,
    double top = 0,
    double bottom = 0,
    double right = 0,
    double left = 0,
    String fontFamily,
  }) {
    return Padding(
      padding:
          EdgeInsets.only(top: top, bottom: bottom, right: right, left: left),
      child: Text(
        text,
        style: TextStyle(
            fontSize: AppConfig.size(context, size), fontFamily: fontFamily),
      ),
    );
  }

  static Widget titleLabel(BuildContext context, String text,
      {double size = 8}) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: AppConfig.size(context, size)),
    );
  }

  static Widget button(BuildContext context, String text,
      {Function onPressed, Color fillColor = AppColors.main}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: SizedBox(
        width: double.infinity,
        height: AppConfig.size(context, 21),
        child: RawMaterialButton(
          fillColor: fillColor,
          elevation: 5.0,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: AppConfig.size(context, 6)),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(AppConfig.size(context, 10)))),
        ),
      ),
    );
  }

  static Widget borderButton(BuildContext context, String text,
      {Function onPressed, Color borderColor = AppColors.main}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
      child: SizedBox(
        width: double.infinity,
        height: AppConfig.size(context, 15),
        child: RawMaterialButton(
          // fillColor: borderColor,
          elevation: 5.0,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: borderColor, fontSize: AppConfig.size(context, 6)),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: borderColor, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(
                  Radius.circular(AppConfig.size(context, 10)))),
        ),
      ),
    );
  }

  static Widget requestCard(BuildContext context, dynamic info,
      {Function onTap, Function onMessage}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          // color: Colors.pink,
          elevation: 16,
          child: Column(children: [
            Row(children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: info["client_profile_image"] != null
                    ? ClipOval(
                        child: FadeInImage.assetNetwork(
                          image: info["client_profile_image"],
                          placeholder: 'assets/images/default_profile.png',
                          // "assets/images/default_profile.png",
                          width: AppConfig.size(context, 30),
                          height: AppConfig.size(context, 30),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        "assets/images/default_profile.png",
                        width: AppConfig.size(context, 30),
                        height: AppConfig.size(context, 30),
                        fit: BoxFit.cover,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            info["client_profile_name"] == null
                                ? "Boss"
                                : info["client_profile_name"],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$ ${info["price"]}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          info["client_profile_phone"],
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                          child: AppStyle.borderButton(context, "Message",
                              onPressed: onMessage)),
                    ],
                  ),
                ]),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
