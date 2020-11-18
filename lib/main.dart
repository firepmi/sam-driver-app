import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sam_driver_app/ui/pages/account.dart';
import 'package:sam_driver_app/ui/pages/earnings.dart';
import 'package:sam_driver_app/ui/pages/earnings_details.dart';
import 'package:sam_driver_app/ui/pages/edit_profile.dart';
import 'package:sam_driver_app/ui/pages/intro.dart';
import 'package:sam_driver_app/ui/pages/login.dart';
import 'package:sam_driver_app/ui/pages/notifications.dart';
import 'package:sam_driver_app/ui/pages/privacy.dart';
import 'package:sam_driver_app/ui/pages/promotions.dart';
import 'package:sam_driver_app/ui/pages/recent_transactions.dart';
import 'package:sam_driver_app/ui/pages/register.dart';
import 'package:sam_driver_app/ui/pages/request_details.dart';
import 'package:sam_driver_app/ui/pages/select_car_size.dart';
import 'package:sam_driver_app/ui/pages/termsofservice.dart';
import 'package:sam_driver_app/ui/pages/welcome.dart';

import 'blocs/auth_bloc.dart';
import 'ui/pages/home.dart';
import 'ui/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
      AuthBloc(),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SAM Rider',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: './',
        routes: {
          '/home': (context) => MyHomePage(),
          '/': (context) => WelcomePage(),
          '/intro': (context) => IntroPage(),
          '/notifications': (context) => NotificationsPage(),
          '/earnings': (context) => EarningsPage(),
          '/earnings_details': (context) => EarningsDetailsPage(),
          '/recent_transactions': (context) => RecentTransactionsPage(),
          '/account': (context) => AccountPage(),
          '/edit_profile': (context) => EditProfilePage(),
          '/select_car_size': (context) => SelectCarSizePage(),
          '/promotions': (context) => PromotionsPage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => RegisterPage(),
          '/profile': (context) => ProfilePage(),
          '/privacy': (context) => PrivacyPage(),
          '/termsofservice': (context) => TermsOfServicePage(),
          '/request_details': (context) => RequestDetailsPage(),
        },
      )));
}

class MyApp extends InheritedWidget {
  final AuthBloc authBloc;
  final Widget child;
  MyApp(this.authBloc, this.child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static MyApp of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyApp>();
  }
}
