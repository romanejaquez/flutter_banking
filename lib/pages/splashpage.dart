import 'package:flutter/material.dart';
import 'package:tab_sample/colors.dart';

class SplashPage extends StatelessWidget {
  int? duration = 0;
  String? goToPage;

  SplashPage({ this.goToPage, this.duration });

  @override 
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: this.duration!), () {
      Navigator.of(context).pushNamed(this.goToPage!);
    });

    return Scaffold(
      body: Container(
        color: AppColors.MAIN_RED,
        alignment: Alignment.center,
        child: Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: Stack(
            children: [
              SizedBox(width: 180, height: 180,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)
                )
              ),
              SizedBox(width: 180, height: 180,
              child: Icon(
                  BofaFont.BOFA_LOGO,
                  size: 150,
                  color: Colors.white
                )
              )
            ],
          ),
        ),
      )
    );
  }
}