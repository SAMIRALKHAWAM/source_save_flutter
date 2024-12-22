// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:source_safe/cubits/app/state.dart';
// import 'package:source_safe/network/cash_helper.dart';
// import 'package:source_safe/network/end_point.dart';
//
// import '../../../cubits/app/cubit.dart';
// import '../../cubits/admin/cubit.dart';
// import '../../cubits/admin/state.dart';
// import '../app/GroupDetailes.dart';
// import '../app/drawer.dart';
//
//
// class aHomeScreen extends StatefulWidget {
//   @override
//   _aHomeScreenState createState() => _aHomeScreenState();
// }
//
// class _aHomeScreenState extends State<aHomeScreen> {
//   List<int?> userIds = [];
//   List<int> perIds = [];
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isLargeScreen = screenWidth >= 800;
//     // AppCubit.get(context).get_permissions();
//     // AppCubit.get(context).get_groups();
//
//     final drawerContent = Drawer_App();
//
//     return BlocConsumer<adminCubit, adminSates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         return adminCubit.get(context).get_group == null
//             ? Center(
//           child: CircularProgressIndicator(),
//         )
//             : Scaffold(
//           appBar: AppBar(
//             title: Text('File Manager'),
//             backgroundColor: Colors.blue[800],
//             centerTitle: true,
//           ),
//           body: Row(
//             children: [
//               if (isLargeScreen)
//                 Container(
//                   color: Colors.blue[800],
//                   width: 250,
//                   child: drawerContent,
//                 ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Groups",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue[800],
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Expanded(
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             int crossAxisCount = 1;
//
//                             if (constraints.maxWidth >= 1200) {
//                               crossAxisCount = 4;
//                             } else if (constraints.maxWidth >= 800) {
//                               crossAxisCount = 3;
//                             } else if (constraints.maxWidth >= 600) {
//                               crossAxisCount = 2;
//                             }
//
//                             return GridView.builder(
//                               gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: crossAxisCount,
//                                 crossAxisSpacing: 16,
//                                 mainAxisSpacing: 16,
//                                 // childAspectRatio: 4,
//                               ),
//                               itemCount: adminCubit.get(context)
//                                   .get_group!
//                                   .data
//                                   .length,
//                               itemBuilder: (context, index) {
//                                 return Card(
//                                   elevation: 4,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(10),
//                                   ),
//                                   child: ListTile(
//                                     title: Text(
//                                       adminCubit.get(context)
//                                           .get_group!
//                                           .data[index]
//                                           .name,
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     trailing: Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: Colors.blue[800],
//                                       size: 18,
//                                     ),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               GroupDetailsScreen(
//                                                 groupName:
//                                                 adminCubit.get(context)
//                                                     .get_group!
//                                                     .data[index]
//                                                     .name,
//                                                 isAdmin: true,
//                                                 groupId: adminCubit.get(context)
//                                                     .get_group!
//                                                     .data[index]
//                                                     .id,
//                                               ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           drawer: isLargeScreen
//               ? null
//               : Drawer(
//             child: drawerContent,
//           ),
//           floatingActionButton: FloatingActionButton(
//             backgroundColor: Colors.blue[800],
//             child: Icon(Icons.group_add_rounded),
//             onPressed: () {
//               _showCreateGroupDialog(context);
//               AppCubit.get(context).getUsers();
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   void _showCreateGroupDialog(BuildContext context) {
//     final TextEditingController searchController = TextEditingController();
//     userIds.clear();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return BlocConsumer<AppCubit, AppSates>(
//           listener: (BuildContext context, AppSates state) {},
//           builder: (BuildContext context, AppSates state) {
//             return AlertDialog(
//               title: Text("create group "),
//               content: Container(
//                 width: double.maxFinite,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: searchController,
//                       decoration: InputDecoration(
//                         labelText: "serch member",
//                         prefixIcon: Icon(Icons.search),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           AppCubit.get(context).serch_name(value);
//                         });
//                       },
//                     ),
//                     SizedBox(height: 8),
//                     Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount:
//                         AppCubit.get(context).searchResults!.length,
//                         itemBuilder: (context, index) {
//                           int? userId = AppCubit.get(context)
//                               .searchResults![index]
//                               .id;
//
//                           return ListTile(
//                             title: Container(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 15),
//                               decoration: BoxDecoration(
//                                 color: userIds.contains(userId)
//                                     ? Color(0x80A8E6A0)
//                                     : Colors.white38,
//                                 borderRadius: BorderRadius.only(
//                                   bottomRight: Radius.circular(12),
//                                   topRight: Radius.circular(12),
//                                 ),
//                               ),
//                               child: Text(
//                                 AppCubit.get(context)
//                                     .searchResults![index]
//                                     .name
//                                     .toString(),
//                                 style: TextStyle(),
//                               ),
//                             ),
//                             onTap: () {
//                               // userIds.add(AppCubit.get(context).getUsersearch![index].id);
//
//                               setState(() {
//                                 // إضافة الـ id إلى مصفوفة userIds إذا لم يكن موجودًا بالفعل
//                                 if (!userIds.contains(userId)) {
//                                   userIds.add(
//                                       userId); // إضافة الـ userId إلى المصفوفة
//                                 } else
//                                   userIds.remove(userId);
//                               });
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             );
//           },
//         );
//       },
//     );
//   }
//
//
// }
