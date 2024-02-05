import 'package:flutter/material.dart';
import 'charts/seven_days_chart.dart';
import 'charts/year_chart.dart';
import 'charts/input_number_chart.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text('Twój wykres samopoczucia z 7 ostatnich dni:',
                textAlign: TextAlign.center),
            SevenDaysChart(),
            SizedBox(height: 20),
            Text('Twój wykres samopoczucia z ostatnich 6 miesięcy:',
                textAlign: TextAlign.center),
            YearChart(),
            SizedBox(height: 20),
            Text('Liczba utworzonych przez ciebie wpisów w aplikacji:',
                textAlign: TextAlign.center),
            InputNumberChart(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
