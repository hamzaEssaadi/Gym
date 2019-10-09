import 'package:flutter/material.dart';
import 'package:gym/const.dart';
import 'package:gym/providers/participant.dart';
import 'package:gym/screens/edit-participant-screen.dart';

class ParticipantItem extends StatelessWidget {
  final Participant participant;
  ParticipantItem(this.participant);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: KsecondColor,
                boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)]),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              title: Text(
                participant.name,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'il rest ${participant.nbDaysRest()} jour${participant.nbDaysRest() > 1 ? 's' : ''}',
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      EditParticipantScreen.routeName,
                      arguments: participant);
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
