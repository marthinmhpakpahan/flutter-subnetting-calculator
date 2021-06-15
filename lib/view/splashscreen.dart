import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subnetting_calculator/view/calculator_form.dart';
 
class SplashScreen extends StatefulWidget{
  @override
  _SplashScreen createState() => _SplashScreen();
}
 
class _SplashScreen extends State<SplashScreen> {
  
  int showLine1 = 0;
  int showLine2 = 0;

  void initState(){
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        this.showLine1 = 1;
      });
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        this.showLine2 = 1;
      });
    });
    startSplashScreen();
  }
 
  startSplashScreen () async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CalculatorForm()),
      );
    });
  }
 
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.calculate,
              size: 100.0,
              color: Colors.white,
            ),
            SizedBox(height: 24.0),
            Column(children: [
              this.showLine1 == 1 ?_showTextLine1() : Text(""),
              this.showLine2 == 1 ?_showTextLine2() : Text(""),
            ],)
          ],
        ),
      ),
    );
  }

  _showTextLine1() {
    return Text(
      "SUBNETTING",
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
  _showTextLine2() {
    return Text(
      "CALCULATOR",
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}