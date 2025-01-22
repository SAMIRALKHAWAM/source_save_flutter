import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/app/cubit.dart';
import 'package:source_safe/cubits/app/state.dart';

import 'GroupDetailes.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int?> userIds = [];
  List<int> perIds = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 800;
    AppCubit.get(context).get_groups();
    final drawerContent = Drawer_App();

    return BlocConsumer<AppCubit, AppSates>(
      listener: (context, state) {},
      builder: (context, state) {
        return AppCubit.get(context).get_group == null
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: AppBar(
              title: Text('File Manager'),
              backgroundColor: Colors.deepPurple[600],
              centerTitle: true,
              elevation: 5.0,
              // Modify shape based on screen size
              shape: isLargeScreen
                  ? RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              )
                  : RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          body: Row(
            children: [
              if (isLargeScreen)
                Container(
                  color: Colors.deepPurple[600],
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
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[600],
                          letterSpacing: 1.2,
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
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.1,
                              ),
                              itemCount: AppCubit.get(context).get_group!.data.length,
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
                                          builder: (context) => GroupDetailsScreen(
                                            groupName: AppCubit.get(context)
                                                .get_group!
                                                .data[index]
                                                .name,
                                            isAdmin: AppCubit.get(context)
                                                .get_group!
                                                .data[index]
                                                .isAdmin,
                                            groupId: AppCubit.get(context)
                                                .get_group!
                                                .data[index]
                                                .id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(
                                        AppCubit.get(context)
                                            .get_group!
                                            .data[index]
                                            .name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.deepPurple[600],
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.deepPurple[600],
                                        size: 20,
                                      ),
                                    ),
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
          drawer: isLargeScreen ? null : Drawer(child: drawerContent),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple[600],
            child: Icon(Icons.group_add_rounded,color: Colors.white,),
            onPressed: () {
              _showCreateGroupDialog(context);
              AppCubit.get(context).getUsers();
            },
          ),
        );
      },
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    userIds.clear();

    // استخدام MediaQuery للحصول على عرض الشاشة
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<AppCubit, AppSates>(
          listener: (BuildContext context, AppSates state) {},
          builder: (BuildContext context, AppSates state) {
            return AppCubit.get(context).getUsersearch != null
                ? AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Create Group",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],  // اللون الأزرق المستخدم
                ),
              ),
              content: Container(
                width: screenWidth > 800 ? 500 : double.maxFinite, // تحديد العرض بناءً على حجم الشاشة
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search TextField
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: "Search Member",
                        labelStyle: TextStyle(color: Colors.blue[800]),
                        prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue[800]!,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          AppCubit.get(context).serch_name(value);
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Search Results
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: AppCubit.get(context).searchResults!.length,
                        itemBuilder: (context, index) {
                          int? userId = AppCubit.get(context)
                              .searchResults[index]
                              .id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!userIds.contains(userId)) {
                                  userIds.add(userId); // Add userId
                                } else {
                                  userIds.remove(userId); // Remove userId
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: userIds.contains(userId)
                                    ? Colors.blue.withOpacity(0.2)  // خلفية زرقاء فاتحة
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.01),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    userIds.contains(userId)
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    color: userIds.contains(userId)
                                        ? Colors.blue[800]
                                        : Colors.grey,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    AppCubit.get(context).searchResults[index].name.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (userIds.isEmpty) {
                      // عرض تحذير في حال لم يتم اختيار أي شخص
                      _showNoMembersSelectedDialog(context);
                    } else {
                      Navigator.of(context).pop();
                      _showNameGroupDialog(context);
                    }
                  },
                  child: Text("Next",style:TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],  // اللون الأزرق المستخدم
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            )
                : AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text("Create Group"),
              content: Center(
                child: CircularProgressIndicator(),
              ),
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

// عرض رسالة تحذير في حال لم يتم اختيار أي شخص
  void _showNoMembersSelectedDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("No Members Selected"),
          content: Container(
            width: screenWidth > 800 ? 500 : double.maxFinite, // تحديد العرض بناءً على حجم الشاشة
            child: Text("Please select at least one member to create the group."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


  void _showNameGroupDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Create Group",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800], // اللون الأزرق المستخدم
                ),
              ),
              content: Container(
                width: screenWidth > 800 ? 500 : double.maxFinite, // تحديد العرض بناءً على حجم الشاشة
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TextField for Group Name
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Group Name",
                        labelStyle: TextStyle(color: Colors.blue[800]),
                        prefixIcon: Icon(Icons.group, color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue[800]!,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppCubit.get(context).add_group(
                      name: nameController.text,
                      userId: userIds,
                      perId: [1, 2, 3],
                    );
                    AppCubit.get(context).get_groups();
                  },
                  child: Text("Done",style:TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],  // اللون الأزرق المستخدم
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
