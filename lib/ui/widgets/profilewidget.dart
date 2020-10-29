import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sam_driver_app/util/globals.dart';
import 'package:sam_driver_app/util/utils.dart';

class ProfileWidget extends StatefulWidget {
  final String name, rating, profileUrl;
  final Function() onPressed;

  const ProfileWidget(
      {Key key, this.name, this.rating, this.profileUrl, this.onPressed})
      : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  void goToSelectCar() async {
    var value = await Navigator.pushNamed(context, "/select_car_size");
    print("call back");
    setState(() {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: AppConfig.size(context, 4)),
              ClipOval(
                child: widget.profileUrl != ""
                    ? FadeInImage.assetNetwork(
                        image: widget.profileUrl,
                        placeholder: 'assets/images/default_profile.png',
                        // "assets/images/default_profile.png",
                        width: AppConfig.size(context, 36),
                        height: AppConfig.size(context, 36),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/default_profile.png",
                        width: AppConfig.size(context, 36),
                        height: AppConfig.size(context, 36),
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: AppConfig.size(context, 4)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    SizedBox(
                      width: AppConfig.size(context, 4),
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                            child: SvgPicture.asset(
                              AppIcons.cars[Globals.carSize.index],
                              color: Colors.white,
                              width: AppConfig.size(context, 24),
                              height: AppConfig.size(context, 24),
                            ),
                            onTap: () => goToSelectCar()),
                        Positioned(
                            child: ButtonTheme(
                              minWidth: 5.0,
                              height: AppConfig.size(context, 8),
                              buttonColor: Colors.white,
                              shape: CircleBorder(),
                              child: RaisedButton(
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: AppConfig.size(context, 5),
                                  color: Colors.black,
                                ),
                                onPressed: () => goToSelectCar(),
                                splashColor: Colors.black,
                                elevation: 5.0,
                              ),
                            ),
                            top: AppConfig.size(context, 7),
                            left: AppConfig.size(context, 10))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConfig.size(context, 4)),
              Container(
                width: AppConfig.size(context, 60),
                height: AppConfig.size(context, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.rating,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: AppConfig.size(context, 7),
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: AppConfig.size(context, 8),
                    )
                  ],
                ),
              ),
              SizedBox(height: AppConfig.size(context, 8))
            ],
          ),
        ],
      ),
    );
  }
}
