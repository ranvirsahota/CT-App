import 'package:flutter/material.dart';
import 'package:ct_app/shared/fixed_styles.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textFormFieldDecoration.copyWith(hintText: "Enter your username"),
                validator: (val) => val!.isEmpty ? 'To sign in you must enter your username' : null,
                onChanged: (val) {
                  setState(() => username = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textFormFieldDecoration.copyWith(hintText: "Enter your password"),

                obscureText: true,
                validator: (val) => val!.isEmpty ? 'To sign in your must enter your password' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  style: elevatedButtonStyle,
                  child: const Text('Sign In'),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      dynamic result = await _auth.signInWithEmailAndPassword(username+'@example.com', password);
                      if(result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    }
                  }
              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}