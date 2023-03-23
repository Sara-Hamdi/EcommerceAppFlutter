import 'package:finalproject/profileView.dart';
import 'package:finalproject/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finalproject/products.dart';
import 'cart.dart';

class My_Profile extends StatefulWidget {
  @override
  _My_profile createState() => _My_profile();
}

class _My_profile extends State<My_Profile> {
  int curIndex = 0;
  User signedUser;

  final List<Widget> screens = [products(), cart(), profileView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[curIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 109, 25, 19),
          currentIndex: curIndex,
          onTap: (index) => setState(() => curIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              label: "My Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: "Profile Setting",
            )
          ]),
    );
  }
}
