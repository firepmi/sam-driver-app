import 'package:flutter/material.dart';

import 'ui/account.dart';
import 'ui/earnings.dart';
import 'ui/earnings_details.dart';
import 'ui/home.dart';
import 'ui/notifications.dart';
import 'ui/profile.dart';
import 'ui/promotions.dart';
import 'ui/recent_transactions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uber Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Uber Clone'),
        '/notifications': (context) => NotificationsPage(),
        '/earnings': (context) => EarningsPage(),
        '/profile': (context) => ProfilePage(),
        '/earnings_details': (context) => EarningsDetailsPage(),
        '/recent_transations': (context) => RecentTransactionsPage(),
        '/promotions': (context) => PromotionsPage(),
        '/account': (context) => AccountPage(),
      },
    );
  }
}
