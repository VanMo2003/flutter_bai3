import 'package:bai_tap_3/pages/page_home.dart';
import 'package:bai_tap_3/pages/page_sign_up.dart';
import 'package:bai_tap_3/values/value_text_style.dart';
import 'package:bai_tap_3/widgets/widget_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_auth_implementation/firebase_auth_services.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isError = false;
  String? error;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyleValue.h1,
                    ),
                    const SizedBox(height: 30),
                    TextFieldWidget(
                      controller: _emailController,
                      hintText: "Email",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      controller: _passwordController,
                      hintText: "Password",
                      isPasswordField: true,
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        _signIn();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            await Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                _isLoading = false;
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                            );
                          },
                          child: const Text(
                            'SignUp',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    if (_isError) ...[
                      const SizedBox(height: 10),
                      Text(
                        error!,
                        style: TextStyleValue.error,
                      )
                    ]
                  ],
                ),
                if (_isLoading) ...[
                  Container(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  const Center(child: CircularProgressIndicator())
                ]
              ],
            )),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _isError = false;
    });
    User? user = await _auth.signInWithEmailAndPassword(email, password);
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        _isLoading = false;
        if (email != '' && password != '') {
          if (user != null) {
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (route) => false,
            );
          } else {
            setState(() {
              _isError = true;
              error = 'Please check your login information again';
            });
          }
        } else {
          setState(() {
            _isError = true;

            error = 'Mời bạn nhập đầy đủ thông tin';
          });
        }
      },
    );
  }
}
