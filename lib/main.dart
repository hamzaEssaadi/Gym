import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym/const.dart';
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
          builder: (ctx) => Participants(),
        )
      ],
      child: MaterialApp(
        home: ParticipantsScreen(),
        theme: ThemeData(primaryColor: KmainColor, accentColor: KmainColor),
        routes: {
          EditParticipantScreen.routeName: (ctx) => EditParticipantScreen()
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('en', 'EN'), const Locale('fr', 'FR')],
      ),
    );
  }
}
