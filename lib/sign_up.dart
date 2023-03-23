import 'package:finalproject/Login.dart';
import 'package:finalproject/My_Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sign_up extends StatefulWidget {
  @override
  _Sign_up createState() => _Sign_up();
}

class _Sign_up extends State<Sign_up> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  String _password = '', _userNamee = '', _email = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Sign Up",
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
                      onChanged: (value) => _userNamee = value,
                      decoration: InputDecoration(
                        hintText: 'username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onChanged: (value) => _email = value,
                      decoration: InputDecoration(
                        hintText: 'example@gmail.com',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Please enter at least 6 characters';
                        }
                        return null;
                      },
                      onChanged: (value) => _password = value,
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
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _email, password: _password);
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(newUser.user.uid).set
                                  ({
                                'userName': _userNamee,
                                'password': _password,
                                'email': _email
                              });
                              await _auth.currentUser
                                  .updateDisplayName(_userNamee);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => My_Profile()));
                            } catch (e) {
                              if (e.code == "email-already-in-use") {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('This Email Already Exists!',
                                      style: TextStyle(fontSize: 15)),
                                  duration: Duration(seconds: 4),
                                  backgroundColor:
                                      Color.fromARGB(255, 109, 25, 19),
                                ));
                              }
                            }
                          }
                        },
                        child: Text("Sign Up",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 109, 25, 19))),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text("Login",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)))
                    ],
                  )
                ],
              )),
        ),
      ]),
    );
  }
}
