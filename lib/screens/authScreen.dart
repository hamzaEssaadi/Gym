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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.person,
                  size: 150,
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: 'hamza@test.com',
                        decoration: InputDecoration(hintText: 'Email'),
                        onSaved: (v) {
                          userData['email'] = v;
                        },
                      ),
                      TextFormField(
                        initialValue: '123456',
                        decoration: InputDecoration(hintText: 'Password'),
                        onSaved: (v) {
                          userData['password'] = v;
                        },
                      ),
                      istLoading
                          ? CircularProgressIndicator()
                          : FlatButton(
                              child: Text("Login"),
                              onPressed: _save,
                            )
                    ],
                  ),
                )
              ],
            ),
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
