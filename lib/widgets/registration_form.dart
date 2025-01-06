import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/form_button.dart';

class RegisterForm extends StatefulWidget {
  final Function(String? email, String? password)? onSubmitted;

  const RegisterForm({this.onSubmitted, Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late String email, password, confirmPassword;
  String? emailError, passwordError;

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';
    confirmPassword = '';
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

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }
    if (password != confirmPassword) {
      setState(() {
        passwordError = 'Passwords do not match';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      widget.onSubmitted?.call(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        InputField(
          onChanged: (value) => setState(() => email = value),
          labelText: 'Email',
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autoFocus: true,
        ),
        SizedBox(height: screenHeight * .025),
        InputField(
          onChanged: (value) => setState(() => password = value),
          labelText: 'Password',
          errorText: passwordError,
          obscureText: true,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: screenHeight * .025),
        InputField(
          onChanged: (value) => setState(() => confirmPassword = value),
          onSubmitted: (_) => submit(),
          labelText: 'Confirm Password',
          errorText: passwordError,
          obscureText: true,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: screenHeight * .075),
        FormButton(text: 'Sign Up', onPressed: submit),
      ],
    );
  }
}
