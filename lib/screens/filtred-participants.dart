import 'package:flutter/material.dart';
import 'package:gym/widgets/participant-item.dart';
import 'package:provider/provider.dart';
import '../providers/participant.dart';
import '../const.dart';

class FiltredParticipantScreen extends StatefulWidget {
  final height;
  FiltredParticipantScreen(this.height);
  @override
  _FiltredParticipantScreenState createState() =>
      _FiltredParticipantScreenState();
}

class _FiltredParticipantScreenState extends State<FiltredParticipantScreen> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final participantsM = Provider.of<Participants>(context);
    final height = widget.height;
    return Scaffold(
      backgroundColor: KmainColor,
      // appBar: appBar,
      body: SingleChildScrollView(
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
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: TextField(
                      onSubmitted: (v) {
                        participantsM.filter(v);
                      },
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
                        if (status != 200) showMsg('Une erreur est survenue');
                      },
                      child: ListView.builder(
                        itemBuilder: (ctx, i) {
                          final Participant participant =
                              participantsM.passedParticipants()[i];
                          return ParticipantItem(participant);
                        },
                        itemCount: participantsM.passedParticipants().length,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
