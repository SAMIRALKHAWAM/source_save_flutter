import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/regester/cubit.dart';
import '../../cubits/regester/state.dart';
import '../../cubits/theme/theme_cubit.dart';
import '../../network/cash_helper.dart';
import '../regester/login.dart';

class Drawer_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.purple[800],  // اللون المتناسق مع AppBar
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header of the Drawer
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple[800],  // نفس اللون كـ AppBar
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
                    color: Colors.purple[800],
                    size: 40,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome!'.tr(),
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
              'Home'.tr(),
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Implement navigation if necessary
            },
          ),

          ListTile(
              leading: Icon(Icons.language),
              title: Text(
                "Change Language".tr(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                if (context.locale.languageCode == 'ar') {
                  await context.setLocale(const Locale('en'));
                } else {
                  await context.setLocale(const Locale('ar'));
                }
              }),
          ListTile(
            leading: Icon(
              BlocProvider.of<ThemeCubit>(context).isDark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            title: Text(
              'theme'.tr(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              // عند الضغط على Settings، تغيير الثيم
              BlocProvider.of<ThemeCubit>(context).switchTheme();
              // Navigator.pop(context); // إغلاق الـ Drawer بعد التغيير
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
                  'Logout'.tr(),
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
