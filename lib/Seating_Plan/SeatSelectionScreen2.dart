import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flight_booking_algorithm/Booked_Flight/booked_flight_list_screen.dart';
import 'package:flight_booking_algorithm/Database/database_service.dart';
import 'package:flight_booking_algorithm/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Seat {
  final int row;
  final int column;
  bool isBooked;
  bool isSelected;
  String seatClass;

  Seat({required this.row, required this.column, required this.seatClass, this.isBooked = false, this.isSelected = false});
}

enum SeatClass {firstClass, businessClass, economyClass}

class Seatselectionscreen2 extends StatefulWidget {

  final String fligh_id;
  final String user_id;
  final String fligh_name;
  Seatselectionscreen2({required this.fligh_id, required this.user_id, required this.fligh_name, super.key});

  @override
  State<Seatselectionscreen2> createState() => _Seatselectionscreen2State();
}

class _Seatselectionscreen2State extends State<Seatselectionscreen2> {
  final List<Seat> first_class_seats = [];
  final List<Seat> business_class_seats = [];
  final List<Seat> economy_class_seats = [];
  final Set<Seat> _selectedSeats = {};
  int currentSelectedSeats = 0;

  int maximumSelectedValue = 0;

  Constants constants = Constants();

  SeatClass seatClass = SeatClass.firstClass;

  TextEditingController passengerController = TextEditingController();

  DatabaseService databaseService = DatabaseService();

  int lettersToIndex(String letters) {
    var result = 0;
    for (var i = 0; i < letters.length; i++) {
      result = result * 26 + (letters.codeUnitAt(i) & 0x1f);
    }
    return result;
  }

  List<Map<String, dynamic>> seatFirestoreData = [];

  loadBookedSeats() {
    final flightData = databaseService.db_bookings.where('flight_id', isEqualTo: widget.fligh_id).get();

    flightData.then((bookingData) {
      bookingData.docs.forEach((booking) {
        String seatNum = booking.get('booking_seat');
        String seatClass = booking.get('booking_class');
        List<String> seatSplit = seatNum.split(' ');
        String _row = seatSplit[0].removeAllWhitespace;
        String _column = seatSplit[1].removeAllWhitespace;
        final converted = lettersToIndex(_column);
        seatFirestoreData.add({'row' : int.parse(_row), 'column' : (converted - 1), 'isBooked' : true, 'seatClass' : seatClass});
        setState(() {});
      });
    }).whenComplete(() {
      Future.delayed(Duration(milliseconds: 500), () {
        generateFirstClassSeats(rows:4, columns: 4);
        generateBusinessClassSeats(rows:3, columns: 6);
        generateEconomyClassSeats(rows:20, columns: 6);
        _isLoad = true;
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadBookedSeats();
    loadPreferences();
    // generateFirstClassSeats(rows:3, columns: 4);
    // generateBusinessClassSeats(rows:4, columns: 6);
    // generateEconomyClassSeats(rows:13, columns: 6);
  }

  String user_role = '';

  loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    user_role = prefs.getString('user_role')!;
    print('user_role -> $user_role');
    setState(() {});
  }

  void generateFirstClassSeats({required int rows, required int columns}) {
    for (int row = 1; row < rows + 1; row++) {
      for (int column = 0; column < columns; column++) {
        final isDataMatched = seatFirestoreData.any((seat) => seat['row'] == row && seat['column'] == column && seat['seatClass'] == 'First Class');
        if(isDataMatched) {
          first_class_seats.add(
              Seat(row: row, column: column, isBooked: true, seatClass: 'First Class')
          ); // Example: first 2 seats in row 0 are booked
        } else {
          first_class_seats.add(
              Seat(row: row, column: column, isBooked: false, seatClass: 'First Class')
          ); // Example: first 2 seats in row 0 are booked
        }
      }
    }
  }
  void generateBusinessClassSeats({required int rows, required int columns}) {
    for (int row = 1; row < rows + 1; row++) {
      for (int column = 0; column < columns; column++) {
        final isDataMatched = seatFirestoreData.any((seat) => seat['row'] == row && seat['column'] == column && seat['seatClass'] == 'Business Class');
        print('isDataMatched -> $isDataMatched');
        if(isDataMatched) {
          business_class_seats.add(
              Seat(row: row, column: column, isBooked: true, seatClass: 'Business Class')
          ); // Example: first 2 seats in row 0 are booked
        } else {
          business_class_seats.add(
              Seat(row: row, column: column, isBooked: false, seatClass: 'Business Class')
          ); // Example: first 2 seats in row 0 are booked
        }
      }
    }
  }
  void generateEconomyClassSeats({required int rows, required int columns}) {
    for (int row = 1; row < rows + 1; row++) {
      for (int column = 0; column < columns; column++) {
        final isDataMatched = seatFirestoreData.any((seat) => seat['row'] == row && seat['column'] == column && seat['seatClass'] == 'Economy Class');
        if(isDataMatched) {
          economy_class_seats.add(
              Seat(row: row, column: column, isBooked: true, seatClass: 'Economy Class')
          ); // Example: first 2 seats in row 0 are booked
        } else {
          economy_class_seats.add(
              Seat(row: row, column: column, isBooked: false, seatClass: 'Economy Class')
          ); // Example: first 2 seats in row 0 are booked
        }
      }
    }
  }

  void randomAllocation({required List<Seat> seatingClass}) {
    _selectedSeats.clear();
    print('seatingClass.length -> ${seatingClass.length}');
    print('maximumSelectedValue -> $maximumSelectedValue');
    int i = 0;
    do {
      _selectedSeats.clear();
      ///Random num ne out of index thi bachava mate nu logic che as well as flight algorithm ma b chale
      ///index urfe "i" jevu out of index thava jase etle "break" execute thse and while loop ghumse and
      ///again random num generate thse
      final randomIndex = Random().nextInt(seatingClass.length);
      print('randomIndex -> $randomIndex');
      for(i=randomIndex; i<(randomIndex + maximumSelectedValue); i++){
        print('i -> $i');


        if(i > seatingClass.length - 1) {
          break;
        }

        // if(seatingClass[i].isBooked) {
        //   continue;
        // }


        if(!_selectedSeats.contains(seatingClass[i])) {
          _selectedSeats.add(seatingClass[i]);
          seatingClass[i].isSelected == true;
        } else {
          _selectedSeats.remove(seatingClass[i]);
          seatingClass[i].isSelected == false;
        }
        setState(() {});
      }
    } while(i > seatingClass.length - 1);

  }

  clearAllSelection({required List<Seat> seatingClass}) {
    seatingClass.forEach((seat) {
      seat.isSelected = false;
      setState(() {});
    });
  }

  void toggleSeatSelection(Seat seat) {
      if(!seat.isBooked) {
        if(_selectedSeats.contains(seat)) {
          _selectedSeats.remove(seat);
          seat.isSelected = false;
        } else {
          _selectedSeats.add(seat);
          seat.isSelected = true;
        }
      }
      setState(() {});
  }

  compareSeats({required List<Seat> seatListToCompare, required Seat seatForCompare}) {
        print(' ');
    bool same = seatListToCompare.any((s) {
      if(seatForCompare.row == s.row && seatForCompare.row == s.row && seatForCompare.seatClass == s.seatClass) {
        print('seatForCompare.row -> ${seatForCompare.row}');
        print('seatForCompare.column -> ${seatForCompare.column}');
        print('seatForCompare.seatClass -> ${seatForCompare.seatClass}');
      }
      return seatForCompare.row == s.row && seatForCompare.row == s.row && seatForCompare.seatClass == s.seatClass;
    });
    setState(() {});
    print('same -> ${same}');
    return same;
  }

  bool _isLoad = false;

  @override
  Widget build(BuildContext context) {
    double width = 500;
    double jetSpace = 120;
    print('user_role2 -> ${user_role == 'guest'}');

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(widget.fligh_name),
        backgroundColor: constants.appThemeColor100,
      ),
      body: Container(
        // width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user_role == 'admin' || user_role == 'guest' ? SizedBox.shrink() : functionalityBox(),
            ///Seating Plan
            Container(
              color: Colors.white,
              width: width,
              child: _isLoad == false
                  ? Center(child: CircularProgressIndicator(color: constants.appThemeColor300,),)
                  : SingleChildScrollView(
                  child: Container(
                  margin: EdgeInsets.all(jetSpace),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(280),
                      border: Border.all(color: Colors.black)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Pilot Cockpit
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(200), topLeft: Radius.circular(200))
                        ),
                        height: 30,
                        margin: EdgeInsets.only(bottom: 100, left: 80, right: 80, top: 70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(200), topLeft: Radius.circular(200))
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(child: Text('First Class', style: TextStyle(fontSize: 16),),
                          width: double.infinity, alignment: Alignment.center),

                      ///First Class
                      Container(
                          padding: EdgeInsets.only(left: jetSpace * 0.1, right: jetSpace * 0.3, bottom: 30, top: 20),
                          // padding: EdgeInsets.symmetric(horizontal: jetSpace * 0.2, vertical: 20),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: List.generate(first_class_seats.length, (index) {
                              final seat = first_class_seats[index];
                              return InkWell(
                                onTap: () {
                                  if(user_role == 'admin' || user_role == 'guest') {
                                    null;
                                  } else {
                                    toggleSeatSelection(seat);
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  width: 30,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: index%2==0 ? 30 : 0),
                                  decoration: BoxDecoration(
                                      color: seat.isBooked ? Colors.grey
                                          : _selectedSeats.contains(seat) ? Colors.red : Colors.blue.shade600,
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Text('${seat.row}${String.fromCharCode(65 + seat.column)}',
                                    style: TextStyle(color: Colors.white, fontSize: 13),),
                                ),
                              );
                            }),
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            height: 35,
                            width: 35 * 3.5,
                            margin: EdgeInsets.only(right: 20),
                            alignment: Alignment.center,
                            child: Text('Restroom 🚻', style: TextStyle(fontSize: 13),),
                          ),
                        ],
                      ),
                      Divider(),
                      Container(child: Text('Business Class', style: TextStyle(fontSize: 16),),
                          width: double.infinity, alignment: Alignment.center),

                      ///Business Class
                      Container(
                          padding: EdgeInsets.only(right: 5, bottom: 20, top: 15),
                          // padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 15,
                            alignment: WrapAlignment.center,
                            children: List.generate(business_class_seats.length, (index) {
                              final seat = business_class_seats[index];
                              return InkWell(
                                onTap: () {
                                  if(user_role == 'admin' || user_role == 'guest') {
                                    null;
                                  } else {
                                    toggleSeatSelection(seat);
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: index%3==0 ? 17 : 0),
                                  decoration: BoxDecoration(
                                      color: seat.isBooked ? Colors.grey : _selectedSeats.contains(seat) ? Colors.red : Colors.orange,
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Text('${seat.row}${String.fromCharCode(65 + seat.column)}',
                                    style: TextStyle(color: Colors.white, fontSize: 13),),
                                ),
                              );
                            }),
                          )
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            height: 35,
                            width: 35 * 3,
                            margin: EdgeInsets.only(right: 15, left: 10),
                            alignment: Alignment.center,
                            child: Text('Restroom 🚻', style: TextStyle(fontSize: 13),),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            height: 35,
                            width: 35 * 3,
                            margin: EdgeInsets.only(left: 20),
                            alignment: Alignment.center,
                            child: Text('Restroom 🚻', style: TextStyle(fontSize: 13),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Container(child: Text('Economy Class', style: TextStyle(fontSize: 16),),
                          width: double.infinity, alignment: Alignment.center),

                      ///Economy Class
                      Container(
                          padding: EdgeInsets.only(right: 5, bottom: 20, top: 15),
                          // padding: EdgeInsets.symmetric(horizontal: jetSpace * 0.02, vertical: 20),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: List.generate(economy_class_seats.length, (index) {
                              final seat = economy_class_seats[index];
                              return InkWell(
                                onTap: () {
                                  if(user_role == 'admin' || user_role == 'guest') {
                                    null;
                                  } else {
                                    toggleSeatSelection(seat);
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  margin: EdgeInsets.only(left: index%3==0 ? 17 : 0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: seat.isBooked ? Colors.grey
                                          : _selectedSeats.contains(seat) ? Colors.red : Colors.teal.shade300,
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Text('${seat.row}${String.fromCharCode(65 + seat.column)}',
                                    style: TextStyle(color: Colors.white, fontSize: 13),),
                                ),
                              );
                            }),
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            height: 35,
                            width: 35 * 3,
                            margin: EdgeInsets.only(right: 15, left: 10),
                            alignment: Alignment.center,
                            child: Text('Restroom 🚻', style: TextStyle(fontSize: 13),),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            height: 35,
                            width: 35 * 3,
                            margin: EdgeInsets.only(left: 20),
                            alignment: Alignment.center,
                            child: Text('Restroom 🚻', style: TextStyle(fontSize: 13),),
                          ),
                        ],
                      ),
                      SizedBox(height: 110)
                    ],
                  ),
                                  ),
                                ),
            ),

            // ///Side List For Demo
            // Container(
            //   height: 600,
            //   width: 300,
            //   color: Colors.pink,
            //   child: ListView.builder(
            //       itemCount: _selectedSeats.length,
            //       itemBuilder: (context, index) {
            //         List<Seat> seat = _selectedSeats.map((e) => e).toList();
            //         return Text('${seat[index].row}${String.fromCharCode(65 + seat[index].column)}',
            //           style: TextStyle(color: Colors.white, fontSize: 13),);
            //       }
            //   ),
            // )
          ],
        ),
      ),
      floatingActionButton:user_role == 'admin' || user_role == 'guest' ? SizedBox.shrink() : Container(
        width: 130,
        child: FloatingActionButton(
          heroTag: '10',
          hoverColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          backgroundColor: constants.appThemeColor300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Continue', style: TextStyle(fontSize: 20),),
              Icon(Icons.navigate_next_rounded, color: Colors.white,)
            ],
          ),
          onPressed: () => _selectedSeats.isNotEmpty
              ? showBookingDialog(flight_id: widget.fligh_id, user_id: widget.user_id)
              : constants.alertBox(title: 'Alert ', content: 'Please Select Seats To Book Flight.')
        ),
      ),
    );
  }

  ///BOOKING DIALOG
  void showBookingDialog({required String flight_id, required String user_id}) {
    showDialog(
      context: context,
      builder: (context) {
        List<Seat> seatList = _selectedSeats.map((e) => e).toList();

        List<TextEditingController> nameControllerList = List.generate(seatList.length, (i) => TextEditingController());
        List<TextEditingController> mobileNumberControllerList = List.generate(seatList.length, (i) => TextEditingController());
        List<TextEditingController> ageControllerList = List.generate(seatList.length, (i) => TextEditingController());
        // final List<GlobalObjectKey<FormState>> formKeyList = List.generate(seatList.length, (index) => GlobalObjectKey<FormState>(index));
        return AlertDialog(
          title: Text('Book Your Flight'),
          content: Form(
            key: formKey,
            child: Container(
              // height: 400,
              width: 400,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 30),
                shrinkWrap: true,
                itemCount: seatList.length,
                itemBuilder: (context, index) {
                  return formBox(
                      seat: seatList[index],
                      index: index,
                      nameController: nameControllerList[index],
                      mobileNumberController: mobileNumberControllerList[index],
                      ageController: ageControllerList[index]
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: 100,
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: constants.appThemeColor300,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(fontSize: 17),),
              ),
            ),
            SizedBox(
              width: 100,
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: constants.appThemeColor300,
                ),
                onPressed: () async {
                  List<Seat> seatList = _selectedSeats.map((e) => e).toList();
                  print('seatList ->> ${seatList}');
                  for(int j=0; j<seatList.length; j++) {
                    if(formKey.currentState!.validate()) {
                      await databaseService.addBOOKING(
                          user_id: user_id,
                          flight_id: flight_id,
                          booking_name: nameControllerList[j].text,
                          booking_contact: mobileNumberControllerList[j].text,
                          booking_seat: '${seatList[j].row} ${String.fromCharCode(65+seatList[j].column)}',
                          booking_class: seatList[j].seatClass,
                          booking_age: ageControllerList[j].text
                      ).whenComplete(() {
                        Get.to(BookedFlightsScreen());
                      });
                    }
                  }
                },
                child: Text('Book', style: TextStyle(fontSize: 17),),
              ),
            ),
          ],
        );
      },
    );
  }

  final formKey = GlobalKey<FormState>();

  formBox({
    required Seat seat,
    required int index,
    required TextEditingController nameController,
    required TextEditingController mobileNumberController,
    required TextEditingController ageController,
  }) {

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(' Passenger ${index + 1}', style: const TextStyle(fontSize: 17),),
          constants.textField(
            // height: 45,
            width: double.infinity,
            hintText: 'Name',
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          constants.textField(
            // height: 45,
            width: double.infinity,
            hintText: 'Contact Number',
            controller: mobileNumberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your contact number';
              }
              return null;
            },
          ),
          constants.textField(
            // height: 45,
            width: double.infinity,
            hintText: 'Seat Number: ${seat.row}${String.fromCharCode(65+seat.column)}',
            readOnly: true, validator: null
          ),
          constants.textField(
            // height: 45,
            width: double.infinity,
            hintText: 'Class: ${seat.seatClass}',
            readOnly: true, validator: null
          ),
          constants.textField(
            // height: 45,
            width: double.infinity,
            hintText: 'Age',
            controller: ageController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  int selectedToggleIndex = 0;

  Widget functionalityBox() {
    List<Color> lstColor = [Colors.blue.shade600, Colors.orange, Colors.teal.shade300];
    List<String> lstClass = ['First Class', 'Business Class', 'Economy Class'];

    return Container(
      height: 400,
      padding: EdgeInsets.only(top: 10, right: 180),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(decoration: BoxDecoration(color: Colors.grey, border: Border.all(color: Colors.black54)),
                  height: 17, width: 17),
              Text('  Locked Seat', style: TextStyle(fontSize: 17),),
              SizedBox(width: 50),
              Container(decoration: BoxDecoration(color: Colors.red, border: Border.all(color: Colors.black54)),
                  height: 17, width: 17),
              Text('  Booked Seat', style: TextStyle(fontSize: 17),),
            ],
          ),
          Container(
            width: 500,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text('Enter passenger number for auto seat allocation'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Passenger : ', style: TextStyle(fontSize: 16),),
                      Container(
                        height: 32,
                        width: 100,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
                        child: TextFormField(
                          controller: passengerController,
                          decoration: const InputDecoration(
                              hintText: '0',
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                              contentPadding: EdgeInsets.only(bottom: 10, left: 12)
                          ),
                          cursorColor: constants.appThemeColor300,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            maximumSelectedValue = 0;
                            // setState(() {
                              maximumSelectedValue = int.parse(value);
                            // });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text('Select Class', style: TextStyle(fontSize: 16),),
                  SizedBox(height: 10),
                  ToggleSwitch(
                    initialLabelIndex: selectedToggleIndex,
                    totalSwitches: 3,
                    customWidths: [120, 120, 120],
                    labels: ['First Class', 'Business Class', 'Economy Class'],
                    curve: Curves.bounceInOut,
                    animate: true,
                    activeBgColor: constants.toggleButtonColor,
                    inactiveBgColor: Colors.black12,
                    inactiveFgColor: Colors.black,
                    dividerColor: Colors.white,
                    dividerMargin: 3,
                    animationDuration: 100,
                    onToggle: (index) {
                      selectedToggleIndex = index ?? 0;
                      print('index ->> $index');
                      switch(index) {
                        case 0:
                          seatClass = SeatClass.firstClass;
                          break;
                        case 1:
                          seatClass = SeatClass.businessClass;
                          break;
                        case 2:
                          seatClass = SeatClass.economyClass;
                          break;
                      }
                      print('seatClass : ${seatClass}');
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 70,
                    child: ListView(
                      children: List.generate(lstColor.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                    color: lstColor[index],
                                    borderRadius: BorderRadius.circular(50)
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(lstClass[index])
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 180,
                        height: 40,
                        child: FloatingActionButton(
                          heroTag: '500',
                          hoverColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          backgroundColor: constants.appThemeColor300,
                          elevation: 0,
                          child: Text('Auto Seat Allocation'),
                          onPressed: () {
                            if(maximumSelectedValue > 6) {
                              constants.alertBox(title: 'Alert ', content: 'Maximum random seat limit is 6.');
                            } else {
                              if(seatClass == SeatClass.firstClass) {
                                randomAllocation(seatingClass: first_class_seats);
                              } else if(seatClass == SeatClass.businessClass) {
                                randomAllocation(seatingClass: business_class_seats);
                              } else {
                                randomAllocation(seatingClass: economy_class_seats);
                              }
                            }
                          }
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 100,
                        height: 40,
                        child: FloatingActionButton(
                          heroTag: '800',
                            hoverColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            backgroundColor: constants.appThemeColor300,
                            elevation: 0,
                            child: Text('Clear'),
                            onPressed: () {
                              if(seatClass == SeatClass.firstClass) {
                                clearAllSelection(seatingClass: first_class_seats);
                              } else if(seatClass == SeatClass.businessClass) {
                                clearAllSelection(seatingClass: business_class_seats);
                              } else {
                                clearAllSelection(seatingClass: economy_class_seats);
                              }
                            }
                        ),
                      ),
                      SizedBox(width: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
