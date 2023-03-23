import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'Login.dart';
import 'sign_up.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 109, 25, 19),
          leading: Icon(
            Icons.shopping_bag_sharp,
            size: 40,
          ),
          title: Text(
            "Shoppy",
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: Center(
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Image.asset(
                'assets/Images/enter.png',
                width: 300,
              ),
            ),
            AnimatedTextKit(
                totalRepeatCount: 10000,
                repeatForever: true,
                animatedTexts: [
                  TyperAnimatedText(
                    "Welcome to Shoppy !",
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  TyperAnimatedText(
                    "Start Shopping With Us... ",
                    textStyle: TextStyle(fontSize: 20),
                  )
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Sign_up()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      color: Color.fromARGB(255, 109, 25, 19),
                      minWidth: 100,
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      color: Color.fromARGB(255, 109, 25, 19),
                      minWidth: 100,
                    )),
              ],
            )
          ]),
        ));
  }
}
