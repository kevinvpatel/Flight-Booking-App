import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final db_users = FirebaseFirestore.instance.collection('users');
  final db_flights = FirebaseFirestore.instance.collection('flights');
  final db_bookings = FirebaseFirestore.instance.collection('bookings');

  /// Create Users
  Future<void> addUsers({
    required String user_name,
    required String user_email,
    required String user_password,
    required String user_role,
  }) async {
    final docRef = db_users.doc();
    await docRef.set({
      'user_id' : docRef.id,
      'user_name' : user_name,
      'user_email' : user_email,
      'user_password' : user_password,
      'user_role' : user_role,
    }).then((value) => print('addUsers successfully'), onError: (e) => print('addUsers error -> $e'));
  }

  // Read Users
  Stream<QuerySnapshot> getUsers() {
    CollectionReference collectionReference = db_users;
    return collectionReference.snapshots();
    // Map<String, dynamic> data = {};
    // db.collection(dbName).doc(docName).get().then((DocumentSnapshot doc) {
    //   data = doc.data() as Map<String, dynamic>;
    // }, onError: (e) => print('addItem error -> $e'));
    // return data;
  }

  // Update Users
  updateUsers({required String docId, required Map<String, dynamic> data}) async {
    db_users.doc(docId).update(data).then((value) {
      print('Firebase item updated successfully');
    }, onError: (e) => print('Firebase update error -> $e'));
  }

  // Delete Users
  deleteUsers({required String docId}) async {
    db_users.doc(docId).delete().then((value) {
      print('Firebase Item Deleted Successfully');
    }, onError: (e) => print('Firebase Delete Error -> $e'));
  }


  ///FLIGHT DEPARTMENT

  /// Create Flights
  Future<void> addFlights({
    required String flight_name,
    required String flight_route,
    required String flight_departure_time,
    required String flight_arrival_time,
    required String total_seats,
  }) async {
    final docRef = db_flights.doc();
    await docRef.set({
      'flight_id' : docRef.id,
      'flight_name' : flight_name,
      'flight_route' : flight_route,
      'flight_departure_time' : flight_departure_time,
      'flight_arrival_time' : flight_arrival_time,
      'total_seats' : total_seats,
    }).then((value) => print('addFlights successfully'), onError: (e) => print('addFlights error -> $e'));
  }

  /// Read Flights
  Stream<QuerySnapshot> getFlights() {
    CollectionReference collectionReference = db_flights;
    return collectionReference.snapshots();
  }

  /// Update flights
  updateFlights({
    required String docId,
    required String flight_name,
    required String flight_route,
    required String flight_departure_time,
    required String flight_arrival_time,
    required String total_seats,
  }) async {
    final docRef = db_flights.doc(docId);
    print('updating flight');
    print('docId -> $docId');
    print('flight_name -> $flight_name');
    print('flight_route -> $flight_route');
    print('flight_departure_time -> $flight_departure_time');
    print('flight_arrival_time -> $flight_arrival_time');
    print('total_seats -> $total_seats');
    await docRef.update({
      'flight_id' : docId,
      'flight_name' : flight_name,
      'flight_route' : flight_route,
      'flight_departure_time' : flight_departure_time,
      'flight_arrival_time' : flight_arrival_time,
      'total_seats' : total_seats,
    }).then((value) {
      print('Firebase item updated successfully');
    }, onError: (e) => print('Firebase update error -> $e'));
  }

  /// Delete Flights
  deleteFlights({required String docId}) async {
    db_flights.doc(docId).delete().then((value) {
      print('Firebase Item Deleted Successfully');
    }, onError: (e) => print('Firebase Delete Error -> $e'));
  }


  ///BOOKING DEPARTMENT

  /// Create BOOKING
  Future<void> addBOOKING({
    required String user_id,
    // required Map<String, dynamic> seat_data,
    required String flight_id,
    required String booking_name,
    required String booking_contact,
    required String booking_seat,
    required String booking_class,
    required String booking_age,
  }) async {
    final docRef = db_bookings.doc();
    await docRef.set({
      'booking_id' : docRef.id,
      'user_id' : user_id,
      'flight_id' : flight_id,
      'booking_name' : booking_name,
      'booking_contact' : booking_contact,
      'booking_seat' : booking_seat,
      'booking_class' : booking_class,
      'booking_age' : booking_age,
    }).then((value) => print('addBOOKING successfully'), onError: (e) => print('addBOOKING error -> $e'));
  }

  /// Read ALL Flights
  Stream<QuerySnapshot> getAllBOOKING() {
    CollectionReference collectionReference = db_bookings;
    return collectionReference.snapshots();
  }

  /// Read User Flights
  Stream<QuerySnapshot> getUserBOOKING({required String user_id}) {
    final collectionReference = db_bookings.where('user_id', isEqualTo: user_id).get();
    return collectionReference.asStream();
  }

  /// Update BOOKING
  Future updateBOOKING({
    required String docId,
    required String user_id,
    required String flight_id,
    required String booking_name,
    required String booking_contact,
    required String booking_seat,
    required String booking_class,
    required String booking_age,
  }) async {
    final docRef = db_bookings.doc(docId);
    await docRef.update({
      'booking_id' : docRef.id,
      'user_id' : user_id,
      'flight_id' : flight_id,
      'booking_name' : booking_name,
      'booking_contact' : booking_contact,
      'booking_seat' : booking_seat,
      'booking_class' : booking_class,
      'booking_age' : booking_age,
    }).then((value) {
      print('Firebase BOOKING updated successfully');
    }, onError: (e) => print('Firebase BOOKING update error -> $e'));
  }

  /// Delete BOOKING
  deleteBOOKING({required String docId}) async {
    db_bookings.doc(docId).delete().then((value) {
      print('Firebase BOOKING Deleted Successfully');
    }, onError: (e) => print('Firebase BOOKING Delete Error -> $e'));
  }

}