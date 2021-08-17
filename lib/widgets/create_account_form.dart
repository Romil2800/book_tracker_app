import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/input_decoration.dart';
import 'package:flutter/material.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required TextEditingController emailTextController,
    @required TextEditingController passwordTextController,
  })  : _formKey = formKey,
        _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        Text('Please enter a valide email and password'),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            validator: (value) {
              return value.isEmpty ? 'Please add an email' : null;
            },
            controller: _emailTextController,
            decoration: buildInputDecoration('Enter email', 'john@me.com'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            validator: (value) {
              return value.isEmpty ? 'Please enter a password' : null;
            },
            controller: _passwordTextController,
            decoration: buildInputDecoration('Enter Password', 'John@123'),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Colors.amber,
            textStyle: TextStyle(fontSize: 18),
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              String email = _emailTextController.text;
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: email,
                password: _passwordTextController.text,
              )
                  .then((value) {
                if (value.user != null) {
                  String displayName = email.toString().split('@')[0];
                  createUser(displayName, context).then((value) {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    )
                        .then((value) {
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreenPage(),
                          ));
                    });
                  });
                }

                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: _emailTextController.text,
                  password: _passwordTextController.text,
                )
                    .then((value) {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreenPage(),
                      ));
                }).catchError((onError) {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Oops!'),
                          content: Text('${onError.message}'),
                        );
                      });
                });
              });
            }
          },
          child: Text('Create Account'),
        ),
      ]),
    );
  }

  Future<void> createUser(String displayName, BuildContext context) {
    final userCollectionReference =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid;

    Map<String, dynamic> user = {
      'display_name': displayName,
      'avatar_url': null,
      'profession': 'nope',
      'quote': 'Life is great',
      'uid': uid,
    };

    userCollectionReference.add(user);
  }
}
