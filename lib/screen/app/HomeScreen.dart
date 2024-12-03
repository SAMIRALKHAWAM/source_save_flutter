import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/app/state.dart';

import '../../cubits/app/cubit.dart';
import '../../cubits/regester/cubit.dart';
import '../../cubits/regester/state.dart';
import '../regester/login.dart';
import 'GroupDetailes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> groups = ['Group A', 'Group B', 'Group C', 'Group D'];
  List<int?> userIds = [];
  List<int> perIds = [];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 800;
    AppCubit.get(context).get_permissions();
    AppCubit.get(context).get_groups();

    final drawerContent = ListView(
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
              print("we are going to login screen");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
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
                registerCubit.get(context).log_out();
              },
            );
          },
        ),
      ],
    );

    return AppCubit.get(context).get_group == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('File Manager'),
              backgroundColor: Colors.blue[800],
              centerTitle: true,
            ),
            body: Row(
              children: [
                if (isLargeScreen)
                  Container(
                    color: Colors.blue[800],
                    width: 250,
                    child: drawerContent,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Groups",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = 1;

                              if (constraints.maxWidth >= 1200) {
                                crossAxisCount = 4;
                              } else if (constraints.maxWidth >= 800) {
                                crossAxisCount = 3;
                              } else if (constraints.maxWidth >= 600) {
                                crossAxisCount = 2;
                              }

                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 4,
                                ),
                                itemCount: AppCubit.get(context)
                                    .get_group!
                                    .data
                                    .length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        AppCubit.get(context)
                                            .get_group!
                                            .data[index]
                                            .name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.blue[800],
                                        size: 18,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GroupDetailsScreen(
                                              groupName: groups[index],
                                              isAdmin: true,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            drawer: isLargeScreen
                ? null
                : Drawer(
                    child: drawerContent,
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue[800],
              child: Icon(Icons.group_add_rounded),
              onPressed: () {
                _showCreateGroupDialog(context);
                AppCubit.get(context).getUsers();
              },
            ),
          );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    List<String> allMembers = [
      'محمد',
      'أحمد',
      'فاطمة',
      'سارة',
      'يوسف',
      'علي',
      'sara'
    ];
    List<String> filteredMembers = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<AppCubit, AppSates>(
          listener: (BuildContext context, AppSates state) {},
          builder: (BuildContext context, AppSates state) {
            return AppCubit.get(context).getUsersearch != null
                ? AlertDialog(
                    title: Text("create group "),
                    content: Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              labelText: "serch member",
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                AppCubit.get(context).serch_name(value);
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  AppCubit.get(context).searchResults!.length,
                              itemBuilder: (context, index) {
                                int? userId = AppCubit.get(context)
                                    .searchResults![index]
                                    .id;

                                return ListTile(
                                  title: Container(
                                    padding: EdgeInsets.only(
                                        left: 5.0,
                                        right: 5,
                                        top: 5), // لإضافة مسافة حول النص
                                    decoration: BoxDecoration(
                                      color: userIds.contains(userId)
                                          ? Color(0x80A8E6A0)
                                          : Colors
                                              .white38, // لون الخلفية الأحمر
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      AppCubit.get(context)
                                          .searchResults![index]
                                          .name
                                          .toString(),
                                      style: TextStyle(
                                          // color: userIds.contains(userId) ? Colors.green : Colors.black, // تغيير اللون هنا
                                          ),
                                    ),
                                  ),
                                  onTap: () {
                                    // userIds.add(AppCubit.get(context).getUsersearch![index].id);

                                    setState(() {
                                      // إضافة الـ id إلى مصفوفة userIds إذا لم يكن موجودًا بالفعل
                                      if (!userIds.contains(userId)) {
                                        userIds.add(
                                            userId); // إضافة الـ userId إلى المصفوفة
                                      } else
                                        userIds.remove(userId);
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showNameGroupDialog(context);
                          // String groupName = groupNameController.text;
                          // String members = membersController.text;
                          // // هنا يمكنك إضافة الكود لمعالجة البيانات المدخلة
                          // print("اسم المجموعة: $groupName");
                          // print("أسماء الأعضاء: $members");
                          // Navigator.of(context).pop();
                        },
                        child: Text(" Next "),
                      ),
                    ],
                  )
                : AlertDialog(
                    title: Text("Create Group"),
                    content: Center(
                        child:
                            CircularProgressIndicator()), // عرض دائرة التحميل
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  );
          },
        );
      },
    );
  }

  void _showNameGroupDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<AppCubit, AppSates>(
          listener: (BuildContext context, AppSates state) {
            if (state is add_groupSuccessState) {
              AppCubit.get(context).get_groups();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
          builder: (BuildContext context, AppSates state) {
            return AlertDialog(
              title: Text("create group"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "name",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppCubit.get(context).add_group(
                        name: nameController.text,
                        userId: userIds,
                        perId: [1, 2, 3]);
                  },
                  child: Text(" Done "),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
