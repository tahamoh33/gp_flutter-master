import 'package:flutter/material.dart';
import 'package:trial1/CustomWidgets/custom_button.dart';

class doctor extends StatefulWidget {
  const doctor({super.key});

  @override
  State<doctor> createState() => _doctorState();
}

class _doctorState extends State<doctor> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,


      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0,bottom: 30,right: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.asset("lib/images/wallpaper.jpeg",

                  height: 82,
                  width: 82,
                ),
              ),
              SizedBox(height: 20,),
              Text("Hello, DR Taha",style:
                TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),),
              SizedBox(height: 20,),
              Container(
                height: 80,
                width: 306,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back !",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Take A Deep Breath And Let's Discover Your Eye Disease",
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 188,
                height: 22,
                child: Text(
                  "What Do You Need?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 195,
                  height: 228.378,
                  child: InkWell(
                    child: Image.asset("lib/images/DrScreen.png"),

                  ),
                ),
              ),
              Container(
                height: 125,
                width: 306,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "View Predictions function helps Us keep track of the Detection results and the Accuracy of the model Predictions which helps us to modify the application to reach higher accuracy.",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "thank you for helping us !",
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Center(child: CustomButton(label: "View Predictions", onPressed: (){}))
//bos keda
              //View Predictions function helps Us keep track of the Detection results and the Accuracy of the model Predictions which helps us to modify the application to reach higher accuracy.
              //
              // thank you for helping us !
            ],
          ),
        ),
      ),
    );
  }
}