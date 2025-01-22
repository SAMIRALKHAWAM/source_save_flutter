import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/network/dio_helper.dart';
import 'package:source_safe/network/end_point.dart';
import 'dart:html' as html;

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
          ]);

      if (result != null) {
        for (var file in result.files) {
          if (file.bytes != null) {
            final fileName = file.name;
            final bytes = file.bytes!;

            AppCubit.get(context).add_file(
                fileName: fileName, fileBytes: bytes, id: widget.groupId);
            AppCubit.get(context).get_file_pe(id_group: widget.groupId);

            select = "accepte";
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

  void downloadFile(String url) {
    html.HttpRequest.request(url, method: 'GET', responseType: 'blob')
        .then((response) {
      final blob = response.response;
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..setAttribute('download', 'file.pdf') // اسم الملف والامتداد الصحيح
        ..click();
      html.Url.revokeObjectUrl(url); // تنظيف URL
    }).catchError((e) {
      print('Error fetching file: $e');
    });
  }

  // void download(
  //     List<int> bytes, {
  //       String downloadName,
  //     }) {
  //   // Encode our file in base64
  //   final _base64 = base64Encode(bytes);
  //   // Create the link with the file
  //   final anchor =
  //   AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
  //     ..target = 'blank';
  //   // add the name
  //   if (downloadName != null) {
  //     anchor.download = downloadName;
  //   }
  //   // trigger download
  //   document.body.append(anchor);
  //   anchor.click();
  //   anchor.remove();
  //   return;
  // }
  static late Dio dio;

  void _downloadFile(String url) async {
    dio = Dio();
    try {
      // إجراء طلب fetch
      final response = await dio.get(
          "https://cors-anywhere.herokuapp.com/" + url,
          options: Options(responseType: ResponseType.stream));

      // تحقق من وجود استجابة صحيحة
      if (response != null && response.statusMessage == 200) {
        // إذا كانت الاستجابة ناجحة، قم بتحويلها إلى blob
        final blob = await response.data.stream();
        final urlBlob = html.Url.createObjectUrlFromBlob(blob);

        // إنشاء رابط لتحميل الملف
        final anchor = html.AnchorElement(href: urlBlob)
          ..target = 'none'
          ..download = url.split('/').last;

        // محاكاة النقر على الرابط لتنزيل الملف
        anchor.click();

        // تنظيف الـ Blob بعد التنزيل
        html.Url.revokeObjectUrl(urlBlob);
      } else {
        print('فشل في تحميل الملف، حالة الاستجابة: ${response.statusMessage}');
      }
    } catch (e) {
      print('حدث خطأ أثناء محاولة تنزيل الملف: $e');
    }
  }

// دالة لتحميل الملف مباشرة

  // void _downloadFile(String url) async {
  //   try {
  //     // إجراء طلب fetch
  //     final response = await html.window.fetch("https://cors-anywhere.herokuapp.com/"+url);
  //
  //     // تحقق من وجود استجابة صحيحة
  //     if (response != null && response.status == 200) {
  //       // إذا كانت الاستجابة ناجحة، قم بتحويلها إلى blob
  //       final blob = await response.blob();
  //       final urlBlob = html.Url.createObjectUrlFromBlob(blob);
  //
  //       // إنشاء رابط لتحميل الملف
  //       final anchor = html.AnchorElement(href: urlBlob)
  //         ..target = 'none'
  //         ..download = url.split('/').last;
  //
  //       // محاكاة النقر على الرابط لتنزيل الملف
  //       anchor.click();
  //
  //       // تنظيف الـ Blob بعد التنزيل
  //       html.Url.revokeObjectUrl(urlBlob);
  //     } else {
  //       print('فشل في تحميل الملف، حالة الاستجابة: ${response.status}');
  //     }
  //   } catch (e) {
  //     print('حدث خطأ أثناء محاولة تنزيل الملف: $e');
  //   }
  // }

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
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_rounded,
                              color: Colors.white),
                          onSelected: (value) {
                            if (value == 'leave_group') {
                              AppCubit.get(context)
                                  .leave_group(groupId: widget.groupId);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            } else if (value == 'book') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Book(group_id: widget.groupId)),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              child: Text('Leave Group'),
                              value: 'leave_group',
                            ),
                            PopupMenuItem<String>(
                              child: Text('Book Files'),
                              value: 'book',
                            ),
                          ],
                        ),
                    ],
                    backgroundColor: Colors.deepPurple, // اللون البنفسجي الداكن
                    centerTitle: true,
                    bottom: TabBar(
                      // indicatorColor: Colors.white,
                      // indicatorWeight: 3,
                      tabs: [
                        Tab(text: 'Files'),
                        Tab(text: 'Members'),
                        Tab(text: 'My Files'),
                      ],
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
                                    child: Text('File Accept'),
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
                                    child: Text('File Pending'),
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
                                            ? Colors.purple[600]
                                            : Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.purple[300]!)),
                                    ),
                                    child: Text('Booking'),
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
                                    child: Text('All Files'),
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
                                            ? Colors.purple[800]
                                            : Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.purple[300]!)),
                                    ),
                                    child: Text('Booking Files'),
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
                                                            "http://127.0.0.1:8000" +
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
                                                        final html.AnchorElement
                                                            anchor =
                                                            html.AnchorElement(
                                                                href: fileUrl)
                                                              ..target = 'blank'
                                                              ..download =
                                                                  fileName;
                                                        anchor.click();
                                                      },
                                                    ),
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
                              child: Text("accept"),
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
                              child: Text("rejected"),
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
                      color: Colors.blueAccent.shade700,
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
                    backgroundColor: Colors.blueAccent,
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
        iconColor: Colors.blue.shade700,
        title: Text(
          title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700),
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
                  title: Text(file.name ?? '',
                      style: TextStyle(fontSize: 16, color: Colors.black87)),
                  trailing: Icon(Icons.file_download, color: Colors.blue),
                  onTap: () {
                    // عند النقر على الملف، نعرض مربع الحوار مع الخيارات
                    _showFileOptionsDialog(context, file);
                  },
                );
              }).toList(),
      ),
    );
  }

// دالة لعرض مربع الحوار مع الخيارين
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
