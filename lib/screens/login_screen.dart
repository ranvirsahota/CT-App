import 'package:ct_app/screens/game_selection_screen.dart';
import 'package:ct_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  List <Widget> screens = [
    Center(child: Text('Login'),),
    GameSelectionScreen(),
    SettingScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: PageView (
        controller: pageController,
        children: screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
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