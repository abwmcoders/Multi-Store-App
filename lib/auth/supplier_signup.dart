// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widgets/auth_widget.dart';
import '../widgets/snackbar.dart';

// TextEditingController nameController = TextEditingController(text: '');
// TextEditingController emailController = TextEditingController(text: '');
// TextEditingController passwordController = TextEditingController(text: '');

class SupplierRegister extends StatefulWidget {
  const SupplierRegister({super.key});

  @override
  State<SupplierRegister> createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {
  bool passwordVisible = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String storeName;
  late String email;
  late String password;
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;
  dynamic pickedImageError;
  bool precessing = false;

  late String storeLogo;

  String? _uid;

  void pickImageFromCamera() async {
    try {
      final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
        });
      }
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
      print(pickedImageError.toString());
    }
  }

  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('Suppliers');

  void pickImageFromGallery() async {
    try {
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
        });
      }
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
      print(pickedImageError.toString());
    }
  }

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
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: "Sign Up",
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage: imageFile == null
                                  ? null
                                  : FileImage(File(imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    pickImageFromCamera();
                                  },
                                  icon: const Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    pickImageFromGallery();
                                  },
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          //controller: nameController,
                          decoration: textformDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter your full name";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            storeName = value;
                          },
                        ),
                      ),
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
                      HaveAccount(
                        haveAccount: "Already have an account",
                        actionLabel: "Login",
                        onPress: () {
                          Navigator.pushReplacementNamed(
                              context, "/supplier_login");
                        },
                      ),
                      precessing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.purple,
                              ),
                            )
                          : AuthMainButton(
                              title: "SignUp",
                              onPressed: () {
                                _signUp();
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

  void _signUp() async {
    setState(() {
      precessing = true;
    });
    if (formKey.currentState!.validate()) {
      if (imageFile != null) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          _uid = FirebaseAuth.instance.currentUser!.uid;
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref("cust-images/$email.jpg");
          await ref.putFile(File(imageFile!.path));
          storeLogo = await ref.getDownloadURL();
          await suppliers.doc(_uid).set({
            "store_name": storeName,
            "email": email,
            "store_logo": storeLogo,
            "phon_number": "",
            "sup_id": _uid,
            "cover_image": "",
          });
          Navigator.pushReplacementNamed(context, '/supplier_login');
          formKey.currentState!.reset();
          setState(() {
            imageFile = null;
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == "weak-password") {
            print("Password provided is too weak");
            setState(() {
              precessing = false;
            });
            MyMessage.showSnackBar(
                scaffoldKey, "Password provided is too weak");
          } else if (e.code == "email-already-in-use") {
            print("An account already exist for this email");
            setState(() {
              precessing = false;
            });
            MyMessage.showSnackBar(
                scaffoldKey, "An account already exist for this email");
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
        MyMessage.showSnackBar(scaffoldKey, "Please choose a profile image");
      }
    } else {
      setState(() {
        precessing = false;
      });
      MyMessage.showSnackBar(scaffoldKey, "Please check your inputs");
    }
  }
}
