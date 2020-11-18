import 'package:flutter/material.dart';

class AppConfig {
  static const appName = "Sam Will Do It";
  static const apiKey = 'AIzaSyB94toBjU5Ne7fz3xfjjS1PsgwaCabFKXg';

  static double size(BuildContext context, double s) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (height / width > 812 / 375) {
      return MediaQuery.of(context).size.width / 812 * s;
    } else {
      return MediaQuery.of(context).size.height / 375 * s;
    }
  }
}

class AvailableFonts {
  static const primaryFont = "Quicksand";
}

class AppColors {
  static const main = Color.fromRGBO(81, 175, 51, 1);
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
  }) {
    return Padding(
      padding:
          EdgeInsets.only(top: top, bottom: bottom, right: right, left: left),
      child: Text(
        text,
        style: TextStyle(fontSize: AppConfig.size(context, size)),
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
}
