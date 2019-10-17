import 'package:flutter/material.dart';
import 'package:gym/const.dart';
import 'package:gym/providers/auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool istLoading = false;
  Map<String, String> userData = {'email': '', 'password': ''};

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: height * 0.40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/top-image.png'),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                      height: height * 0.6,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('images/bottom.png'))))
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 40)],
                    color: Colors.white),
                height: height * 0.4,
                width: 300,
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 25),
                            child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (v) {
                                  userData['email'] = v;
                                },
                                validator: (v) {
                                  if (v.isEmpty)
                                    return 'Entrez une adresse mail s\'il vous plaît';
                                },
                                decoration: kInputDecorationLogin(
                                    'Email',
                                    Icon(
                                      Icons.email,
                                      color: KsecondColor,
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              onSaved: (v) {
                                userData['password'] = v;
                              },
                              obscureText: true,
                              validator: (v) {
                                if (v.isEmpty)
                                  return 'Veuillez entrer un mot de passe';
                              },
                              decoration: kInputDecorationLogin(
                                  'Mot de passe',
                                  Icon(
                                    Icons.lock,
                                    color: KsecondColor,
                                  )),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffa3c9e2), Color(0xff8d6ad4)]),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        child: MaterialButton(
                          height: 45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          onPressed: _save,
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          //   color: Colors.blue,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    final validate = _form.currentState.validate();
    if (validate) {
      _form.currentState.save();

      try {
        setState(() {
          istLoading = true;
        });
        int status = await Provider.of<Auth>(context, listen: false)
            .authenticate(userData);
        if (status != 200) {
          showMsg("les informations d'identification invalides");
        }
      } catch (e) {} finally {
        setState(() {
          istLoading = false;
        });
      }
    }
  }
}
