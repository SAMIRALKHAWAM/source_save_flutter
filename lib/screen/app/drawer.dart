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
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue[800],
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () {},
        ),
        BlocConsumer<registerCubit, registerSates>(
          listener: (BuildContext context, registerSates state) {
            if (state is LogoutSuccessState) {
              // CachHelper.removeData(key: "token");
              // print("we are going to login screen");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Login()),
              // );
            }
          },
          builder: (BuildContext context, registerSates state) {
            return ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {

                openlogoutDialog(context);

              },
            );
          },
        ),
      ],
    );
  }



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
            // backgroundColor: ColorApp.colorback,
            title: Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 5, right: 5),
                //   child: Icon(
                //     Icons.logou,
                //     color: ColorApp.color2,
                //     size: 18,
                //   ),
                // ),
                Center(child: Text('Confirmation')),
              ],
            ),
            content: Text('Are you sure you want to logout?'),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
            actions: [
              TextButton(
                  child:Text( 'Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
              child:Text('Log out'),

                  onPressed: () {

                    registerCubit.get(context).log_out();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                    CachHelper.removeData(key: "token");

                  })
            ],
          ),
        );
      },
    );
  }




}
