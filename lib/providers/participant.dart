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
  final String token;

  Participants({@required this.token});

  List<Participant> get items {
    return [..._items];
  }

  Future<int> fetchAndSet() async {
    var path = url + '/participants.json?auth=$token';
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
      } else
        print(response.body);
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
    var path = url + '/participants.json?auth=$token';
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

      return response.statusCode;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future<int> edit(Participant participant) async {
    final path = url + 'participants/${participant.id}.json?auth=$token';
    final response = await http.patch(path,
        body: jsonEncode({
          'name': participant.name,
          'dateBegin': participant.dateBegin.toIso8601String(),
          'dateEnd': participant.dateEnd.toIso8601String()
        }));

    if (response.body.isEmpty) return 0;
    try {
      if (response.statusCode == 200) {
        _items[_items.indexWhere((test) => test.id == participant.id)] =
            participant;
        notifyListeners();
      } else
        print(response.body);
      return response.statusCode;
    } catch (e) {
      print(e.toString());
      return 1;
    }
  }

  Future<int> delete(String id) async {
    var participant = _items.firstWhere((test) => test.id == id);
    _items.removeWhere((test) => test.id == id);
    notifyListeners();
    try {
      final path = url + 'participants/${participant.id}.json?auth=$token';
      var response = await http.delete(path);
      if (response.statusCode != 200) {
        _items.add(participant);
        notifyListeners();
      }
      return response.statusCode;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  void filter(String txt) async {
    await fetchAndSet();
    _items = _items
        .where((test) => test.name.toLowerCase().contains(txt.toLowerCase()))
        .toList();
    notifyListeners();
  }

  List<Participant> passedParticipants() {
    return _items.where((test) => test.nbDaysRest() <= 0).toList();
  }
}
