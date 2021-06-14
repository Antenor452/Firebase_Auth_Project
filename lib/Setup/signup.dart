import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class singUp extends StatefulWidget {
  const singUp({Key? key}) : super(key: key);

  @override
  _singUpState createState() => _singUpState();
}

class _singUpState extends State<singUp> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  String? _email;
  String? _password;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Please enter a valid email';
                    }
                  },
                  onSaved: (input) {
                    _email = input;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (input) {
                    if (input!.length < 6) {
                      return 'Please enter a valid password';
                    }
                  },
                  obscureText: true,
                  onSaved: (input) {
                    _password = input;
                  },
                ),
                TextButton(onPressed: SignUp, child: Text('Register'))
              ],
            )),
      ),
    );
  }

  Future<void> SignUp() async {
    FormState? formstate = _formkey.currentState;
    if (formstate!.validate()) {
      formstate.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.toString(), password: _password.toString());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('Enter a strogn password');
        } else if (e.code == 'email-already-in-use') {
          print('Email exists');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
