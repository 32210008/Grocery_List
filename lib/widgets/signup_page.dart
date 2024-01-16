import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String baseUrl =
      'https://user-account-d6d2a-default-rtdb.firebaseio.com/users.json';

  bool _isPasswordObscured = true;
  String? _nameErrorText;
  String? _emailErrorText;
  String? _passwordErrorText;

  void _signUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _nameErrorText =
            _nameController.text.isEmpty ? 'Please enter your name.' : null;
        _emailErrorText =
            _emailController.text.isEmpty ? 'Please enter your email.' : null;
        _passwordErrorText = _passwordController.text.isEmpty
            ? 'Please enter your password.'
            : null;
      });
      return;
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Sign up success!');

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print('Sign up failed. Status code: ${response.statusCode}');
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 48.0,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _nameErrorText,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailErrorText,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordErrorText,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                  icon: Icon(
                    _isPasswordObscured
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
              obscureText: _isPasswordObscured,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _goToLogin,
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
