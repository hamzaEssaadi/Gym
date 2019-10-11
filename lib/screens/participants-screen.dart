import 'package:flutter/material.dart';
import 'package:gym/const.dart';
import 'package:gym/providers/participant.dart';
import 'package:gym/screens/edit-participant-screen.dart';
import 'package:gym/screens/filtred-participants.dart';
import 'package:gym/widgets/participant-item.dart';
import 'package:provider/provider.dart';

class ParticipantsScreen extends StatefulWidget {
  @override
  _ParticipantsScreenState createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  var isInit = false;
  var isLoading = false;
  @override
  void didChangeDependencies() async {
    if (isInit == false) {
      isLoading = true;
      setState(() {});
      int status =
          await Provider.of<Participants>(context, listen: false).fetchAndSet();
      if (status != 200) showMsg('Une erreur est survenue');
      setState(() {
        isLoading = false;
      });
    }
    isInit = true;
    super.didChangeDependencies();
  }

  AppBar appBarr() => AppBar(
        backgroundColor: KsecondColor,
        title: Text("Les participants"),
        bottom: TabBar(
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: "Tous les participants",
            ),
            Tab(
              text: "Qui a un abonnement terminé",
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) {
              var list = List<PopupMenuEntry<String>>();
              list.add(PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add),
                    Text(" Ajouter un participant"),
                  ],
                ),
                value: 'add',
              ));
              list.add(PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    Text(" Logout"),
                  ],
                ),
                value: 'logout',
              ));
              return list;
            },
            onSelected: (v) {
              if (v == 'add') {
                Navigator.of(context)
                    .pushNamed(EditParticipantScreen.routeName);
              }
            },
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    var appBar = appBarr();
    final participantsM = Provider.of<Participants>(context);
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: KmainColor,
        appBar: appBar,
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.yellow,
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Container(
                          height: height * 0.1,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: TextField(
                            decoration: kInputSearch,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: height * 0.9,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              int status = await participantsM.fetchAndSet();
                              if (status != 200)
                                showMsg('Une erreur est survenue');
                            },
                            child: ListView.builder(
                              itemBuilder: (ctx, i) {
                                final Participant participant =
                                    participantsM.items[i];
                                return ParticipantItem(participant);
                              },
                              itemCount: participantsM.items.length,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
            FiltredParticipantScreen()
          ],
        ),
      ),
    );
  }
}
