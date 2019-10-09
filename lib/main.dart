import 'package:flutter/material.dart';
import 'package:gym/providers/participant.dart';
import 'package:gym/screens/participants-screen.dart';
import 'package:provider/provider.dart';

import 'screens/edit-participant-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (ctx) => Participans(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            textTheme: TextTheme(
          headline: TextStyle(color: Colors.white),
          title: TextStyle(color: Colors.white),
          body1: TextStyle(color: Colors.white),
        )),
        home: ParticipantsScreen(),
        routes: {
          EditParticipantScreen.routeName: (ctx) => EditParticipantScreen()
        },
      ),
    );
  }
}