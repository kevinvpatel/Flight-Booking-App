import 'package:firebase_core/firebase_core.dart';
import 'package:flight_booking_algorithm/Login/login_screen.dart';
import 'package:flight_booking_algorithm/Registration/register_screen.dart';
import 'package:flight_booking_algorithm/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyCdiOhYsUlc3ZVEODt6MiEyhPM8LCA90Io',
        appId: '1:142765579827:web:b837107f44ed3838310d46',
        messagingSenderId: '142765579827',
        projectId: 'flight-booking-app-acf02'
    )
  );
  // await Hive.initFlutter();
  // await Hive.openBox('admin_details');
  // await Hive.openBox('staff_details');
  // await Hive.openBox('user_details');
  // await Hive.openBox('flight_details');
  runApp(FlightBookingApp());
}

class FlightBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flight Booking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Seatselectionscreen2(fligh_id: '2WGf2IqUUcBr676VV5iY', user_id: '9q6i8v2xQODn6u8Ci40b', fligh_name: 'Vistara Airline'),
      home: LoginScreen(),
    );
  }
}
