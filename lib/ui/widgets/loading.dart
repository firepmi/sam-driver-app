import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sam_driver_app/util/utils.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.themeColor),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}