import 'package:ct_app/services/auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary:Colors.pink,
        textStyle: const TextStyle(color:Colors.white, fontSize: 20)
    );
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                validator: (val) => val!.length < 4 ? 'Enter a password at least 4 chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  style: style,
                  child: const Text(
                    'Register',
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if(result == null) {
                        setState(() {
                          error = 'Please supply a valid email';
                        });
                      }
                    }
                  }
              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}