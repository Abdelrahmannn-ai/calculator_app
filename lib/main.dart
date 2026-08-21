import 'dart:io';

import 'package:calculator_app/calculator.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CalculatorHomeScreen(),
  ));
}
