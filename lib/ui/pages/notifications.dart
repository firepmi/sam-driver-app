import 'package:flutter/material.dart';
import 'package:sam_driver_app/blocs/data_bloc.dart';
import 'package:sam_driver_app/util/utils.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationsView();
  }
}

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

const kExpandedHeight = 300.0;

class _NotificationsViewState extends State<NotificationsView> {
  ScrollController _scrollController;
  DataBloc dataBloc = DataBloc();
  String name = "Welcome! Driver";
  var profileUrl = "";
  @override
  void initState() {
    super.initState();
    dataBloc.getProfileImage((url) {
      setState(() {
        profileUrl = url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: kExpandedHeight,
                floating: false,
                automaticallyImplyLeading: false,
                pinned: true,
                backgroundColor: AppColors.main,
                leading: GestureDetector(
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: 28, color: Colors.white),
                  ),
                ),
                actions: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "HELP",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Icon(Icons.help, size: 28, color: Colors.white),
                    ],
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      Container(
                        height: 300,
                        decoration: BoxDecoration(color: AppColors.main),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 80,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FunctionalButton(
                                  icon: Icons.attach_money,
                                  title: "Earnings",
                                  onPressed: () =>
                                      Navigator.pushNamed(context, "/earnings"),
                                ),
                                ProfileButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, "/profile"),
                                  profileUrl: profileUrl,
                                  title: "Profile",
                                  rating: "4.88",
                                ),
                                FunctionalButton(
                                  icon: Icons.settings,
                                  title: "Account",
                                  onPressed: () =>
                                      Navigator.pushNamed(context, "/account"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ];
          },
          body: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Notifications",
                      style: TextStyle(fontSize: 28, color: Colors.black),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Explore these safety features",
                        style: TextStyle(fontSize: 20)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("9/17/18, 3:54 PM",
                            style: TextStyle(fontSize: 16))),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Free Instant Pay cashouts this week",
                        style: TextStyle(fontSize: 20)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("9/17/18, 3:54 PM",
                            style: TextStyle(fontSize: 16))),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Track your earnings",
                        style: TextStyle(fontSize: 20)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("9/17/18, 3:54 PM",
                            style: TextStyle(fontSize: 16))),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Follow the opportunity",
                        style: TextStyle(fontSize: 20)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("9/17/18, 3:54 PM",
                            style: TextStyle(fontSize: 16))),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Plan your day with ease the opportunity",
                        style: TextStyle(fontSize: 20)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("9/17/18, 3:54 PM",
                            style: TextStyle(fontSize: 16))),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Your earnings are processed Tuesday at noon",
                        style: TextStyle(fontSize: 20)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("9/17/18, 3:54 PM",
                            style: TextStyle(fontSize: 16))),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title:
                        Text("Welcome, Márcio", style: TextStyle(fontSize: 20)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("9/17/18, 3:54 PM",
                            style: TextStyle(fontSize: 16))),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(
                        Icons.person_pin,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
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
          fillColor: Colors.blue,
          elevation: 15.0,
          shape: CircleBorder(),
          child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                widget.icon,
                size: AppConfig.size(context, 16),
                color: Colors.white,
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class ProfileButton extends StatefulWidget {
  final String title, rating, profileUrl;
  final Function() onPressed;

  const ProfileButton(
      {Key key, this.title, this.rating, this.profileUrl, this.onPressed})
      : super(key: key);

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
          Positioned(
            left: AppConfig.size(context, 3),
            top: AppConfig.size(context, 28),
            child: Container(
              height: AppConfig.size(context, 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: AppConfig.size(context, 5)),
                  Text(widget.rating,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: AppConfig.size(context, 6),
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: AppConfig.size(context, 6),
                  ),
                  SizedBox(
                    width: AppConfig.size(context, 4),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
