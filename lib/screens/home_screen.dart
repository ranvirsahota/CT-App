import 'package:ct_app/screens/login_screen.dart';
import 'package:ct_app/screens/game_selection_screen.dart';
import 'package:ct_app/screens/settings_screen.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  List <Widget> screens = [
    LoginScreen(),
    GameSelectionScreen(),
    SettingScreen(),
  ];
  void _onPageChanged(int index) {
    setState(() { _selectedIndex = index; });
  }


  void _onItemTapped(int index) {
    setState(() { pageController.jumpToPage(index); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          children: screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login/Sign Up',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
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