import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const Color KmainColor = Color(0xff8d6ad4);
const Color KsecondColor = Color(0xff513d7a);
const apiKey = "AIzaSyA6YaPQX5gauSRNFMEyvX3Ck91xgxfq7Ic";

const errorMsg = "Une erreur est survenue";
InputDecoration kInputSearch = InputDecoration(
  hintStyle: TextStyle(color: Colors.white),
  hintText: "Recherche",
  alignLabelWithHint: true,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.white, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.white, width: 2),
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

InputDecoration kInputDecorationEdit(txt, [String type = null]) {
  return InputDecoration(
    hintStyle: TextStyle(color: Colors.white),
    // suffixIcon: Icon(
    //   Icons.expand_more,
    //   color: Colors.white,
    // ),
    /* suffixIcon: type != null
        ? Icon(
            Icons.expand_more,
            color: Colors.white,
          )
        : null,*/
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    // contentPadding: EdgeInsets.all(15),
    hintText: txt,
    //  fillColor: Colors.white.withOpacity(0.2),
    // filled: true,
    //focusedBorder: OutlineInputBorder(
    //  borderSide: BorderSide(color: Colors.white),
    //  ),
    prefixStyle: TextStyle(color: Colors.white),
    // enabledBorder: OutlineInputBorder(
    //  borderSide: BorderSide(color: Colors.white),
    // ),
  );
}

const url = 'https://gym-ba9b1.firebaseio.com/';

void showMsg(txt) {
  Fluttertoast.showToast(
      msg: txt, gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_SHORT);
}
