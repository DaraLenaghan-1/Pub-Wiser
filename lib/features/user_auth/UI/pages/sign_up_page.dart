//import 'package:first_app/features/user_auth/presentation/pages/home_page.dart';
import 'package:first_app/features/user_auth/UI/pages/login_page.dart';
import 'package:first_app/global/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:first_app/features/user_auth/UI/widgets/form_container_widget.dart';
import 'package:first_app/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isSigningUp = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController signUpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    signUpController.addListener(() {
      print(
          'Username text: ${usernameController.text}'); // For debugging purposes
    });
    emailController.addListener(() {
      print('Email text: ${emailController.text}'); // For debugging purposes
    });
    passwordController.addListener(() {
      print('Password text: ${passwordController.text}');
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    signUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures the keyboard doesn't overflow
      appBar: AppBar(
        title: const Text('Sign Up Page'),
      ),
      body: SingleChildScrollView(
        // Ensures the content is scrollable and bounds are provided
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              // Constrains the Column's height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FormContainerWidget(
                    controller: usernameController,
                    hintText: 'Username',
                    isPasswordField: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FormContainerWidget(
                    //TextField(
                    controller: emailController,
                    //decoration: InputDecoration(
                    hintText: 'Email',
                    isPasswordField: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FormContainerWidget(
                    controller: passwordController,
                    hintText: 'Password',
                    isPasswordField: true,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _signUp,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: _signUp,
                          child: isSigningUp
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false,
                          );
                          print(
                              'Sign Up button pressed'); // For debugging purposes
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                  // Add more widgets as needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: 'Sign up successful');
      Navigator.pushNamed(context, "/tabs");
    } else {
      showToast(message: 'Sign up failed');
    }
  }
}
