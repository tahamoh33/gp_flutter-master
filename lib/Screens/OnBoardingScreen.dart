import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/Screens/Authentication/Login.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return OnBoardingSlider(
      finishButtonText: 'Get start',
      onFinish: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      finishButtonStyle: const FinishButtonStyle(
        // el finish button
        backgroundColor: Color(0xff1a74d7), // el sahm el taht
      ),

      // skipTextButton: const Text(
      //   'Skip',
      //   style: TextStyle(
      //     fontSize: 18,
      //     color: Colors.blueAccent, // el skip button
      //     fontWeight: FontWeight.w400,
      //   ),
      // ),

      controllerColor: Color(0xff1a74d7), // el no2at el taht
      totalPage: 2,
      headerBackgroundColor: Colors.white, // el app bar
      pageBackgroundColor: Colors.white,

      background: [
        Container(
          padding: EdgeInsets.only(left: width * 0.1),
          child: SizedBox(
            height: height * 0.4,
            width: width * 0.8,
            child: Image.asset(
              'lib/images/EyeLogo.png',
              fit: BoxFit.fill,
              height: height * 0.4,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: width * 0.1),
          child: SizedBox(
            height: height * 0.4,
            width: width * 0.8,
            child: Image.asset(
              'lib/images/EyeLogo.png',
              fit: BoxFit.fill,
              height: height * 0.4,
            ),
          ),
        ),
      ],
      speed: 3,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: height * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height * 0.5,
              ),
              AutoSizeText(
                'Disclaimer! This application does not provide medical advice.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
              ),
              SizedBox(height: height * 0.05),
              AutoSizeText(
                'No material is intended to be a substitute for professional medical service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: height * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height * 0.5,
              ),
              AutoSizeText(
                'Offers an additional insight.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              AutoSizeText(
                'This application was mainly designed to provide a new point of view as a way of coping with the rapid development of the Artificial intelligence field.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 6,
                stepGranularity: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
