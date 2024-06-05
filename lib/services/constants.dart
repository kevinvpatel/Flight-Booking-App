import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Login {user, staff, admin}

class Constants {


  Color appThemeColor100 = Colors.blue.shade100;
  Color appThemeColor200 = Colors.blue.shade200;
  Color appThemeColor300 = Colors.blue.shade300;
  List<Color> toggleButtonColor = [Colors.blue.shade200,Colors.blue.shade300];
  // double screenWidth = 800;

  Color baclgroundColor = Colors.white54;

  Widget drawer({
    required Function() onTap1,
    required Function() onTap2,
    required String userName,
    required String userEmail,
  }) {
    userName == '' ? userName = 'guest login' : userName;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: appThemeColor300,
              child: Text(userName[0].toString().toUpperCase(), style: TextStyle(fontSize: 40)),
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.airplane), title: Text("Flights List"),
            onTap: onTap1,
          ),
          Divider(),
          userName == 'guest login' ? SizedBox.shrink() : ListTile(
            leading: Icon(CupertinoIcons.bookmark), title: Text("My Bookings"),
            onTap: onTap2,
          ),
        ],
      ),
    );
  }

  Widget textField({
    required String hintText,
    bool? obsecureText,
    Function(String)? onChanged,
    Function()? onTap,
    required String? Function(String?)? validator,
    TextEditingController? controller,
    Color? cursorColor,
    double? height,
    double? width,
    double radius = 15,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    EdgeInsets contentPadding = const EdgeInsets.all(10),
  }) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
            color: Colors.white,
            border: Border.all(color: Colors.white),
        ),
        margin: EdgeInsets.all(5),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: contentPadding),
          cursorColor: cursorColor ?? appThemeColor300,
          keyboardType: keyboardType,
          obscureText: obsecureText ?? false,
          validator: validator,
          readOnly: readOnly,
          onChanged: onChanged,
          onTap: onTap,
        ),
      );
  }

  alertBox({required String title, required String content}) {
    Get.defaultDialog(
        title: '',
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 35),
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: Colors.red.shade600, fontSize: 25),),
                Icon(Icons.error_outline, color: Colors.red.shade600, size: 25,)
              ],
            ),
            SizedBox(height: 25),
            Text(content,
              style: TextStyle(fontSize: 18),),
            SizedBox(height: 15),
          ],
        )
    );
  }

}