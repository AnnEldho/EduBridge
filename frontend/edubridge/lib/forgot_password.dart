import 'package:edubridge/widgets/text_widgets.dart';
import 'package:edubridge/widgets/textbox_widget.dart';
import 'package:flutter/material.dart';

class ForgotpasswordPage extends StatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  State<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

class _ForgotpasswordPageState extends State<ForgotpasswordPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final _emailController = TextEditingController();
  bool _hidePassword1 = true;
  bool _hidePassword2 = true;
  String? validateEmail(String? value) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Password must have at least one uppercase, one lowercase, one number and one special character, and minimum 8 characters long.';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? value) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Password must have at least one uppercase, one lowercase, one number and one special character, and minimum 8 characters long.';
    } else if (password.value != confirmpassword.value) {
      return 'Password not matching';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: ListView(children: [
        const SizedBox(
          height: 250,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextBox(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: validateEmail,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey1.currentState!.validate()) {}
                      },
                      child: const Text("Submit")),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: _formKey2,
              child: Column(
                children: [
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      errorMaxLines: 200,
                      labelText: 'New Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_hidePassword1
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _hidePassword1 = !_hidePassword1;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: validatePassword,
                    obscureText: _hidePassword1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: confirmpassword,
                    decoration: InputDecoration(
                      errorMaxLines: 200,
                      labelText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(_hidePassword2
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _hidePassword2 = !_hidePassword2;
                          });
                        },
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: validateConfirmPassword,
                    obscureText: _hidePassword2,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey2.currentState!.validate()) {}
                        },
                        child: const Text("Submit")),
                  )
                ],
              )),
        )
      ]),
    );
  }
}
