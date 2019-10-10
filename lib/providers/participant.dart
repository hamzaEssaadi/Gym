import 'package:flutter/material.dart';

class Participant {
  final String id;
  final String name;
  final DateTime dateEnd;
  final DateTime dateBegin;
  Participant({this.id, this.name, this.dateBegin, this.dateEnd});

  int nbDaysRest() {
    return dateEnd.difference(DateTime.now()).inDays;
  }

  int nbMonths() {
    return dateBegin.difference(dateEnd).inDays.abs() ~/ 30;
  }
}

class Participants with ChangeNotifier {
  List<Participant> _items = [
    Participant(
        id: 'aa152',
        name: 'hamza',
        dateBegin: DateTime.parse("2019-10-05"),
        dateEnd: DateTime.parse("2019-11-05")),
    Participant(
        id: 'aa163',
        name: 'hassan',
        dateBegin: DateTime.parse("2019-10-09"),
        dateEnd: DateTime.parse("2020-02-09"))
  ];

  List<Participant> get items {
    return [..._items];
  }

  bool isAlreadyExist(String name) {
    return _items.any((test) => test.name == name);
  }

  void add(Participant participant) {
    _items.add(participant);
    notifyListeners();
  }
}
