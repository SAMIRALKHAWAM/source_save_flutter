import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    AppCubit.get(context).get_file_user(
      userId: widget.userId,
      f_r: "free",
      groupeId: widget.groupeId,
    );
    AppCubit.get(context).get_file_user(
      userId: widget.userId,
      f_r: "reserved",
      groupeId: widget.groupeId,
    );
    AppCubit.get(context).getdifferent(widget.groupeId,  widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppSates>(
      listener: (BuildContext context, state) {
        // يمكن إضافة ردود الفعل عند التغيير في الحالة إذا لزم الأمر
      },
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple.shade700,
            title: Text('${widget.userName}\'s Files', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            AppCubit.get(context).get_file_user_ingroup_reserved!=null&&
              AppCubit.get(context).differentModel!=null?


            ListView(
              children: [
                _buildUserHeader(),
                SizedBox(height: 20),
                _buildExpansionTile('Reserved Files', AppCubit.get(context).get_file_user_ingroup_reserved, "reserved"),
                _buildExpansionTile('Free Files', AppCubit.get(context).get_file_user_ingroup_free, "free"),
                _buildExpansionTileD('update Files', AppCubit.get(context).differentModel, "free"),

              ],
            )
                :        Center(child: CircularProgressIndicator())


          ),
        );
      },
    );
  }

  // بناء الهيدر (صورة المستخدم واسم المستخدم)
  Widget _buildUserHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.purple.shade300,
          child: Text(
            widget.userName.toString().substring(0, 1), // أول حرف من الاسم
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(width: 20),
        Text(
          '${widget.userId}!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple.shade800),
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
        iconColor: Colors.purple.shade700,
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.purple.shade700),
        ),
        children: files.isEmpty
            ? [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No files available.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
        ]
            : files.map<Widget>((file) {
          return ListTile(
            title: Text(file.name ?? '', style: TextStyle(fontSize: 16, color: Colors.black87)),
            trailing: Icon(Icons.file_download, color: Colors.purple[800]),
            // يمكن إضافة تفاصيل إضافية مثل التعديلات (إذا لزم الأمر)
            // subtitle: file.modified == 'Yes'
            //     ? Text('Modifications: ${file.modifications ?? ''}', style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
            //     : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpansionTileD(String title, dynamic fileList, String status) {
    // استخراج البيانات من الملف إذا كانت موجودة
    List<dynamic> files = fileList.data ?? [];  // التأكد من أن data موجودة

    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blue.shade50,
      child: ExpansionTile(
        iconColor: Colors.purple.shade700,
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.purple.shade700),
        ),
        children: files.isEmpty
            ? [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No files available.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
        ]
            : files.map<Widget>((file) {
          return Column(
            children: [
              ListTile(
                title: Text(file.diff ?? '', style: TextStyle(fontSize: 16, color: Colors.black87)),
                // إضافة التفاصيل إذا لزم الأمر
              ),
              Divider(), // سطر فاصل بين العناصر
            ],
          );
        }).toList(),
      ),
    );
  }
}
