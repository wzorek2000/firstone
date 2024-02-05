import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstone/content/mainPages/page1.dart';
import 'package:flutter/material.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _loading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() => _loading = true);
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContentScreen()),
        );
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message!);
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Wystąpił błąd'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logowanie'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        key: const ValueKey('emailField'),
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (input) =>
                            input!.contains('@') ? null : 'Błędny mail',
                        onSaved: (input) => _email = input!,
                      ),
                      TextFormField(
                        key: const ValueKey('passwordField'),
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (input) =>
                            input!.length < 6 ? 'Hasło jest za krótkie' : null,
                        onSaved: (input) => _password = input!,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        key: const ValueKey('loginButton'),
                        onPressed: _submit,
                        child: const Text('Zaloguj się'),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Nie masz konta? Zarejestruj się',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
