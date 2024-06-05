import 'package:flight_booking_algorithm/Booked_Flight/booked_flight_list_screen.dart';
import 'package:flight_booking_algorithm/Database/database_service.dart';
import 'package:flight_booking_algorithm/Login/login_screen.dart';
import 'package:flight_booking_algorithm/Seating_Plan/SeatSelectionScreen1.dart';
import 'package:flight_booking_algorithm/Seating_Plan/SeatSelectionScreen2.dart';
import 'package:flight_booking_algorithm/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlightListScreen extends StatefulWidget {

  @override
  State<FlightListScreen> createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  DatabaseService databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController flightNameController = TextEditingController();

  final TextEditingController departureTimeController = TextEditingController();

  final TextEditingController arrivalTimeController = TextEditingController();

  final TextEditingController flightRouteController = TextEditingController();

  final TextEditingController flightSeatController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  String user_role = '';
  String user_name = '';
  String user_email = '';
  String user_id = '';

  getUserRole() async {
   final prefs = await SharedPreferences.getInstance();
   user_role = prefs.getString('user_role') ?? 'guest';
   user_name = prefs.getString('user_name') ?? 'guest';
   user_email = prefs.getString('user_email') ?? 'guest';
   user_id = prefs.getString('user_id') ?? 'guest';
   setState(() {});
  }

final Constants constants = Constants();



Widget customButton({
  double? height,
  double? width,
  required Widget content,
  required Function() onPressed,
  EdgeInsets? padding
}) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: padding,
            backgroundColor: Colors.blue.shade200,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )
        ),
        child: content,
        onPressed: onPressed,
      ),
    );
  }

  flightsDialog({bool isEdit = false}) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 20),
      title: isEdit ? 'Edit Flight Details' : 'Add Flight Details',
      titlePadding: const EdgeInsets.only(top: 30),
      titleStyle: const TextStyle(fontSize: 20),
      backgroundColor: Colors.white,
      buttonColor: Colors.blue.shade200,
      barrierDismissible: true,
      content: Form(
        key: _formKey,
        child: Container(
          width: 400,
          child: Column(
            children: [
              constants.textField(
                  hintText: 'Enter Flight Name',
                  obsecureText: false,
                  controller: flightNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter flight name';
                    }
                    return null;
                  }
              ),
              constants.textField(
                  hintText: 'Enter Flight Route',
                  obsecureText: false,
                  controller: flightRouteController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter flight route';
                    }
                    return null;
                  }
              ),
              constants.textField(
                  hintText: 'Enter Departure Time',
                  obsecureText: false,
                  controller: departureTimeController,
                  cursorColor: Colors.transparent,
                  onTap: () {
                    DatePicker.showDateTimePicker(
                        context,
                        onChanged: (datetime) {
                          DateTime selectedDate = datetime;
                          final set = DateFormat('dd, MMM yyyy - HH:mm').format(selectedDate);
                          departureTimeController.text = set;
                          setState(() {});
                        }
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter departure time';
                    }
                    return null;
                  },
              ),
              constants.textField(
                  hintText: 'Enter Arrival Time',
                  obsecureText: false,
                  controller: arrivalTimeController,
                  cursorColor: Colors.transparent,
                  onTap: () {
                    DatePicker.showDateTimePicker(
                        context,
                        onChanged: (datetime) {
                          DateTime selectedDate = datetime;
                          final set = DateFormat('dd, MMM yyyy - HH:mm').format(selectedDate);
                          arrivalTimeController.text = set;
                          setState(() {});
                        }
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter arrival time';
                    }
                    return null;
                  },
              ),
              constants.textField(
                  hintText: 'Enter Total Seats',
                  obsecureText: false,
                  controller: flightSeatController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total seats';
                    }
                    return null;
                  },
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  customButton(
                      height: 45,
                      width: 400 * 0.8,
                      content: Text(isEdit ? 'Update' : 'Add ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      onPressed: isEdit ? editFlight : addFlight
                  ),
                  customButton(
                      height: 45,
                      width: 400 * 0.15,
                      padding: EdgeInsets.zero,
                      content: const Text('⨉', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      onPressed: () => Get.back()
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  addFlight() {
    if(_formKey.currentState!.validate()) {
      try {
        databaseService.addFlights(
            flight_name: flightNameController.text,
            flight_route: flightRouteController.text,
            flight_departure_time: departureTimeController.text,
            flight_arrival_time: arrivalTimeController.text,
            total_seats: flightSeatController.text
        );

        flightNameController.clear();
        flightRouteController.clear();
        departureTimeController.clear();
        arrivalTimeController.clear();
        flightSeatController.clear();
      } catch (e) {
        print('flight add err -> $e');
      }
      Get.back();
    }
  }


  String docId = '';
  editFlight() {
    if(_formKey.currentState!.validate()) {
      try {
        databaseService.updateFlights(
            docId: docId,
            flight_name: flightNameController.text,
            flight_route: flightRouteController.text,
            flight_departure_time: departureTimeController.text,
            flight_arrival_time: arrivalTimeController.text,
            total_seats: flightSeatController.text
        );
      } catch (e) {
        print('flight add err -> $e');
      }
      Get.back();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  print('user_name ->> $user_name');
  print('user_email ->> $user_email');
    return Scaffold(
      key: _scaffoldKey,
      drawer: constants.drawer(
          onTap1: () => Get.back(),
          onTap2: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookedFlightsScreen())),
          userName: user_name,
          userEmail: user_email
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
          backgroundColor: constants.appThemeColor100,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: Icon(Icons.menu)
          ),
          title: Text('Available Flights', style: TextStyle(fontSize: 20),),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TextButton(
                  onPressed: () async {
                    final pref = await SharedPreferences.getInstance();
                    pref.clear();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Row(
                    children: [
                      Text(user_role == 'guest' ? 'Log In' : 'Log Out', style: TextStyle(fontWeight: FontWeight.w600),),
                      SizedBox(width: 8),
                      Icon(user_role == 'guest' ? Icons.login : Icons.logout, size: 17,),
                    ],
                  )
              ),
            )
          ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 58,
            color: Colors.grey.shade100,
            width: screenWidth,
            child: StreamBuilder(
              stream: databaseService.getFlights(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        String flight_id = snapshot.data?.docs[index].get('flight_id');
                        String flight_name = snapshot.data?.docs[index].get('flight_name');
                        String flight_route = snapshot.data?.docs[index].get('flight_route');
                        String flight_departure_time = snapshot.data?.docs[index].get('flight_departure_time');
                        String flight_arrival_time = snapshot.data?.docs[index].get('flight_arrival_time');
                        String flight_seats = snapshot.data?.docs[index].get('total_seats');
                        return Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              padding: EdgeInsets.all(20),
                              height: screenHeight * 0.24,
                              width: screenWidth * 0.55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [BoxShadow(color: Colors.black26,
                                      blurRadius: 8, spreadRadius: 0, offset: Offset(0, 4))]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/air-transport.png', width: 52),
                                  VerticalDivider(width: 45),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(flight_name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(flight_route.split('to').first.capitalize!,
                                                style: TextStyle(fontSize: 18),),
                                              SizedBox(height: 10),
                                              Text(flight_departure_time.split('-').first,
                                                style: TextStyle(fontSize: 18, color: Colors.grey),),
                                              Text(flight_departure_time.split('-').last,
                                                style: TextStyle(fontSize: 18, color: Colors.grey),)
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(height: 35,),
                                              Row(
                                                children: [
                                                  Container(width: screenWidth * 0.17,
                                                      padding: EdgeInsets.symmetric(horizontal: 20), child: Divider()
                                                  ),
                                                  Icon(CupertinoIcons.airplane, size: 18, color: Colors.grey,),
                                                  Container(width: screenWidth * 0.17,
                                                      padding: EdgeInsets.symmetric(horizontal: 20), child: Divider()
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              Text('$flight_seats Seats')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(flight_route.split('to').last.capitalize!,
                                                style: TextStyle(fontSize: 18),),
                                              SizedBox(height: 10),
                                              Text(flight_arrival_time.split('-').first,
                                                style: TextStyle(fontSize: 18, color: Colors.grey),),
                                              Text(flight_arrival_time.split('-').last,
                                                style: TextStyle(fontSize: 18, color: Colors.grey),)
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            ///side buttons
                            user_role == 'admin'
                                ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FloatingActionButton(
                                    heroTag: '20',
                                    backgroundColor: Colors.red.shade400,
                                    mini: true,
                                    child: Icon(Icons.delete, color: Colors.white),
                                    onPressed: () {
                                      docId = '';
                                      docId = flight_id;
                                      databaseService.deleteFlights(docId: docId);
                                    }
                                ),
                                SizedBox(height: 15),
                                FloatingActionButton(
                                    heroTag: '50',
                                    backgroundColor: Colors.white,
                                    hoverColor: Colors.blue.shade200,
                                    mini: true,
                                    child: Icon(Icons.arrow_forward_ios_outlined),
                                    onPressed: () {
                                      if(index % 2==0) {
                                        Get.to(
                                            Seatselectionscreen1(fligh_id: flight_id, fligh_name: flight_name, user_id: user_id)
                                        );
                                      } else {
                                        Get.to(
                                            Seatselectionscreen2(fligh_id: flight_id, fligh_name: flight_name, user_id: user_id)
                                        );
                                      }
                                    }
                                ),
                                SizedBox(height: 15),
                                FloatingActionButton(
                                    heroTag: '60',
                                    backgroundColor: Colors.green.shade400,
                                    mini: true,
                                    child: Icon(Icons.edit, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        docId = '';
                                        docId = flight_id;
                                        flightNameController.text = flight_name;
                                        flightRouteController.text = flight_route;
                                        flightSeatController.text = flight_seats;
                                        departureTimeController.text = flight_departure_time;
                                        arrivalTimeController.text = flight_arrival_time;
                                        flightsDialog(isEdit: true);
                                      });
                                    }
                                )
                              ],
                            )
                                : SizedBox(
                              height: screenHeight * 0.24,
                              child: FloatingActionButton(
                                  heroTag: '70',
                                  mini: true,
                                  backgroundColor: Colors.white,
                                  hoverColor: Colors.blue.shade200,
                                  child: Icon(Icons.arrow_forward_ios_rounded),
                                  onPressed: () {
                                    print('docId 23-> $flight_id');
                                    if(index % 2==0) {
                                      Get.to(
                                          Seatselectionscreen1(fligh_id: flight_id, fligh_name: flight_name, user_id: user_id)
                                      );
                                    } else {
                                      Get.to(
                                          Seatselectionscreen2(fligh_id: flight_id, fligh_name: flight_name, user_id: user_id)
                                      );
                                    }
                                  }
                              ),
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No Flights Available !!', style: TextStyle(color: Colors.grey),));
                  }
                } else {
                  return const Center(child: Text('No Flights Available !!', style: TextStyle(color: Colors.black),));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: user_role == 'admin' ? customButton(
          height: 45,
          width: 140,
          content: const Row(
            children: [
              Text('Add Flight  ', style: TextStyle(fontWeight: FontWeight.w500),),
              Icon(Icons.add, color: Colors.white, size: 20)
            ],
          ),
          onPressed: flightsDialog
      ) : SizedBox.shrink(),
    );
  }
}

