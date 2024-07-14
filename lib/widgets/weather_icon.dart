import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({super.key, required this.code});
  final int code;
  @override
  Widget build(BuildContext context) {
    switch (code) {
      case >= 200 && <= 250:
        return Image.asset('assets/images/1.png');
      case >= 300 && <= 350:
        return Image.asset('assets/images/2.png');
      case >= 500 && <= 550:
        return Image.asset('assets/images/3.png');
      case >= 600 && <= 650:
        return Image.asset('assets/images/4.png');
      case >= 700 && <= 770 || == 781:
        return Image.asset('assets/images/5.png');
      case == 771:
        return Image.asset('assets/images/9.png');
      case == 800:
        return Image.asset('assets/images/6.png');
      case >= 801 && <= 810:
        return Image.asset('assets/images/8.png');
      default:
        return Image.asset('assets/images/7.png');
    }
  }
}
