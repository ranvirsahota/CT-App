import 'package:ct_app/models/custom_user.dart';
import 'package:ct_app/screens/authenticate/authenticate.dart';
import 'package:ct_app/screens/authenticated_users/authenticated_users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    if (user == null) {
      return const Authenticate();
    }
    else {
      return const AuthenticatedUsers();
    }
  }
}