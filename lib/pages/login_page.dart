import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:franca_weather/pages/register_page.dart';
import 'package:franca_weather/pages/weather_status.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  void _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WeatherStatusPage())
      );
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found') {
        _showErrorDialog('No user found for that email.');
      } else if(e.code == 'wrong-password') {
        _showErrorDialog('Wrong password provided for that user.');
      } else if(e.code == 'invalid-credential') {
        _showErrorDialog('Invalid credentials.');
      } else if(e.code == 'channel-error') {
        _showErrorDialog('An error ocurred when trying to login.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Franca Weather'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  ),
                  child: Text('Register')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}