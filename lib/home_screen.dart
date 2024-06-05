import 'package:flight_booking_algorithm/Booked_Flight/booked_flight_list_screen.dart';
import 'package:flight_booking_algorithm/Flight_List/flight_list_screen.dart';
import 'package:flight_booking_algorithm/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _page = 0;

  List drawerItems = [
    {
      "icon": CupertinoIcons.home,
      "name": "Flights List",
    },
    {
      "icon": CupertinoIcons.bookmark,
      "name": "My Bookings",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Constants constants = Constants();

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Kevin'),
              accountEmail: Text('accountEmail'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: constants.appThemeColor300,
                child: Text('K', style: TextStyle(fontSize: 40)),
              ),
            ),
            ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: drawerItems.length,
              itemBuilder: (BuildContext context, int index) {
                Map item = drawerItems[index];
                return ListTile(
                  leading: Icon(
                    item['icon'],
                  ),
                  title: Text(
                    item['name'],
                  ),
                  onTap: (){
                    _pageController.jumpToPage(index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          FlightListScreen(),
          BookedFlightsScreen()
        ],
      ),
    );
  }
}
