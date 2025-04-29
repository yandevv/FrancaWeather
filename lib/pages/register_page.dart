import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:franca_weather/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  void _register() async {
    // Lógica de validação e cadastro aqui
    if(_name.isEmpty || _email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
      _showErrorDialog('Todos os campos são obrigatórios.');
    } else if(_password != _confirmPassword) {
      _showErrorDialog('As senhas não coincidem.');
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if(e.code == 'weak-password') {
          _showErrorDialog('A senha é muito fraca.');
        } else if(e.code == 'email-already-in-use') {
          _showErrorDialog('Já há uma conta com este email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro de cadastro'),
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
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
            ),
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
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _confirmPassword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}