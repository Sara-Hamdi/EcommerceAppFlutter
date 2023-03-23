import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profileView extends StatefulWidget {
  @override
  _profileView createState() => _profileView();
}

class _profileView extends State<profileView> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String phone;
  String password = "";
  String _email;
  String _userName;
  @override
  User signedUser;
  void initState() {
    super.initState();
    _email = _auth.currentUser.email;
    _userName = _auth.currentUser.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("welcome " + _userName),
        backgroundColor: Color.fromARGB(255, 109, 25, 19),
      ),
      key: _scaffoldKey,
      body: Column(children: [
        Image.asset(
          "assets/Images/prof.png",
          width: 150,
          alignment: Alignment.centerLeft,
        ),
        Center(
          child: Form(
              child: Column(
            children: [
              Container(
                width: 300,
                padding: EdgeInsets.only(top: 20),
                child: Text("Update Your Profile Info :",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) => _userName = value,
                          decoration: InputDecoration(
                            hintText: 'Enter the new username',
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                            onChanged: (value) => _email = value,
                            decoration: InputDecoration(
                              hintText: 'Enter the New Email',
                            )),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            obscureText: true,
                            onChanged: (value) => password = value,
                            decoration: InputDecoration(
                              hintText: 'Enter the New Password',
                            )),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (_email.isNotEmpty)
                                  final updatedUser = await _auth.currentUser
                                      .updateEmail(_email);
                                if (password != "") {
                                  final updatedPassword = await _auth
                                      .currentUser
                                      .updatePassword(password);
                                }

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_auth.currentUser.uid)
                                    .set({
                                  'password': password,
                                  'email': _email,
                                  'userName': _userName
                                });
                                if (_userName.isNotEmpty)
                                  await _auth.currentUser
                                      .updateDisplayName(_userName);
                                await _auth.currentUser.reload();
                                setState(() {
                                  _userName = _userName;
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'the profile is updated successfully!',
                                      style: TextStyle(fontSize: 15)),
                                  duration: Duration(seconds: 4),
                                  backgroundColor:
                                      Color.fromARGB(255, 91, 88, 88),
                                ));
                              } catch (e) {
                                if (e.code == "email-already-in-use") {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'This Email Already Exists,Try choose another one!',
                                        style: TextStyle(fontSize: 15)),
                                    duration: Duration(seconds: 4),
                                    backgroundColor:
                                        Color.fromARGB(255, 91, 88, 88),
                                  ));
                                }
                              }
                            },
                            child: Text("Save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 109, 25, 19))),
                          )),
                    ],
                  ))
            ],
          )),
        ),
      ]),
    );
  }
}
