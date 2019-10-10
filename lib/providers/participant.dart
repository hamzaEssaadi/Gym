import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../const.dart';

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
    // Participant(
    //     id: 'aa152',
    //     name: 'hamza',
    //     dateBegin: DateTime.parse("2019-10-05"),
    //     dateEnd: DateTime.parse("2019-11-05")),
    // Participant(
    //     id: 'aa163',
    //     name: 'hassan',
    //     dateBegin: DateTime.parse("2019-10-09"),
    //     dateEnd: DateTime.parse("2020-02-09"))
  ];

  List<Participant> get items {
    return [..._items];
  }

  Future<int> fetchAndSet() async {
    var path = url + '/participants.json';
    try {
      var response = await http.get(path);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return 0;
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<Participant> loadedItems = [];
        data.forEach((k, v) {
          final item = v as Map<String, dynamic>;
          loadedItems.add(Participant(
              id: k,
              name: item['name'],
              dateBegin: DateTime.parse(item['dateBegin'].toString()),
              dateEnd: DateTime.parse(item['dateEnd'])));
        });
        _items = loadedItems;
        notifyListeners();
      }
      return response.statusCode;
    } catch (e) {
      print('error' + e.toString());
      return -1;
    }
  }

  bool isAlreadyExist(String name, [String id = null]) {
    if (id == null)
      return _items.any((test) => test.name == name);
    else
      return _items.any((test) => test.name == name && test.id != id);
  }

  Future<int> add(Participant participant) async {
    var path = url + '/participants.json';
    try {
      var response = await http.post(path,
          body: json.encode({
            'name': participant.name,
            'dateBegin': participant.dateBegin.toIso8601String(),
            'dateEnd': participant.dateEnd.toIso8601String()
          }));
      if (response.statusCode == 200) {
        final id = (json.decode(response.body) as Map<String, dynamic>)['name'];
        Participant newParticipant = Participant(
            name: participant.name,
            id: id,
            dateBegin: participant.dateBegin,
            dateEnd: participant.dateEnd);
        _items.add(newParticipant);
        notifyListeners();
      }
      print(response.body);
      return response.statusCode;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }
}
