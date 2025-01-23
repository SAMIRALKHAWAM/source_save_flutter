import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/cubit.dart';

import '../cubits/app/cubit.dart';
import '../cubits/app/state.dart';

class FileDetailPage extends StatefulWidget {
  final fileId;
  FileDetailPage({required this.fileId});

  @override
  State<FileDetailPage> createState() => _FileDetailPageState();
}

class _FileDetailPageState extends State<FileDetailPage> {
  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).get_file_V(fileId: widget.fileId);

    return BlocConsumer<AppCubit, AppSates>(
      listener: (BuildContext context, AppSates state) {},
      builder: (BuildContext context, AppSates state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Old File Versions"),
            backgroundColor: Colors.purple,
          ),
          body: Column(
            children: [
              // القائمة الرئيسية للنسخ
              Expanded(
                child: AppCubit.get(context).get_fileV != null
                    ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: AppCubit.get(context).get_fileV!.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          leading: Icon(Icons.history, color: Colors.purple),
                          title: Text(
                            AppCubit.get(context).get_fileV!.data[index].name, // اسم النسخة
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "This version includes basic setup and functionality. It fixes initial bugs.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Updated UI and added new features.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, // جعل الأزرار في المنتصف
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _downloadOldVersion();
                                  },
                                  child: Row(
                                    children:
                                    [
                                      Icon(Icons.download, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text("Download"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple, // لون الخلفية
                                    foregroundColor: Colors.white, // لون النص
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // تحديد حجم مناسب
                                    minimumSize: Size(130, 40), // تحديد حجم الزر
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16), // التباعد بين الأزرار
                                ElevatedButton(
                                  onPressed: () {
                                    _restoreOldVersion(AppCubit.get(context).get_fileV!.data[index].id);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.restore, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text("Restore"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // لون الخلفية
                                    foregroundColor: Colors.white, // لون النص
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // تحديد حجم مناسب
                                    minimumSize: Size(130, 40), // تحديد حجم الزر
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              // زر Log في أسفل الصفحة
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogPage(fileId:widget.fileId ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long, color: Colors.white),
                      SizedBox(width: 8),
                      Text("Log", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // لون الزر
                    foregroundColor: Colors.white, // لون النص
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // دالة لتحميل النسخة القديمة
  void _downloadOldVersion() {
    print("Downloading old version...");
    // يمكنك إضافة المنطق لتحميل الملف هنا
  }

  // دالة لاستعادة النسخة القديمة
  void _restoreOldVersion(dynamic old_file_id) {
    AppCubit.get(context).return_to_old_version(old_file_id: old_file_id);

    print("Restoring old version...");
    // يمكنك إضافة منطق لاستعادة النسخة هنا
  }
}

class LogPage extends StatelessWidget {
  dynamic fileId;
  LogPage({required this.fileId});

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).getFilesLog(fileId);
    return BlocConsumer<AppCubit,AppSates>(
      listener: (BuildContext context, Object? state) {  },

      builder: (BuildContext context, state) {

        return
        AppCubit.get(context).logModel!=null?

         Scaffold(
        appBar: AppBar(
          title: Text("Log Details"),
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppCubit.get(context).logModel!.data.toString(),
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      )
            :
      Center(child: CircularProgressIndicator(),);

        },
    );
  }
}
