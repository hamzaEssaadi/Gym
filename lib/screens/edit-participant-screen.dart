import 'package:flutter/material.dart';
import 'package:gym/const.dart';
import 'package:gym/providers/participant.dart';

class EditParticipantScreen extends StatefulWidget {
  static const routeName = "/edit-participant";

  @override
  _EditParticipantScreenState createState() => _EditParticipantScreenState();
}

class _EditParticipantScreenState extends State<EditParticipantScreen> {
  var isInit = false;
  var action = 'add';
  final form = GlobalKey<FormState>();
  var appBar;

  Participant participant = null;

  List<DropdownMenuItem> months() {
    List<DropdownMenuItem> months = [];
    for (int i = 1; i <= 12; i++) {
      months.add(DropdownMenuItem(
        child: Text(
          "$i moi${i > 1 ? 's' : ''}",
        ),
        value: i,
      ));
    }
    return months;
  }

  @override
  void didChangeDependencies() {
    if (isInit == false) {
      participant = ModalRoute.of(context).settings.arguments as Participant;
      if (participant != null) {
        action = 'edit';
        selectedValue = participant.nbMonths();
      }

      appBar = AppBar(
        title: Text(action != 'add'
            ? 'Mettre à jour un abonnement'
            : 'Ajouter un participant'),
        backgroundColor: KsecondColor,
      );
    }
    isInit = true;
    super.didChangeDependencies();
  }

  var selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;
    return Scaffold(
      backgroundColor: KmainColor,
      appBar: appBar,
      body: Container(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: KsecondColor,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50))),
                width: double.infinity,
                height: height * 0.3,
                child: Icon(
                  Icons.date_range,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              Container(
                height: height * 0.7,
                child: Form(
                    key: form,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 60),
                      height: height,
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                              initialValue:
                                  participant == null ? null : participant.name,
                              decoration:
                                  kInputDecorationEdit('Le nom complete :')),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                              items: months(),
                              onChanged: (v) {
                                setState(() {
                                  selectedValue = v;
                                });
                              },
                              value: selectedValue,
                              decoration:
                                  kInputDecorationEdit('Le nombre des mois')),
                          SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            onPressed: () {},
                            child: Text(
                              "Enregistrer",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: KsecondColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
