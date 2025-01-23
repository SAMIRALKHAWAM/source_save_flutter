import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/app/cubit.dart';
import 'package:source_safe/cubits/app/state.dart';

class Book extends StatefulWidget {
  dynamic group_id;
  Book({required this.group_id, super.key});

  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  List<int> selectedFileIds = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppSates>(listener: (BuildContext context, state) {
      if(state is check_fileErrorState)
        SnackBar(
          content: Text('Try again'), // نص الرسالة
          duration: const Duration(seconds: 3), // مدة عرض الرسالة
          backgroundColor: Colors.red, // يمكن تغيير اللون
          behavior: SnackBarBehavior.floating, // لتغيير طريقة عرض السناك بار
        );


    }, builder: (BuildContext context,  state) {

      return Scaffold(

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'select file :'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: AppCubit.get(context).get_file?.data.length ?? 0,
                  itemBuilder: (context, index) {
                    var file = AppCubit.get(context).get_file!.data[index];
                    bool isFileAvailable = file.reservedBy == null; // حالة الملف غير محجوز

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        color: isFileAvailable ? Colors.white : Colors.grey[300], // لون الرمادي للملفات غير المتاحة
                        child: CheckboxListTile(
                          title: Text(
                            file.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: isFileAvailable ? Colors.black : Colors.grey, // تغيير اللون للنص عند عدم التوفر
                            ),
                          ),
                          value: selectedFileIds.contains(file.id),
                          onChanged: isFileAvailable
                              ? (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedFileIds.add(file.id);
                              } else {
                                selectedFileIds.remove(file.id);
                              }
                            });
                          }
                              : null, // تعطيل التفاعل عند عدم التوفر
                          activeColor: Colors.purple[800],
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: selectedFileIds.isNotEmpty
                      ? () {
                    print(widget.group_id);
                    AppCubit.get(context)
                        .check_in_files(group_id: widget.group_id, files: selectedFileIds);

                    AppCubit.get(context)
                        .get_file_accepted(id_group: widget.group_id);
                    Book(group_id: widget.group_id);
                  }
                      : null, // تعطيل الزر إذا لم يتم اختيار أي ملفات
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedFileIds.isNotEmpty
                        ? Colors.purple[800]
                        : Colors.grey, // تغيير اللون إلى الرمادي عند تعطيل الزر
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'File reservation'.tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },

    );
  }
}
