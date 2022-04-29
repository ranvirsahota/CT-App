import 'package:flutter/material.dart';
import 'package:ct_app/services/auth.dart';
import 'package:ct_app/shared/fixed_styles.dart';

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
  String username = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textFormFieldDecoration.copyWith(hintText: "Choose a username"),
                validator: (val) => val!.isEmpty ? 'Must choose a username to register' : null,
                onChanged: (val) {
                  setState(() => username = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: textFormFieldDecoration.copyWith(hintText: "Choose a password"),
                validator: (val) => val!.isEmpty ? 'Must choose a password to register' : null,

                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  style: elevatedButtonStyle,
                  child: const Text(
                    'Register',
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      dynamic result = await _auth.registerWithEmailAndPassword(username, username+'@example.com', password);
                      if(result == null) {
                        setState(() {
                          error = 'could not create an account with current input';
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