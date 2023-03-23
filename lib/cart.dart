import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class cart extends StatefulWidget {
  cart({Key key}) : super(key: key);

  @override
  _cart createState() => _cart();
}

class _cart extends State<cart> {
  final notesref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('cart');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        backgroundColor: Color.fromARGB(255, 109, 25, 19),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: notesref
              .where("email",
                  isEqualTo: FirebaseAuth.instance.currentUser?.photoURL)
              .get(),
          builder: (context, snapshot) {
            Center(child: CircularProgressIndicator());

            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(5),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, i) {
                  notesref.doc(snapshot.data?.docs[i].id);
                  return Dismissible(
                    onDismissed: (diretion) async {
                      notesref.doc(snapshot.data?.docs[i].id);

                      FirebaseStorage.instance
                          .refFromURL(snapshot.data?.docs[i]['imgeurl']);
                    },
                    key: UniqueKey(),
                    child: add(
                      notes: snapshot.data?.docs[i],
                    ),
                  );
                },
              );
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class add extends StatefulWidget {
  const add({
    this.title,
    this.imgeurl,
    this.notes,
    this.price,
    Key key,
    QueryDocumentSnapshot<Object> nots,
    String docid,
  }) : super(key: key);
  final String title;

  final String imgeurl;
  final String price;

  final notes;

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  final _auth = FirebaseAuth.instance.currentUser.uid;
  var vis = true;
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: vis,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 3),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3.0,
                  blurRadius: 5.0,
                )
              ],
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Image.asset(
                  "${widget.notes['imgeurl']}",
                  width: 100,
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  '${widget.notes["price"]} \$',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '${widget.notes["title"]}',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ]),
              ElevatedButton(
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection("cart")
                        .where("imgeurl", isEqualTo: widget.notes['imgeurl'])
                        .get()
                        .then((value) {
                      value.docs.forEach((element) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection("cart")
                            .doc(element.id)
                            .delete();
                      });
                    });
                    setState(() {
                      vis = false;
                    });
                  },
                  child: Text("Delete"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 109, 25, 19))))
            ],
          ),
        ));
  }
}
