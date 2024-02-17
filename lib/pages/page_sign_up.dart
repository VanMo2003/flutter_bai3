import 'package:bai_tap_3/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:bai_tap_3/pages/page_home.dart';
import 'package:bai_tap_3/pages/page_sign_in.dart';
import 'package:bai_tap_3/values/value_text_style.dart';
import 'package:bai_tap_3/widgets/widget_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isError = false;
  String? error;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
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
                    "Sign Up",
                    style: TextStyleValue.h1,
                  ),
                  const SizedBox(height: 30),
                  TextFieldWidget(
                    controller: _usernameController,
                    hintText: "Username",
                    isPasswordField: false,
                  ),
                  const SizedBox(height: 10),
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
                      _signUp();
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
                          'Sign Up',
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
                      const Text("Already have an account?"),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInPage(),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
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
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });
    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    await Future.delayed(
      const Duration(seconds: 1),
      () {
        _isLoading = false;
        if (email != '' && password != '' && username != '') {
          if (user != null) {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            setState(() {
              _isError = true;
              error = 'tài khoản đã tồn tại';
            });
            debugPrint('Sign Up Faild');
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
