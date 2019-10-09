import 'package:flutter/material.dart';

class Participant {
  final String name;
  //final DateTime dateBegin;
  final DateTime dateEnd;
  final DateTime dateBegin;
  Participant(
      {@required this.name, @required this.dateBegin, @required this.dateEnd});

  int nbDaysRest() {
    return dateEnd.difference(DateTime.now()).inDays;
  }

  int nbMonths() {
    return dateBegin.difference(dateEnd).inDays.abs() ~/ 30;
  }
}

class Participans with ChangeNotifier {
  List<Participant> _items = [
    Participant(
        name: 'hamza',
        dateBegin: DateTime.parse("2019-10-05"),
        dateEnd: DateTime.parse("2019-11-05")),
    Participant(
        name: 'hassan',
        dateBegin: DateTime.parse("2019-10-09"),
        dateEnd: DateTime.parse("2020-02-09"))
  ];

  List<Participant> get items {
    return [..._items];
  }
}
