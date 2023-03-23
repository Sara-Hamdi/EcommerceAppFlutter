import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/My_Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class products extends StatefulWidget {
  products({Key key}) : super(key: key);

  @override
  _productsState createState() => _productsState();
}

class _productsState extends State<products> {
  CollectionReference notesref =
      FirebaseFirestore.instance.collection("products");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("products"),
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
              return GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i) {
                  notesref.doc(snapshot.data.docs[i].id);
                  return Dismissible(
                    onDismissed: (diretion) async {
                      notesref.doc(snapshot.data.docs[i].id);

                      FirebaseStorage.instance
                          .refFromURL(snapshot.data.docs[i]['imgeurl']);
                    },
                    key: UniqueKey(),
                    child: add(
                      notes: snapshot.data.docs[i],
                    ),
                  );
                },
              );
            }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => _detail(widget.notes['imgeurl'],
                      widget.notes['title'], widget.notes['price'])));
        },
        child: Container(
          padding: EdgeInsets.all(10),
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
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  "${widget.notes['imgeurl']}",
                  height: 100,
                ),
              ),
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
            ],
          ),
        ));
  }
}

class _detail extends StatelessWidget {
  String title;
  int price;
  String img;
 
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _detail(this.img, this.title, this.price);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 109, 25, 19),
            title: Text("Back")),
        body: Column(children: [
          Center(
              child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                          width: 200,
                          child: Image.asset(
                            "${img}",
                          )),
                      Text("${price} \$",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      Text(title,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .collection('cart')
                                    .doc()
                                    .set({
                                  'imgeurl': img,
                                  'title': title,
                                  'price': price
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'the item has been added to the cart succesfully',
                                      style: TextStyle(fontSize: 15)),
                                  duration: Duration(seconds: 4),
                                  backgroundColor:
                                      Color.fromARGB(255, 109, 25, 19),
                                ));
                              },
                              child: Text("Add to cart"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 109, 25, 19))))
                        ],
                      )
                    ],
                  )))
        ]));
  }
}
