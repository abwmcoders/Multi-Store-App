

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/auth_widget.dart';
import '../widgets/snackbar.dart';

// TextEditingController nameController = TextEditingController(text: '');
// TextEditingController emailController = TextEditingController(text: '');
// TextEditingController passwordController = TextEditingController(text: '');

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({super.key});

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String email;
  late String password;
  bool precessing = false;
    bool passwordVisible = false;




  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: "Login",
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          //controller: emailController,
                          decoration: textformDecoration().copyWith(
                            labelText: "Email Address",
                            hintText: "Enter your email",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter your email address";
                            } else if (value.isValidEmail() == false) {
                              return "Please enter a valid email";
                            } else if ((value.isValidEmail() == true)) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          obscureText: passwordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          //controller: passwordController,
                          decoration: textformDecoration().copyWith(
                              labelText: "Password",
                              hintText: "Enter your password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off,
                                  color: Colors.purple,
                                ),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a password";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ),
                      TextButton(onPressed: (){}, child: const Text("Forgot Password", style: TextStyle(
                        fontSize: 17,
                        fontStyle: FontStyle.italic,
                      ),),),
                      HaveAccount(
                        haveAccount: "Don't have an account",
                        actionLabel: "SignUp",
                        onPress: () {
                          Navigator.pushReplacementNamed(
                              context, "/customer_signup");
                        },
                      ),
                      precessing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.purple,
                              ),
                            )
                          : AuthMainButton(
                              title: "Login",
                              onPressed: () {
                                _login();
                              },
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      precessing = true;
    });
    if (formKey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          Navigator.pushReplacementNamed(context, '/customer_home');
          formKey.currentState!.reset();
         
        } on FirebaseAuthException catch (e) {
          if (e.code == "user-not-found") {
            setState(() {
              precessing = false;
            });
            MyMessage.showSnackBar(
                scaffoldKey, "There is no user with the above email.");
          } else if (e.code == "wrong-password") {
            setState(() {
              precessing = false;
            });
            MyMessage.showSnackBar(
                scaffoldKey, "Invalid credentials");
          } else {
            setState(() {
              precessing = false;
            });
            MyMessage.showSnackBar(scaffoldKey, e.toString());
          }
        } catch (e) {
          setState(() {
            precessing = false;
          });
          MyMessage.showSnackBar(scaffoldKey, e.toString());
        }
    } else {
      setState(() {
        precessing = false;
      });
      MyMessage.showSnackBar(scaffoldKey, "Please check your inputs");
    }
  }
}
