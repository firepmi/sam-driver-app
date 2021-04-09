import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:sam_driver_app/blocs/data_bloc.dart';
import 'package:sam_driver_app/util/utils.dart';

import 'chat.dart';
import 'home.dart';

class RequestsListPage extends StatefulWidget {
  @override
  _RequestsListPageState createState() => _RequestsListPageState();
}

class _RequestsListPageState extends State<RequestsListPage> {
  // final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  double _fontSize = 14;
  // List _items;
  final DataBloc dataBloc = DataBloc();
  bool isEmpty = false;
  bool isLoading = true;

  List<Widget> requests = List<Widget>();
  List<Map> requestsData = [];

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  void getRequests() async {
    requests = [];
    requestsData = [];
    dataBloc.getAllRequests(onRequestResults);
  }

  void onRequestResults(dynamic data) {
    if (data == []) {
      // Navigator.pushNamed(context, '/home');
      isEmpty = true;
      setState(() {});
    } else {
      isEmpty = false;
      requestsData = data;
      refreshView();
    }
  }

  Future<String> getProfileImage(String id) async {
    var profileUrl = "";

    final ref =
        FirebaseStorage.instance.ref().child("profile").child(id + ".jpg");
    try {
      profileUrl = (await ref.getDownloadURL()).toString();
    } catch (e) {
      print(e.toString());
    }

    return profileUrl;
  }

  void getClientInfo(String clientId, dynamic element) {
    // if (clientData != null) return;

    dataBloc.getClientInfo(clientId, (client) async {
      client["profile_url"] = await getProfileImage(clientId);

      requests.add(
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => MyHomePage(
            //               data: element,
            //             )));
          },
          child: Container(
              child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            // color: Colors.pink,
            elevation: 10,
            margin: const EdgeInsets.all(15.0),
            child: Column(children: [
              Row(children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: element["profile"] != null
                      ? ClipOval(
                          child: FadeInImage.assetNetwork(
                            image: client["profile_url"],
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
                              client["name"] == null ? "Boss" : client["name"],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\$ ${element["price"]}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ]),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            element["phone"],
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
                        element["status"] == "accepted"
                            ? Expanded(
                                child: AppStyle.borderButton(context, "Decline",
                                    borderColor: Colors.red, onPressed: () {
                                onReject(element["data_id"],
                                    requestsData.indexOf(element));
                              }))
                            : Expanded(child: SizedBox(width: double.infinity)),
                        Expanded(
                            child: AppStyle.borderButton(context, "Message",
                                onPressed: () {
                          onChat(clientId, client["profile_url"]);
                        })),
                      ],
                    ),
                  ]),
                ),
              ]),
            ]),
          )),
        ),
      );

      setState(() {
        isLoading = false;
      });
    });
  }

  void refreshView() {
    requests = [];
    requestsData.forEach((element) {
      getClientInfo(element["client_id"], element);
    });
  }

  void onChat(String clientId, String clientAvatar) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  peerId: clientId,
                  peerAvatar: clientAvatar,
                )));
  }

  void onReject(final String requestID, final int index) {
    AppConfig.showAlertDialog(context, "Are you sure?", "", () {
      dataBloc.rejectOffer(requestID, () {
        getRequests();
        // requests.removeAt(index);
        // setState(() {});
      }, (error) {
        // AppConfig.showAlertDialog(context, "Order request error", "", () {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // setTag();
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.main,
          title: Text(
            "Requests",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: isLoading
              ? SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          index.isEven ? AppColors.main : AppColors.greyColor,
                    ),
                  );
                })
              : isEmpty
                  ? Center(child: AppStyle.label(context, "No data"))
                  : ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (BuildContext ctxt, int index) =>
                          requests[index]),
        ));
  }
}
