import 'package:flutter/material.dart';
import 'package:gym/const.dart';

class SpalshScreen extends StatelessWidget {
  const SpalshScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KmainColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
