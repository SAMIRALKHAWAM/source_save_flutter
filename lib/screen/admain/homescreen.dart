import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/state.dart';
import 'package:source_safe/main.dart';
import '../../cubits/admin/cubit.dart';
import '../../cubits/regester/cubit.dart';
import '../../cubits/regester/state.dart';
import '../../cubits/theme/theme_cubit.dart';
import '../../network/cash_helper.dart';
import '../regester/login.dart';
import 'GroupsUserPage.dart';
import 'UsersGroupPage.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _showUsers = false; // لتحديد إذا كان يجب عرض صفحة المستخدمين

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // تعيين التاب بار للغروبات فقط
    _Local();
  }

  void _Local() {
    adminCubit.get(context).get_groups();
    adminCubit.get(context).get_groups_p();
    adminCubit.get(context).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 800;
    // adminCubit.get(context).get_groups();
    // adminCubit.get(context).get_groups_p();

    return BlocConsumer<adminCubit, adminSates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('ِAdmin System'.tr()),
            backgroundColor: Colors.purple[800],
            centerTitle: true,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: isLargeScreen
                  ? BorderRadius.zero
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
            ),
          ),
          body: Row(
            children: [
              if (isLargeScreen)
                Container(
                  color: Colors.purple[800],
                  width: 250,
                  child: _buildDrawerContent(isLargeScreen),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // هنا نقلنا الـ TabBar إلى الـ Body بدلاً من الـ AppBar
                      if (!_showUsers) // إذا لم نعرض المستخدمين، نعرض التاب بار
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(text: 'All Groups'.tr()), // أول تاب للغروبات
                            Tab(
                                text:
                                    'Processed Groups'.tr()), // ثاني تاب للغروبات المعالجة
                          ],
                          labelColor: Colors.black, // تغيير اللون إلى أسود
                          unselectedLabelColor: Colors.black45,
                        ),
                      Expanded(
                        child: _showUsers
                            ? _buildUsersTab()
                            : TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildGroupsTab(),
                                  _buildProcessedGroupsTab(),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: isLargeScreen ? null : Drawer(child: _buildDrawerContent(isLargeScreen)),
        );
      },
    );
  }

  Widget _buildGroupsTab() {
    return BlocConsumer<adminCubit, adminSates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        if (adminCubit.get(context).get_group != null&& state is! LoadingState) {
          var groups = adminCubit.get(context).get_group!.data;

          if (groups.isEmpty) {
            return Center(child: Text("No groups available".tr()));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsersGroupPage(
                                groupId: groups[index].id,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            groups[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple[800],
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.purple[800],
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildProcessedGroupsTab() {
    return adminCubit.get(context).get_group_p != null
        ? BlocConsumer<adminCubit,adminSates>(
          listener: (BuildContext context, state) {  },
          builder: (BuildContext context,  state) {
            return state is! LoadingState
              ?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //   crossAxisCount: 2,
                    //   crossAxisSpacing: 16,
                    //   mainAxisSpacing: 16,
                    //   childAspectRatio: 1.1,
                    // ),
                    itemCount: adminCubit.get(context).get_group_p!.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: ListTile(
                            title: Text(
                              adminCubit
                                  .get(context)
                                  .get_group_p!
                                  .data[index]
                                  .name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.purple[800],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {


                                      adminCubit.get(context).change_status(
                                          status: "accepted",
                                          groupId: adminCubit
                                              .get(context)
                                              .get_group_p!
                                              .data[index]
                                              .id);

                                      print("accepted");


                                    });

                                                },
                                  child: Text("accept".tr()),
                                ),
                                SizedBox(width: 5),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      adminCubit.get(context).change_status(
                                          status: "rejected",
                                          groupId: adminCubit
                                              .get(context)
                                              .get_group_p!
                                              .data[index]
                                              .id);
                                      _Local();
                                    });

                                    // AppCubit.get(context).change_file_status(
                                    //     status: "rejected ",
                                    //     fileId: AppCubit.get(context)
                                    //         .get_file_pending!
                                    //         .data[index]
                                    //         .id);
                                    // print('rejected');
                                    // AppCubit.get(context)
                                    //     .get_file_pe(id_group: widget.groupId);
                                  },
                                  child: Text("rejected".tr()),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
                : Center(child: Text("No processed groups available".tr()));

          },

        )
        : Center(child: Text("No processed groups available".tr()));
  }

  Widget _buildUsersTab() {
    return BlocConsumer<adminCubit, adminSates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (adminCubit.get(context).getUser != null) {
          var users = adminCubit.get(context).getUser?.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: users?.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupsUserPage(
                            userId: users![index].id, userName: users![index].name,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        users?[index].name ?? "No Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(users?[index].email ?? "No Email"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: Text("Unhandled state: $state"));
        }
      },
    );
  }

  Widget _buildDrawerContent(dynamic isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.purple[800],
          ),
          child: Center(
            child: Text(
              "Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.group,
            color: _selectedIndex == 0 ? Colors.black : Colors.white,
          ),
          title: Text(
            "Groups".tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _selectedIndex == 0 ? Colors.black : Colors.white,
            ),
          ),
          onTap: () {
            isLargeScreen ? null : Navigator.pop(context); // إغلاق الدروار بعد الضغط


            setState(() {
              _selectedIndex = 0;
              _showUsers = false; // إذا كان نعرض المجموعات وليس المستخدمين
            });
          },
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: _selectedIndex == 1 ? Colors.black : Colors.white,
          ),
          title: Text(
            "Users".tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _selectedIndex == 1 ? Colors.black : Colors.white,
            ),
          ),
          onTap: () {

            isLargeScreen ? null : Navigator.pop(context); // إغلاق الدروار بعد الضغط



            setState(() {
              _selectedIndex = 1;
              _showUsers = true; // إذا كان نعرض المستخدمين
            });
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
