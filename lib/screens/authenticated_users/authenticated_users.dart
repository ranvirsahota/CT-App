import 'package:ct_app/screens/authenticated_users/game_selection.dart';
import 'package:ct_app/screens/authenticated_users/settings.dart';
import 'package:ct_app/services/auth.dart';

import 'package:flutter/material.dart';

class AuthenticatedUsers extends StatefulWidget {
  const AuthenticatedUsers({Key? key}) : super(key: key);

  @override
  _AuthenticatedUsersState createState() => _AuthenticatedUsersState();
}
class _AuthenticatedUsersState extends State<AuthenticatedUsers> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  List <Widget> screens = [
    const GameSelection(),
    const MSettings()
  ];
  void _onPageChanged(int index) {
    setState(() { _selectedIndex = index; });
  }


  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) { AuthService().signOut();}
      else {
        pageController.jumpToPage(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: PageView(
          controller: pageController,
          children: screens,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        )
    );
  }
}