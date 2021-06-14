import 'package:flutter/material.dart';
import 'package:subnetting_calculator/view/calculator_form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subnetting Calculator',
      home: CalculatorForm(),
    );
  }
}
