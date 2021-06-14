import 'package:firebase_auth_project/Setup/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  String? _email;
  String? _password;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Column(
          children: [
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Please type an email';
                        }
                      },
                      onSaved: (input) => _email = input,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input!.length < 3) {
                          return 'Please type a valid password';
                        }
                      },
                      onSaved: (input) => _password = input,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    TextButton(onPressed: signIn, child: Text('Sign In'))
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => singUp()));
                },
                child: Text('signup'))
          ],
        ));
  }

  Future<void> signIn() async {
    print('start');
    final _formState = _formkey.currentState;
    if (_formState!.validate()) {
      _formState.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _email.toString(), password: _password.toString());
        print(userCredential.user);
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'user-not-found') {
          print('no user found fpr that email');
        } else if (e.code == 'wrong password') {
          print('Wrong password');
        }
      }
    }
    ;
  }
}
