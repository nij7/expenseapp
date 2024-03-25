// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:trackexx/theme/color.dart';

double mainMargin = 18;
double subMargin = 14;

double buttonRadius = 8;
double mainMarginHalf = 9;

class AppTitle extends StatelessWidget {
  String title;
  AppTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: black),
    );
  }
}
