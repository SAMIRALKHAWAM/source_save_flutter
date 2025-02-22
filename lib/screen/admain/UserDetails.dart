import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/state.dart';
import '../../cubits/admin/cubit.dart';
import '../../cubits/app/cubit.dart';
import '../../cubits/app/state.dart';
import '../../models/get_file_model.dart';

class UserDetailPage extends StatefulWidget {
  final dynamic userId;
  final dynamic groupeId;
  dynamic userName;

  UserDetailPage({required this.userId, required this.groupeId,required this.userName});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadUserFiles();
  }

  void _loadUserFiles() {
    adminCubit.get(context).get_file_user(
      userId: widget.userId,
      f_r: "free",
      groupeId: widget.groupeId,
    );
    adminCubit.get(context).get_file_user(
      userId: widget.userId,
      f_r: "reserved",
      groupeId: widget.groupeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<adminCubit, adminSates>(
      listener: (BuildContext context, state) {
        // يمكن إضافة ردود الفعل عند التغيير في الحالة إذا لزم الأمر
      },
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade700,
            title: Text('${widget.userName}\'s Files'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              adminCubit.get(context).get_file_user_ingroup_reserved!=null?


              ListView(
                children: [
                  _buildUserHeader(),
                  SizedBox(height: 20),
                  _buildExpansionTile('Reserved Files'.tr(), adminCubit.get(context).get_file_user_ingroup_reserved, "reserved"),
                  _buildExpansionTile('Free Files'.tr(), adminCubit.get(context).get_file_user_ingroup_free, "free"),
                ],
              )
                  :        Center(child: CircularProgressIndicator())


          ),
        );
      },
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade300,
          child: Text(
            widget.userName.toString().substring(0, 1), // أول حرف من الاسم
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(width: 20),
        Text(
          '${widget.userName}!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
        ),
      ],
    );
  }

  // دالة لإنشاء ExpansionTile مع قائمة من الملفات
  Widget _buildExpansionTile(String title, dynamic fileList, String status) {

    // استخراج البيانات من الملف إذا كانت موجودة
    List<dynamic> files = fileList.data ?? [];  // التأكد من أن data موجودة

    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blue.shade50,
      child: ExpansionTile(
        iconColor: Colors.blue.shade700,
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blue.shade700),
        ),
        children: files.isEmpty
            ? [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No files available.'.tr(),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
        ]
            : files.map<Widget>((file) {
          return ListTile(
            title: Text(file.name ?? '', style: TextStyle(fontSize: 16, color: Colors.black87)),
            trailing: Icon(Icons.file_download, color: Colors.blue),
            // subtitle: file.modified == 'Yes'
            //     ? Text('Modifications: ${file.modifications ?? ''}', style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
            //     : null,
          );
        }).toList(),
      ),
    );
  }
}
