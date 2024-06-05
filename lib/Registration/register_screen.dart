  import 'dart:ui';
  import 'package:flight_booking_algorithm/Database/database_service.dart';
import 'package:flight_booking_algorithm/Login/login_screen.dart';
import 'package:flight_booking_algorithm/services/constants.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:hive/hive.dart';
  import 'package:toggle_switch/toggle_switch.dart';
  // import 'package:provider/provider.dart';
  // import 'auth_service.dart';

  class RegisterScreen extends StatefulWidget {
    @override
    _RegisterScreenState createState() => _RegisterScreenState();
  }

  class _RegisterScreenState extends State<RegisterScreen> {

    final DatabaseService databaseService = DatabaseService();
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Login loginStatus = Login.admin;

    bool _isLoading = false;

    @override
    void initState() {
      super.initState();
    }

    void _register() async {
      if (_formKey.currentState!.validate()) {
        try {
          if(loginStatus == Login.admin) {
            databaseService.addUsers(
              user_name: nameController.text,
              user_email: emailController.text,
              user_password: passwordController.text,
              user_role: 'admin'
            );
          } else if(loginStatus == Login.staff) {
            databaseService.addUsers(
                user_name: nameController.text,
                user_email: emailController.text,
                user_password: passwordController.text,
                user_role: 'staff'
            );
          } else {
            databaseService.addUsers(
                user_name: nameController.text,
                user_email: emailController.text,
                user_password: passwordController.text,
                user_role: 'user'
            );
          }
        } catch(e) {
          print('registration screen -> $e');
        }
        setState(() {
          Future.delayed(Duration(milliseconds: 600), () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())));
          Get.snackbar('Success', '${nameController.text} Registered Successfully');
          _isLoading = true;
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
                    margin: EdgeInsets.only(top: 30),
                    child: Text('Welcome', style: GoogleFonts.pacifico(fontSize: 52),)
                )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: height * 0.8,
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
                          width: width * 0.4,
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
                                    hintText: 'Name',
                                    obsecureText: false,
                                    controller: nameController,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    }
                                ),
                                SizedBox(height: 15),
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
                                const SizedBox(height: 20),
                                ToggleSwitch(
                                  initialLabelIndex: 0,
                                  totalSwitches: 3,
                                  labels: ['Admin', 'Staff', 'User'],
                                  curve: Curves.bounceInOut,
                                  animate: true,
                                  activeBgColor: constants.toggleButtonColor,
                                  inactiveBgColor: Colors.black12,
                                  inactiveFgColor: Colors.white,
                                  animationDuration: 100,
                                  onToggle: (index) {
                                    print('index ->> $index');
                                    switch(index) {
                                      case 0:
                                        loginStatus = Login.admin;
                                        break;
                                      case 1:
                                        loginStatus = Login.staff;
                                        break;
                                      case 2:
                                        loginStatus = Login.user;
                                        break;
                                    }
                                    print('loginStatus : ${loginStatus}');
                                  },
                                ),
                                Spacer(),
                                _isLoading
                                    ? const CircularProgressIndicator()
                                    : Container(
                                  width: width,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blue.shade300
                                    ),
                                    onPressed: _register,
                                    child: const Text('Register', style: TextStyle(fontSize: 16),),
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextButton(
                                  child: Text('Already have an account?  Login', style: TextStyle(color: Colors.blue.shade200),),
                                  onPressed: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                                    Get.back();
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
