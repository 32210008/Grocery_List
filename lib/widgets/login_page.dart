import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  var _isLoggingIn = false;
  final IconData lockIcon = Icons.lock_person_outlined;
  bool _isPasswordObscured = true;
  String? _emailErrorText;
  String? _passwordErrorText;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoggingIn = true;
        _emailErrorText = null;
        _passwordErrorText = null;
      });

      final url = Uri.https(
          'user-account-d6d2a-default-rtdb.firebaseio.com', 'users.json');

      try {
        final response = await http.get(url);
        final usersData = json.decode(response.body) as Map<String, dynamic>?;

        if (usersData != null) {
          final matchedUser = usersData.values.firstWhere(
            (userData) =>
                userData['email'] == _email &&
                userData['password'] == _password,
            orElse: () => null,
          );

          if (matchedUser != null) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            setState(() {
              _passwordErrorText = 'Invalid email or password.';
            });
          }
        }
      } catch (error) {
        print('Error: $error');
      }

      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  void _goToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              lockIcon,
              size: 48.0,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: Text('Email'),
                      errorText: _emailErrorText,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    obscureText: _isPasswordObscured,
                    decoration: InputDecoration(
                      label: Text('Password'),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _isLoggingIn ? null : _login,
                    child: _isLoggingIn
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Login'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _goToSignUp,
                    child: const Text('Create account'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
