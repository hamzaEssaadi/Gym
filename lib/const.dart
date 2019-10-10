import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const Color KmainColor = Color(0xff8d6ad4);
const Color KsecondColor = Color(0xff513d7a);

InputDecoration kInputSearch = InputDecoration(
  hintStyle: TextStyle(color: Colors.white),
  hintText: "Recherche",
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
);

InputDecoration kInputDecoration(txt) {
  return InputDecoration(
    hintStyle: TextStyle(color: Colors.white),
    hintText: txt,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    prefixStyle: TextStyle(color: Colors.white),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

InputDecoration kInputDecorationEdit(txt) {
  return InputDecoration(
    hintStyle: TextStyle(color: Colors.black),
    hintText: txt,
    fillColor: Colors.white.withOpacity(0.3),
    filled: true,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    prefixStyle: TextStyle(color: Colors.white),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

const url = 'https://gym-ba9b1.firebaseio.com/';

void showMsg(txt) {
  Fluttertoast.showToast(
      msg: txt, gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_SHORT);
}
