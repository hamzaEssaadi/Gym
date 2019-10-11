import 'package:flutter/material.dart';
import 'package:gym/const.dart';
import 'package:gym/providers/participant.dart';
import 'package:gym/screens/edit-participant-screen.dart';
import 'package:provider/provider.dart';

class ParticipantItem extends StatelessWidget {
  final Participant participant;
  var message;
  ParticipantItem(this.participant) {
    if (participant.nbDaysRest() >= 0)
      message =
          'il rest ${participant.nbDaysRest()} jour${participant.nbDaysRest() > 1 ? 's' : ''}';
    else
      message =
          'Il a passé ${participant.nbDaysRest().abs()}  jour${participant.nbDaysRest().abs() > 1 ? 's' : ''}';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Dismissible(
            direction: DismissDirection.endToStart,
            key: ValueKey(participant.id),
            onDismissed: (d) async {
              int status =
                  await Provider.of<Participants>(context, listen: false)
                      .delete(participant.id);
              if (status != 200)
                showMsg(errorMsg);
              else
                showMsg("le participant a été supprimé avec succès");
            },
            confirmDismiss: (d) {
              return showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: KmainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Text(
                    "Confirmation",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                      "voulez vous vraiment supprimer ce participant?",
                      style: TextStyle(color: Colors.white)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Non",
                        style: TextStyle(color: Colors.yellow),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Oui",
                        style: TextStyle(color: Colors.yellow),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ),
              );
            },
            background: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  )
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: KsecondColor,
                  boxShadow: [
                    BoxShadow(color: Colors.black38, blurRadius: 10)
                  ]),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text(
                  participant.name,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  message,
                  style: TextStyle(
                      color: participant.nbDaysRest() >= 0
                          ? Colors.white
                          : Colors.red,
                      fontStyle: FontStyle.italic),
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
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
