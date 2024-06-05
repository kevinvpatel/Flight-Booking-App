import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flight_booking_algorithm/Database/database_service.dart';
import 'package:flight_booking_algorithm/Flight_List/flight_list_screen.dart';
import 'package:flight_booking_algorithm/Login/login_screen.dart';
import 'package:flight_booking_algorithm/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BookedFlightsScreen extends StatefulWidget {

  BookedFlightsScreen();

  @override
  _BookedFlightsScreenState createState() => _BookedFlightsScreenState();
}

class _BookedFlightsScreenState extends State<BookedFlightsScreen> {

  DatabaseService databaseService = DatabaseService();

  Constants constants = Constants();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String user_id = '';
  String user_role = '';
  loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id') ?? 'guest';
    user_role = prefs.getString('user_role') ?? 'guest';
  }

  Stream loadFlightData({required String flight_id}) {
    Map<String, dynamic> data = {};
    final flightData = databaseService.db_flights.where('flight_id', isEqualTo: flight_id).get();

    return flightData.asStream();
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Future.delayed(Duration(milliseconds: 2000), () {
      _isLoading = false;
      setState(() {});
    });
    loadPreferences();
    getUserName();
    setState(() {});
  }

  String user_name = '';
  String user_email = '';

  getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    user_name = prefs.getString('user_name') ?? 'guest';
    user_email = prefs.getString('user_email') ?? 'guest';
    setState(() {});
  }

  final GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController seatNoController = TextEditingController();
  TextEditingController seatClassController = TextEditingController();

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

  updateDialog({
    required String docId,
    required String user_id,
    required String flight_id,
    required String booking_name,
    required String booking_contact,
    required String booking_seat,
    required String booking_class,
    required String booking_age,
  }) {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 20),
        title: 'Edit Booking Details',
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
                    hintText: 'Enter User Name',
                    obsecureText: false,
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter user name';
                      }
                      return null;
                    }
                ),
                constants.textField(
                    hintText: 'Enter User Contact',
                    obsecureText: false,
                    controller: contactController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter user contact';
                      }
                      return null;
                    }
                ),
                constants.textField(
                    hintText: 'Enter User Age',
                    obsecureText: false,
                    controller: ageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter user age';
                      }
                      return null;
                    }
                ),
                constants.textField(
                    hintText: 'Enter User Seat No.',
                    obsecureText: false,
                    controller: seatNoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter user seat no.';
                      }
                      return null;
                    }
                ),
                constants.textField(
                  hintText: 'Enter User Seat Class',
                  obsecureText: false,
                  controller: seatClassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter seat class';
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
                        content: Text('Update', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                        onPressed: () {
                          final r = seatNoController.text.substring(seatNoController.text.length-1);
                          final seat_final = '${seatNoController.text[0]} $r';
                          print('seat_final -> $seat_final');
                          updateBooking(
                              user_id: user_id,
                              flight_id: flight_id,
                              booking_age: ageController.text,
                              booking_class: seatClassController.text,
                              booking_contact: contactController.text,
                              booking_name: nameController.text,
                              booking_seat: seat_final,
                              docId: docId
                          );
                        }
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

  updateBooking({
    required String docId,
    required String user_id,
    required String flight_id,
    required String booking_name,
    required String booking_contact,
    required String booking_seat,
    required String booking_class,
    required String booking_age,
  }) {
    setState(() {
      databaseService.updateBOOKING(
          docId: docId,
          user_id: user_id,
          flight_id: flight_id,
          booking_name: booking_name,
          booking_contact: booking_contact,
          booking_seat: booking_seat,
          booking_class: booking_class,
          booking_age: booking_age
      ).whenComplete(() => Get.back());
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TextStyle headingStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: constants.appThemeColor100,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: Icon(Icons.menu)
        ),
        title: Text(user_role == 'admin' || user_role == 'staff' ? 'User Bookings' : 'My Bookings', style: TextStyle(fontSize: 20),),
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
      drawer:  constants.drawer(
          onTap1: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FlightListScreen())),
          onTap2: () => Get.back(),
          userName: user_name,
          userEmail: user_email
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 58,
                color: Colors.grey.shade200,
                width: screenWidth,
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    ///HEADING
                    Container(
                      height: 45,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(
                              color: Colors.black12, offset: Offset(0, 2), blurRadius: 2, spreadRadius: 2
                          )]
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: screenWidth / 20,
                            child: Text('Sr. No.', style: headingStyle),
                            alignment: Alignment.center,
                          ),
                          Container(
                            width: screenWidth / 6,
                            child: Text('Name', style: headingStyle),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                            width: screenWidth / 7,
                            child: Text('Contact', style: headingStyle),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                            width: screenWidth / 10,
                            child: Text('Age', style: headingStyle),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                            width: screenWidth / 8,
                            child: Text('Flight Name', style: headingStyle),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                            width: screenWidth / 7,
                            child: Text('Seat No.', style: headingStyle),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                            width: screenWidth / 7,
                            child: Text('Actions', style: headingStyle),
                            alignment: Alignment.centerLeft,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    ///CONTENT
                    user_role == 'guest'
                        ? Text('Login to book flights', style: TextStyle(color: Colors.grey, fontSize: 17),)
                        : _isLoading
                        ? Center(child: CircularProgressIndicator(color: constants.appThemeColor300))
                        : Expanded(child: StreamBuilder(
                        stream: user_role == 'user'
                            ? databaseService.getUserBOOKING(user_id: user_id)
                            : databaseService.getAllBOOKING(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            if(snapshot.data!.docs.length > 0) {
                                    TextStyle contentStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 16);
                                    return ListView.separated(
                                      itemCount: (snapshot.data?.docs.length ?? 0),
                                      itemBuilder: (context, index) {
                                        final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                        print('snapshot -> ${data}');
                                        String booking_id = data['booking_id'];
                                        String booking_name = data['booking_name'];
                                        String booking_contact = data['booking_contact'];
                                        String booking_age = data['booking_age'];
                                        String booking_seat = data['booking_seat'];
                                        String booking_class = data['booking_class'];
                                        String flight_id = data['flight_id'];
                                        String user_id = data['user_id'];
                                        return StreamBuilder(
                                            stream: loadFlightData(flight_id: flight_id),
                                            builder: (context, flightSnapshot) {
                                              if(flightSnapshot.hasData) {
                                                if(flightSnapshot.connectionState == ConnectionState.done) {
                                                  String flight_name = flightSnapshot.data!.docs.first.data()['flight_name'];
                                                  return Container(
                                                    height: 45,
                                                    width: screenWidth,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(15),
                                                        boxShadow: [BoxShadow(
                                                            color: Colors.black12, offset: Offset(0, 2), blurRadius: 2, spreadRadius: 2
                                                        )]
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: screenWidth / 20,
                                                          child: Text('${index + 1}', style: contentStyle),
                                                          alignment: Alignment.center,
                                                        ),
                                                        Container(
                                                          width: screenWidth / 6,
                                                          child: Text(booking_name, style: contentStyle),
                                                          alignment: Alignment.centerLeft,
                                                        ),
                                                        Container(
                                                          width: screenWidth / 6,
                                                          child: Text(booking_contact, style: contentStyle),
                                                          alignment: Alignment.centerLeft,
                                                        ),
                                                        Container(
                                                          width: screenWidth / 10,
                                                          child: Text(booking_age, style: contentStyle),
                                                          alignment: Alignment.centerLeft,
                                                        ),
                                                        Container(
                                                          width: screenWidth / 7,
                                                          child: Text(flight_name ?? '', style: contentStyle),
                                                          alignment: Alignment.centerLeft,
                                                        ),
                                                        Container(
                                                          width: screenWidth / 7,
                                                          // color: Colors.green,
                                                          child: Text(booking_seat.removeAllWhitespace + '/' + booking_class, style: contentStyle),
                                                          alignment: Alignment.centerLeft,
                                                        ),
                                                        Container(
                                                          width: screenWidth / 7,
                                                          // color: Colors.yellow,
                                                          alignment: Alignment.centerLeft,
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    nameController.text = booking_name;
                                                                    contactController.text = booking_contact;
                                                                    ageController.text = booking_age;
                                                                    seatNoController.text = booking_seat.removeAllWhitespace;
                                                                    seatClassController.text = booking_class;

                                                                    updateDialog(
                                                                        docId: booking_id,
                                                                        flight_id: flight_id,
                                                                        user_id: user_id,
                                                                        booking_name: nameController.text,
                                                                        booking_contact: contactController.text,
                                                                        booking_age: ageController.text,
                                                                        booking_seat: seatNoController.text,
                                                                        booking_class: seatClassController.text
                                                                    );
                                                                  });
                                                                },
                                                                icon: Icon(Icons.edit),
                                                              ),
                                                              SizedBox(width: 30),
                                                              IconButton(
                                                                onPressed: () {},
                                                                icon: Icon(CupertinoIcons.delete),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              } else {
                                                return Container();
                                              }
                                            }
                                        );
                                      },
                                      separatorBuilder: (context, index) => SizedBox(height: 10),
                                    );
                            } else {
                              return const Center(child: Text('No Booking Available !!', style: TextStyle(color: Colors.grey),));
                            }
                          } else {
                            return const Center(child: Text('No Booking Available !!', style: TextStyle(color: Colors.grey),));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
