import 'package:flutter/material.dart';

import 'form_button.dart';
import 'input_field.dart';

class LoginForm extends StatefulWidget {
  final Function(String? email, String? password)? onSubmitted;

  const LoginForm({this.onSubmitted, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late String email, password;
  String? emailError, passwordError;

  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;


  @override
  void initState() {
    super.initState();
    email = '';
    password = '';

    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'Email is invalid';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(email, password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Your existing content goes here
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                constraints: const BoxConstraints(maxWidth: 400),
                // Set max width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome,',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withOpacity(.6),
                      ),
                    ),
                    SizedBox(height: screenHeight * .08),
                    InputField(
                      onChanged: (value) {
                        // Update email value
                      },
                      labelText: 'Email',
                      errorText: '',
                      // Handle email error
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autoFocus: true,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      onChanged: (value) {
                        // Update password value
                      },
                      onSubmitted: (val) => {},
                      // Handle submit
                      labelText: 'Password',
                      errorText: '',
                      // Handle password error
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Add your forgot password logic here
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FormButton(
                      text: 'Log In',
                      onPressed: () {}, // Submit action
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to registration screen
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "I'm a new user, ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
