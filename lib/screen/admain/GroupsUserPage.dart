import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/cubit.dart';
import 'package:source_safe/cubits/admin/state.dart';
import 'package:source_safe/screen/admain/UserDetails.dart';


// واجهة تعرض المجموعات الخاصة بالمستخدم
class GroupsUserPage extends StatefulWidget {
  final dynamic userId; // معرف المستخدم الذي ستعرض له المجموعات

  final dynamic userName; // معرف المستخدم الذي ستعرض له المجموعات

  GroupsUserPage({required this.userId,required this.userName});

  @override
  _GroupsUserPageState createState() => _GroupsUserPageState();
}

class _GroupsUserPageState extends State<GroupsUserPage> {
  @override
  Widget build(BuildContext context) {
    adminCubit.get(context).get_groups_user(id: widget.userId);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 800;
    return BlocConsumer<adminCubit, adminSates>(
      listener: (BuildContext context, state) {},
      builder: (context, state) {
        if(state is LoadingState )
          return Center(child: CircularProgressIndicator());

        else
        if (adminCubit.get(context).getgroupsuser != null) {
          var groups = adminCubit.get(context).getgroupsuser!.data;
          return Scaffold(
            appBar: AppBar(
              title: Text("${widget.userName}'s Group".tr()),
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
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(

                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDetailPage(
                                    groupeId: groups[index].id,
                                    userId: widget.userId,
                                    userName: widget.userName,
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
                                groups[index].name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle:
                              Text(groups[index].isAdmin?"is admin".tr():"",style: TextStyle(textBaseline: TextBaseline.ideographic),)


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
