import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/cubit.dart';
import 'package:source_safe/cubits/admin/state.dart';
import 'package:source_safe/screen/admain/UserDetails.dart';


// واجهة تعرض المجموعات الخاصة بالمستخدم
class UsersGroupPage extends StatefulWidget {
  final dynamic groupId; // معرف المستخدم الذي ستعرض له المجموعات

  UsersGroupPage({required this.groupId});

  @override
  _UsersGroupPageState createState() => _UsersGroupPageState();
}

class _UsersGroupPageState extends State<UsersGroupPage> {
  @override
  Widget build(BuildContext context) {
    adminCubit.get(context).get_users_group(id: widget.groupId);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 800;
    return BlocConsumer<adminCubit, adminSates>(
      listener: (BuildContext context, state) {},
      builder: (context, state) {
        if (adminCubit.get(context).getUsergroup != null) {
          var Users = adminCubit.get(context).getUsergroup!.data;
          return Scaffold(
            appBar: AppBar(
              title: Text("Users's Group".tr()),
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: Users.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDetailPage(
                                        userId: Users[index].userId,
                                        groupeId: widget.groupId,
                                        userName: Users[index].userName,
                                      )),
                            );
                          },
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: Text(
                                Users[index].userName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Users[index].userEmail ?? "No Email"),
                                  Text(
                                    Users[index].isAdmin == 1 ? "is admin".tr() : "",
                                    style: TextStyle(
                                        textBaseline: TextBaseline.ideographic),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // عرض قائمة المجموعات فقط إذا لم يتم تحديد مجموعة
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
