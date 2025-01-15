import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:source_safe/cubits/app/cubit.dart';

class Book extends StatefulWidget {
  dynamic group_id;
 Book( { required this.group_id,super.key});

  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  List<int> selectedFileIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'booking file',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'select:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: AppCubit.get(context).get_file?.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: CheckboxListTile(
                      title: Text(
                        AppCubit.get(context).get_file!.data[index].name,
                        style: TextStyle(fontSize: 16),
                      ),
                      value: selectedFileIds.contains(AppCubit.get(context).get_file!.data[index].id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedFileIds.add( AppCubit.get(context).get_file!.data[index].id);
                          } else {
                            selectedFileIds.remove( AppCubit.get(context).get_file!.data[index].id);
                          }
                        });
                      },
                      activeColor: Colors.blueAccent,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedFileIds.isNotEmpty) {
                  print('تم اختيار الملفات: $selectedFileIds');
                  print(widget.group_id);
                  AppCubit.get(context).check_in_files(group_id: widget.group_id, files: selectedFileIds);
                  // هنا يمكن تنفيذ عملية الحجز باستخدام المعرفات المحددة
                } else {
                  print('لم يتم اختيار أي ملفات');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                'booking',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
