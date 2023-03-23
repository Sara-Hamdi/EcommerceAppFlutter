import 'package:finalproject/My_Profile.dart';
import 'package:finalproject/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password = '', userName = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Color.fromARGB(255, 109, 25, 19),
      ),
      body: Column(children: [
        Center(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      child: Image.asset(
                        "assets/Images/myProfile.png",
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (value) => userName = value,
                        decoration: InputDecoration(
                          hintText: 'example@gmail.com',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Please enter at least 6 characters';
                          }
                          return null;
                        },
                        onChanged: (value) => _password = value,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                final newUser =
                                    await _auth.signInWithEmailAndPassword(
                                        email: userName, password: _password);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => My_Profile()));
                              } catch (e) {
                                if (e.code == "user-not-found") {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text('This Email doesn not exist',
                                        style: TextStyle(fontSize: 15)),
                                    duration: Duration(seconds: 4),
                                    backgroundColor:
                                        Color.fromARGB(255, 109, 25, 19),
                                  ));
                                } else if (e.code == "wrong-password") {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text('Invaild Password',
                                        style: TextStyle(fontSize: 15)),
                                    duration: Duration(seconds: 4),
                                    backgroundColor:
                                        Color.fromARGB(255, 109, 25, 19),
                                  ));
                                }
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 109, 25, 19))),
                          child: Text("Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Sign_up()));
                            },
                            child: Text("Sign Up",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black)))
                      ],
                    )
                  ],
                ))),
      ]),
    ));
  }
}
