import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/regester/cubit.dart';
import '../../cubits/regester/state.dart';
import '../../network/cash_helper.dart';
import '../regester/login.dart';

class Drawer_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[700],  // اللون المتناسق مع AppBar
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header of the Drawer
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple[600],  // نفس اللون كـ AppBar
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.deepPurple[600],
                    size: 40,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Implement navigation if necessary
            },
          ),

          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Implement settings screen navigation if necessary
            },
          ),

          // Logout Section with BlocConsumer
          BlocConsumer<registerCubit, registerSates>(
            listener: (BuildContext context, registerSates state) {
              if (state is LogoutSuccessState) {
                // Handle Logout state if necessary
              }
            },
            builder: (BuildContext context, registerSates state) {
              return ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  openlogoutDialog(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Logout Confirmation Dialog
  openlogoutDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: AlertDialog(
            title: Row(
              children: [
                Center(child: Text('Confirmation')),
              ],
            ),
            content: Text('Are you sure you want to logout?'),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Log out'),
                onPressed: () {
                  registerCubit.get(context).log_out();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                  CachHelper.removeData(key: "token");
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
