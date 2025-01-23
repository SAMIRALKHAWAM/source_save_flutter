import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/network/dio_helper.dart';
import 'package:source_safe/network/end_point.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;


import '../../cubits/app/cubit.dart';
import '../../cubits/app/state.dart';
import '../sss.dart';
import 'UserDetailPage.dart';
import 'HomeScreen.dart';
import 'book.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String groupName;
  final groupId;

  final bool isAdmin;

  GroupDetailsScreen(
      {required this.groupName, required this.groupId, this.isAdmin = true});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final List<Map<String, dynamic>> groupsFiles = [];
  String? select = "accepte";

  Future<void> pickFiles(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'CSV',
          "txt",
        ],
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.bytes != null) {
            final originalFileName = file.name;
            final bytes = file.bytes!;

            // اطلب من المستخدم تغيير اسم الملف
            final newFileName = await _showRenameFileDialog(context, originalFileName);

            if (newFileName != null && newFileName.isNotEmpty) {
              AppCubit.get(context).add_file(
                fileName: newFileName,
                fileBytes: bytes,
                id: widget.groupId,
              );
              AppCubit.get(context).get_file_pe(id_group: widget.groupId);

              select = "accepte";
              print('File selected: $newFileName');
              print(file.size);
            } else {
              print('File upload canceled or invalid name');
            }
          }
        }
      }
    } on PlatformException catch (e) {
      print('Unsupported operation: $e');
    } catch (e) {
      print('Error: $e');
    }
  }

// دالة لعرض مربع الحوار لإعادة تسمية الملف
  Future<String?> _showRenameFileDialog(BuildContext context, String originalName) async {
    final TextEditingController nameController = TextEditingController(text: originalName);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename File'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Enter new file name',
              hintText: 'e.g., my_file.pdf',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إلغاء الحوار
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(nameController.text.trim()); // إرجاع الاسم الجديد
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void downloadFile(String url, String fileName) async {
    try {
      final request = html.HttpRequest();
      request.open('GET', url);
      request.responseType = 'blob';  // تحديد نوع الاستجابة كـ Blob

      request.onLoadEnd.listen((e) {
        if (request.status == 200) {

          final blob = request.response;
          final urlBlob = html.Url.createObjectUrlFromBlob(blob);

          final anchor = html.AnchorElement(href: urlBlob)
            ..download = fileName  // تحديد اسم الملف عند التحميل
            ..click();  // محاكاة النقر على الرابط لتحميل الملف

          // تنظيف بعد التحميل
          html.Url.revokeObjectUrl(urlBlob);
        } else {
          print('حدث خطأ في تحميل الملف: ${request.status}');
        }
      });

      // إرسال الطلب
      request.send();
    } catch (e) {
      print('حدث خطأ أثناء تحميل الملف: $e');
    }
  }




  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    AppCubit.get(context).get_file_accepted(id_group: widget.groupId);
    AppCubit.get(context).get_group_users(id: widget.groupId);
    AppCubit.get(context).get_file_user(
      userId: id,
      f_r: "free",
      groupeId: widget.groupId,
    );
    AppCubit.get(context).get_file_user(
      userId: id,
      f_r: "reserved",
      groupeId: widget.groupId,
    );
    AppCubit.get(context).getdifferent(widget.groupId,  id);



  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<AppCubit, AppSates>(
      listener: (BuildContext context, AppSates state) {},
      builder: (BuildContext context, AppSates state) {
        return AppCubit.get(context).get_file != null
            ? DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      widget.groupName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    actions: [
                      if (!widget.isAdmin)


                      Tooltip(
                        message: "Exit group".tr(),
                        child: IconButton(
                          icon: Icon(Icons.output_sharp,
                              color: Colors.purple[800]),
                          onPressed: () {

                          },
                        ),
                      ),                    ],
                    backgroundColor: Colors.purple[800], // اللون البنفسجي الداكن
                    centerTitle: true,
                    bottom: TabBar(
                      // indicatorColor: Colors.white,
                      // indicatorWeight: 3,
                      tabs: [
                        Tab(text: 'Files'),
                        Tab(text: 'Members'),
                        Tab(text: 'My Files'),
                      ],

                        indicatorColor: Colors.white, // تغير لون المؤشر ليكون أبيض
                        labelColor: Colors.white, // تغيير لون النص في التاب النشط إلى الأبيض
                        unselectedLabelColor: Colors.grey

                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.purple[800],
                    child: Icon(Icons.add_box, color: Colors.white),
                    onPressed: () {
                      pickFiles(context);
                      // AppCubit.get(context).getUsers();
                    },
                  ),
                  body: TabBarView(
                    children: [
                      // Files Tab
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            if (widget.isAdmin)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        select = "accepte";
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        select == "accepte"
                                            ? Colors.purple[300]
                                            : Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.purple[300]!)),
                                    ),
                                    child: Text('File Accept'.tr()),
                                  ),
                                  SizedBox(width: screenWidth / 25),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        AppCubit.get(context).get_file_pe(
                                            id_group: widget.groupId);
                                        select = "pending";
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        select == "pending"
                                            ? Colors.purple[300]
                                            : Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.purple[300]!)),
                                    ),
                                    child: Text('File Pending'.tr()),
                                  ),
                                  SizedBox(width: screenWidth / 25),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        select = "booking";
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        select == "booking"
                                            ? Colors.purple[300]
                                            : Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.purple[300]!)),
                                    ),
                                    child: Text('Booking'.tr()),
                                  ),
                                ],
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        select = "accepte";
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        select == "accepte"
                                            ? Colors.purple[00]
                                            : Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.purple[300]!)),
                                    ),
                                    child: Text('All Files'.tr()),
                                  ),
                                  SizedBox(width: screenWidth / 25),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        select = "booking";
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        select == "booking"
                                            ? Colors.purple[300]
                                            : Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.purple[300]!)),
                                    ),
                                    child: Text('Booking Files'.tr()),
                                  ),
                                ],
                              ),
                            SizedBox(height: 16),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  int crossAxisCount = 1;
                                  if (constraints.maxWidth >= 1200)
                                    crossAxisCount = 4;
                                  else if (constraints.maxWidth >= 800)
                                    crossAxisCount = 3;
                                  else if (constraints.maxWidth >= 600)
                                    crossAxisCount = 2;

                                  return select == "accepte"
                                      ? GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                            childAspectRatio: 3,
                                          ),
                                          itemCount: AppCubit.get(context)
                                              .get_file!
                                              .data
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ListTile(
                                                onTap: () {
                                                  final String fileUrl =
                                                      "http://localhost:8000" +
                                                          AppCubit.get(context)
                                                              .get_file!
                                                              .data[index]
                                                              .url;

                                                  if (fileUrl != null) {
                                                    html.window.open(
                                                        fileUrl, '_blank');
                                                  }
                                                },
                                                title: Text(
                                                  AppCubit.get(context)
                                                      .get_file!
                                                      .data[index]
                                                      .name,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.download,
                                                          color: Colors.purple),
                                                      onPressed: () {
                                                        final fileUrl =
                                                            "http://192.168.100.1:8000" +
                                                                AppCubit.get(
                                                                        context)
                                                                    .get_file!
                                                                    .data[index]
                                                                    .url;
                                                        final fileName =
                                                            AppCubit.get(
                                                                    context)
                                                                .get_file!
                                                                .data[index]
                                                                .name;
        final anchor = html.AnchorElement(href: fileUrl)
        ..download = fileName  // تحديد اسم الملف عند التحميل
        ..click();                                                         }),
                                                    IconButton(
                                                      icon: Icon(Icons.bookmark,
                                                          color: Colors.purple),
                                                      onPressed: () {
                                                        setState(() {

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                FileDetailPage(fileId: AppCubit.get(
                                                                    context)
                                                                    .get_file!
                                                                    .data[index]
                                                                      .id,)
                                                            ),
                                                          );




                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : select == "booking"
                                          ? Book(group_id: widget.groupId)
                                          : change_statise();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Members Tab
                      AppCubit.get(context).getUsergroup != null
                          ? show_member()
                          : Center(child: CircularProgressIndicator()),
                      // My Files Tab
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AppCubit.get(context)
                                    .get_file_user_ingroup_reserved !=
                            null&&AppCubit.get(context)
                            .differentModel !=
                            null

                            ? ListView(
                                children: [
                                  SizedBox(height: 20),
                                  _buildExpansionTile(
                                    'Reserved Files',
                                    AppCubit.get(context)
                                        .get_file_user_ingroup_reserved,
                                    "reserved",
                                  ),
                                  _buildExpansionTile(
                                    'Free Files',
                                    AppCubit.get(context)
                                        .get_file_user_ingroup_free,
                                    "free",
                                  ),
                                  _buildExpansionTileD('update Files', AppCubit.get(context).differentModel, "free"),

                                ],
                              )
                            : Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget change_statise() {
    return Column(
      children: [
        AppCubit.get(context).get_file_pending != null
            ? Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        onTap: () {
                          final String fileUrl = "http://localhost:8000" +
                              AppCubit.get(context).get_file!.data[index].url;

                          if (fileUrl != null) {
                            // إذا كان الملف يحتوي على URL، افتحه في نافذة جديدة
                            html.window.open(fileUrl, '_blank');
                          }
                        },
                        title: Text(AppCubit.get(context)
                            .get_file_pending!
                            .data[index]
                            .name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                AppCubit.get(context).change_file_status(
                                    status: "accepted",
                                    fileId: AppCubit.get(context)
                                        .get_file_pending!
                                        .data[index]
                                        .id);

                                print("accepted");
                                AppCubit.get(context)
                                    .get_file_pe(id_group: widget.groupId);

                                AppCubit.get(context).get_file_accepted(
                                    id_group: widget.groupId);
                              },
                              child: Text("accept".tr()),
                            ),
                            SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                AppCubit.get(context).change_file_status(
                                    status: "rejected ",
                                    fileId: AppCubit.get(context)
                                        .get_file_pending!
                                        .data[index]
                                        .id);
                                print('rejected');
                                AppCubit.get(context)
                                    .get_file_pe(id_group: widget.groupId);
                              },
                              child: Text("rejected".tr()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  itemCount:
                      AppCubit.get(context).get_file_pending!.data.length,
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              )
      ],
    );
  }

  Widget show_member() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: AppCubit.get(context).getUsergroup!.data!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () {
                final userId =
                    AppCubit.get(context).getUsergroup!.data![index].userId;
                final userName =
                    AppCubit.get(context).getUsergroup!.data![index].userName;
                if (widget.isAdmin)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserDetailPage(
                                userId: userId,
                                groupeId: widget.groupId,
                                userName: userName,
                              )));
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    AppCubit.get(context).getUsergroup!.data![index].userName!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      AppCubit.get(context)
                          .getUsergroup!
                          .data![index]
                          .userName[0],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpansionTile(String title, dynamic fileList, String status) {
    // استخراج البيانات من الملف إذا كانت موجودة
    List<dynamic> files = fileList.data ?? []; // التأكد من أن data موجودة

    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blue.shade50,
      child: ExpansionTile(
        iconColor: Colors.purple.shade700,
        title: Text(
          title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.purple.shade700),
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
                  title: Tooltip(
                    message: 'You can cancel the reservation'.tr(),
                    child: Text(file.name ?? '',
                        style: TextStyle(fontSize: 16, color: Colors.black87)),
                  ),



                  onTap: () {
                    status=="free"?
                    null:

                        _showFileOptionsDialog(context, file);
                  },
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
              'No files available.'.tr(),
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


  void _showFileOptionsDialog(BuildContext context, dynamic file) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select an option for \n${file.name}"),
          content: Container(
            width: screenWidth > 800
                ? 500
                : double.maxFinite, // تحديد العرض بناءً على حجم الشاشة

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("فك حجز مع رفع ملف"),
                  onTap: () {
                    Navigator.pop(context);
                    // تنفيذ المنطق لفك الحجز مع رفع الملف
                    _releaseAndUploadFile(file);
                  },
                ),
                ListTile(
                  title: Text("فك حجز بدون رفع"),
                  onTap: () {
                    Navigator.pop(context);
                    // تنفيذ المنطق لفك الحجز دون رفع
                    _releaseFileWithoutUpload(file);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// دالة لتنفيذ فك الحجز مع رفع ملف
  void _releaseAndUploadFile(dynamic file) {
    pickFiles_check(context, file.id);
    print('فك حجز مع رفع ملف: ${file.name}');
    print('فك حجز مع رفع ملف: ${file.id}');
    // على سبيل المثال: قم بفتح مربع حوار لاختيار ملف للرفع
  }

// دالة لتنفيذ فك الحجز بدون رفع ملف
  void _releaseFileWithoutUpload(dynamic file) {
    // هنا تضع المنطق الذي يحتاجه فك الحجز بدون رفع
    print('فك حجز بدون رفع: ${file.name}');
  }

  Future<void> pickFiles_check(BuildContext context, dynamic id) async {
    try {
      final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            'CSV',
            "txt",
          ]);

      if (result != null) {
        for (var file in result.files) {
          if (file.bytes != null) {
            final fileName = file.name;
            final bytes = file.bytes!;

            AppCubit.get(context).check_out_withfile(fileBytes: bytes, id: id);
            print('File selected: $fileName');

            print(file.size);
          }
        }
      }
    } on PlatformException catch (e) {
      print('Unsupported operation: $e');
    } catch (e) {
      print('Error: $e');
    }
  }
}
