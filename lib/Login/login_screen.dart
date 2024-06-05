import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flight_booking_algorithm/Database/database_service.dart';
import 'package:flight_booking_algorithm/Flight_List/flight_list_screen.dart';
import 'package:flight_booking_algorithm/Registration/register_screen.dart';
import 'package:flight_booking_algorithm/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:toggle_switch/toggle_switch.dart';
// import 'package:provider/provider.dart';
// import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Login loginStatus = Login.admin;

  @override
  void initState() {
    super.initState();
  }

  Future _login({required bool isGuestLogin}) async {
    final prefs = await SharedPreferences.getInstance();
    if(isGuestLogin) {
      await prefs.setString('user_role', 'guest');
      Navigator.push(context, MaterialPageRoute(builder: (context) => FlightListScreen()));
    } else {
      setState(() {
        if (_formKey.currentState!.validate()) {
          try {
            //Query for check user
              final snap = databaseService.db_users
                  .where('user_email', isEqualTo: emailController.text)
                  .where('user_password', isEqualTo: passwordController.text)
                  .get();
              snap.then((k) async {
                bool isDataEmpty = k.docs.isEmpty;
                if(isDataEmpty == true) {
                  Get.snackbar('Login Error', 'User not registered');
                } else {
                  print('k -> ${k.docs.first.data()}');
                  await prefs.setString('user_email', k.docs.first.data()['user_email']);
                  await prefs.setString('user_id', k.docs.first.data()['user_id']);
                  await prefs.setString('user_name', k.docs.first.data()['user_name']);
                  await prefs.setString('user_role', k.docs.first.data()['user_role']);
                  await prefs.setString('user_password', k.docs.first.data()['user_password']);
                  Get.to(FlightListScreen());
                  emailController.clear();
                  passwordController.clear();
                }
              });
          } catch(e) {
            print('registration screen -> $e');
          }
        }
      });
    }
  }


  Constants constants = Constants();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue.shade200, Colors.blue.shade300]
                        )
                    ),
                    margin: EdgeInsets.only(top: 40),
                    child: Text('Welcome', style: GoogleFonts.pacifico(fontSize: 52),)
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: height * 0.7,
                  width: width * 0.4,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 8)],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: height * 0.8,
                          width: width * 0.4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaY: 0, sigmaX: 0),
                              child: Image.asset('assets/images/pexels-ernestbusalpa-15276432.jpg', fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        height: height * 0.8,
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                            color: Colors.black45
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 25),
                              constants.textField(
                                  hintText: 'Email',
                                  obsecureText: false,
                                  controller: emailController,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(height: 15),
                              constants.textField(
                                  hintText: 'Password',
                                  obsecureText: true,
                                  controller: passwordController,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  }
                              ),
                              Spacer(),
                              Container(
                                      width: width,
                                      height: 45,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue.shade300
                                        ),
                                        onPressed: () => _login(isGuestLogin: true),
                                        child: const Text('Guest Login', style: TextStyle(fontSize: 16),),
                                      ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                      width: width,
                                      height: 45,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue.shade300
                                        ),
                                        onPressed: () => _login(isGuestLogin: false),
                                        child: const Text('Login', style: TextStyle(fontSize: 16),),
                                      ),
                              ),
                              SizedBox(height: 30),
                              TextButton(
                                child: Text('Don\'t have an account?  Signup Now', style: TextStyle(color: Colors.blue.shade200),),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                                },
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
