import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sam_driver_app/blocs/data_bloc.dart';
import 'package:sam_driver_app/util/globals.dart';
import 'package:sam_driver_app/util/map_util.dart';
import 'package:sam_driver_app/util/utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;
  var online = true;

  // Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polyline width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  int jointTypesIndex = 0;
  List<JointType> jointTypes = <JointType>[
    JointType.mitered,
    JointType.bevel,
    JointType.round
  ];

  // Values when toggling polyline end cap type
  int endCapsIndex = 0;
  List<Cap> endCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline start cap type
  int startCapsIndex = 0;
  List<Cap> startCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline pattern
  int patternsIndex = 0;
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[],
    <PatternItem>[
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)],
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)],
  ];

  //GoogleMapController _mapController;

  static final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(-8.913025, 13.202462),
    zoom: 17.0,
  );

  DataBloc dataBloc = DataBloc();
  var profileUrl = "";
  Completer<GoogleMapController> _completer = Completer();
  MapUtil mapUtil = MapUtil();
  Location _locationService = new Location();
  LatLng currentLocation;
  LatLng _center = LatLng(45.1975844, -122.9598339);
  PermissionStatus _permission = PermissionStatus.denied;
  List<Marker> _markers = List();
  List<Polyline> routes = new List();
  double cameraZoom = 13;
  Timer timer;
  var isStarted = false;

  int currentSeconds = 0;
  String get timerText =>
      '${(currentSeconds ~/ 60).toString().padLeft(2, '0')}: ${(currentSeconds % 60).toString().padLeft(2, '0')}';

  startTimeout() {
    final interval = const Duration(seconds: 1);
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (!isStarted) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    //_mapController.mar();
    super.initState();
    dataBloc.getProfileImage((url) {
      setState(() {
        profileUrl = url;
      });
    });
    initPlatformState();
  }

  initPlatformState() async {
    _locationService.requestPermission().then((value) {
      print(value);
      if (value == null) {
        _locationService.requestPermission().then((value2) {
          _permission = value2;
          if (_permission == PermissionStatus.granted) {
            getLocation();
          }
        });
      }
      _permission = value;
      if (_permission == PermissionStatus.granted) {
        getLocation();
      }
      return null;
    });
  }

  getLocation() async {
    LocationData location;
    location = await _locationService.getLocation();
    Marker marker = Marker(
      markerId: MarkerId('from_address'),
      position: LatLng(location.latitude, location.longitude),
      infoWindow: InfoWindow(title: 'My location'),
    );
    if (mounted) {
      setState(() {
        currentLocation = LatLng(location.latitude, location.longitude);
        _center = LatLng(currentLocation.latitude, currentLocation.longitude);
        _markers.add(marker);
        moveCamera(_center);
      });
    }

    _locationService.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = LatLng(cLoc.latitude, cLoc.longitude);
      _center = currentLocation;
      print(_center);
      // if (fromLocation == null && toLocation == null) {
      moveCamera(_center);
      // }
    });
  }

  void moveCamera(LatLng nPos) async {
    final GoogleMapController controller = await _completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(zoom: cameraZoom, target: nPos)));
  }

  void checkMyRequests() {
    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        print("is Waiting : ${Globals.isWaiting}");
        if (!Globals.isWaiting)
          timer.cancel();
        else {
          dataBloc.getRequests(onRequestResults);
        }
      });
    }
  }

  void onRequestResults(dynamic data) {
    Globals.isWaiting = false;
    Navigator.pushNamed(context, '/request_details', arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    checkMyRequests();
    return Scaffold(
      bottomNavigationBar: Container(
        height: !online ? 90 : 0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey, blurRadius: 11, offset: Offset(3.0, 4.0))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.keyboard_arrow_up)),
            Text("You're offline",
                style: TextStyle(
                  fontSize: 30,
                )),
            Container(
                padding: EdgeInsets.only(right: 20), child: Icon(Icons.list)),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      bottomSheet: Container(
        height: 300,
        decoration: BoxDecoration(color: Colors.black),
        child: Column(),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _completer.complete(controller);
              //_initCameraPosition();
            },
            markers: Set<Marker>.of(_markers),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FunctionalButton(
                          icon: Icons.search,
                          title: "",
                          onPressed: () {},
                        ),
                        PriceWidget(
                          price: "0.00",
                          onPressed: () {},
                        ),
                        ProfileWidget(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/notifications'),
                          profileUrl: profileUrl,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //   timerText,
                  //   style: TextStyle(fontFamily: 'Seven-Segment'),
                  // )
                  AppStyle.label(context, timerText,
                      fontFamily: 'Seven-Segment', size: 20),
                ],
              ),
            ),
          ),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FunctionalButton(
                      icon: Icons.security,
                      title: "",
                      onPressed: () {},
                    ),
                    GoButton(
                      started: isStarted,
                      onPressed: () {
                        setState(() {
                          isStarted = !isStarted;
                          if (isStarted) {
                            startTimeout();
                          }
                        });
                      },
                    ),
                    Container(
                      width: 50,
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FunctionalButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function() onPressed;

  const FunctionalButton({Key key, this.title, this.icon, this.onPressed})
      : super(key: key);

  @override
  _FunctionalButtonState createState() => _FunctionalButtonState();
}

class _FunctionalButtonState extends State<FunctionalButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RawMaterialButton(
          onPressed: widget.onPressed,
          splashColor: Colors.black,
          fillColor: Colors.white,
          elevation: 15.0,
          shape: CircleBorder(),
          child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Icon(
                widget.icon,
                size: 30.0,
                color: Colors.black,
              )),
        ),
      ],
    );
  }
}

class ProfileWidget extends StatefulWidget {
  final Function() onPressed;
  final String profileUrl;

  const ProfileWidget({Key key, this.profileUrl, this.onPressed})
      : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 4),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.grey, blurRadius: 11, offset: Offset(3.0, 4.0))
          ],
        ),
        child: ClipOval(
          child: widget.profileUrl != ""
              ? FadeInImage.assetNetwork(
                  image: widget.profileUrl,
                  placeholder: 'assets/images/default_profile.png',
                  // "assets/images/default_profile.png",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  "assets/images/default_profile.png",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class PriceWidget extends StatefulWidget {
  final String price;
  final Function() onPressed;

  const PriceWidget({Key key, this.price, this.onPressed}) : super(key: key);

  @override
  _PriceWidgetState createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4),
        color: AppColors.main,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey, blurRadius: 11, offset: Offset(3.0, 4.0))
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, "/earnings"),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("\$",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
            Text(widget.price,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class GoButton extends StatefulWidget {
  final Function() onPressed;
  final bool started;

  const GoButton({Key key, this.started, this.onPressed}) : super(key: key);

  @override
  _GoButtonState createState() => _GoButtonState();
}

class _GoButtonState extends State<GoButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: widget.started ? AppColors.main : Colors.red,
                  width: 10),
              borderRadius: BorderRadius.all(Radius.circular(30))
              // shape: BoxShape.circle,
              ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: RawMaterialButton(
              onPressed: widget.onPressed,
              splashColor: Colors.black,
              fillColor: widget.started ? AppColors.main : Colors.red,
              elevation: 15.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  widget.started ? "End Shift" : "Start Shift",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
