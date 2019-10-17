import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym/const.dart';
import 'package:gym/providers/auth.dart';
import 'package:gym/providers/participant.dart';
import 'package:gym/screens/authScreen.dart';
import 'package:gym/screens/participants-screen.dart';
import 'package:gym/screens/splash-screen.dart';
import 'package:provider/provider.dart';

import 'screens/edit-participant-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Participants>(
          builder: (ctx, auth, previewParticipants) =>
              Participants(token: auth.token),
        )
      ],
      child: MaterialApp(
        home: Consumer<Auth>(
          builder: (ctx, auth, child) {
            return auth.isAuth
                ? ParticipantsScreen()
                : FutureBuilder(
                    future: auth.tryToLogin(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return SpalshScreen();

                      if (snapshot.data == true) return ParticipantsScreen();
                      return AuthScreen();
                    },
                  );
          },
        ),
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: KmainColor,
          accentColor: KmainColor,
          //    canvasColor: Colors.yellow,
        ),
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
