import 'package:flutter/material.dart';
import 'package:gym/const.dart';
import 'package:gym/providers/participant.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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
  bool isLoading = false;
  Participant participant;

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
      participant =
          (ModalRoute.of(context).settings.arguments as Participant) == null
              ? Participant()
              : (ModalRoute.of(context).settings.arguments as Participant);
      if (participant.id != null) {
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
    final paraticipantsM = Provider.of<Participants>(context, listen: false);
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
                            initialValue: participant.name == null
                                ? null
                                : participant.name,
                            decoration:
                                kInputDecorationEdit('Le nom complete :'),
                            validator: (v) {
                              if (v.isEmpty)
                                return 'Veuillez entrer un nom';
                              else {
                                if (action == 'add') {
                                  if (paraticipantsM.isAlreadyExist(v)) {
                                    return 'Ce nom existe déjà';
                                  }
                                } else if (paraticipantsM.isAlreadyExist(
                                    v, participant.id)) {
                                  return 'Ce nom existe déjà';
                                }
                              }
                            },
                            onSaved: (v) {
                              participant = Participant(
                                  id: participant.id,
                                  name: v,
                                  dateBegin: participant.dateBegin,
                                  dateEnd: participant.dateEnd);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DateTimeField(
                            validator: (v) {
                              if (v.toString().isEmpty)
                                return 'Veuillez entrer la date de début';
                              else if (DateTime.tryParse(v.toString()) == null)
                                return 'Veuillez enter un valid date';
                            },
                            initialValue: participant.dateBegin == null
                                ? DateTime.now()
                                : participant.dateBegin,
                            decoration: kInputDecorationEdit("Date de début"),
                            format: DateFormat("yyyy-MM-dd"),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                            onSaved: (v) {
                              participant = Participant(
                                  id: participant.id,
                                  name: participant.name,
                                  dateBegin: v,
                                  dateEnd: participant.dateEnd);
                            },
                          ),
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
                              onSaved: (v) {
                                participant = Participant(
                                    id: participant.id,
                                    name: participant.name,
                                    dateBegin: participant.dateBegin,
                                    dateEnd: participant.dateBegin.add(
                                        Duration(days: selectedValue * 30)));
                              },
                              value: selectedValue,
                              decoration:
                                  kInputDecorationEdit('Le nombre des mois')),
                          SizedBox(
                            height: 10,
                          ),
                          isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.yellow,
                                  ),
                                )
                              : MaterialButton(
                                  onPressed: _save,
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

  void _save() async {
    final bool validate = form.currentState.validate();
    if (validate) {
      form.currentState.save();
      setState(() {
        isLoading = true;
      });
      if (action == 'add') {
        int status = await Provider.of<Participants>(context, listen: false)
            .add(participant);
        if (status == 200) {
          showMsg('le participant été ajouté avec success');
          Navigator.of(context).pop();
        } else {
          showMsg('Une erreur est survenue');
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
