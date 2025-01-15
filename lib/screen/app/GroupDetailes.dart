import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/network/dio_helper.dart';
import 'dart:html' as html;

import '../../cubits/app/cubit.dart';
import '../../cubits/app/state.dart';
import '11.dart';
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
        allowedExtensions: ['pdf', 'CSV'],
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.bytes != null) {
            final fileName = file.name;
            final bytes = file.bytes!;

            AppCubit.get(context).add_file(
                fileName: fileName, fileBytes: bytes, id: widget.groupId);
            AppCubit.get(context).get_file_accepted(id_group: widget.groupId);

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
  // void downloadFile(String url) {
  //   html.AnchorElement anchorElement =  new html.AnchorElement(href: url);
  //   anchorElement.download = url;
  //   anchorElement.click();
  // }

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

  Future<void> downloadFileFromUrl(String fileUrl, String fileName) async {
    Dio dio = Dio(BaseOptions(
      baseUrl: "http://192.168.1.106:8000",
      responseType: ResponseType.stream,
      headers: {
        'Accept': 'application/json', // إضافة رؤوس مخصصة إذا كان الخادم يحتاج إليها
      },

      followRedirects: false, // إذا كان الخادم يرسل تحويلات (Redirects) يجب أن يكون False
    ));


    try {
      print("Downloading from: $fileUrl");
      Response response = await dio.get(fileUrl);

      if (response.statusCode == 200) {
        print("Download successful!");
        final Uint8List bytes = await response.data.stream.toBytes();

        // تحويل البيانات إلى Blob
        final blob = html.Blob([bytes]);

        // إنشاء رابط لتحميل الملف
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        anchor.download;

        // تحرير رابط Object URL بعد التنزيل
        html.Url.revokeObjectUrl(url);
      } else {
        print('لم يتم استلام البيانات.');
      }
    } catch (e) {
      print('حدث خطأ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    AppCubit.get(context).get_file_accepted(id_group: widget.groupId);
    AppCubit.get(context).get_group_users(id: widget.groupId);
    return BlocConsumer<AppCubit, AppSates>(
      listener: (BuildContext context, AppSates state) {},
      builder: (BuildContext context, AppSates state) {
        return AppCubit.get(context).get_file != null
            ? DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(widget.groupName),
                    actions: [
                      !widget.isAdmin?
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded),
                        onSelected: (value) {
                          if (value == 'leave_group') {

                            AppCubit.get(context).leave_group(groupId: widget.groupId);
                            AppCubit.get(context).get_file_accepted(id_group: widget.groupId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen()
                              ),
                            );
                            print("مغادرة المجموعة");
                          } else if (value == 'book') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  Book(group_id: widget.groupId,)),
                            );
                            print("حجز");
                            // أضف هنا الكود الخاص بالحجز
                            print("حجز");
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            child: Text('leave_group'),
                            value: 'leave_group',
                          ),
                          PopupMenuItem<String>(
                            child: Text('book'),
                            value: 'book',
                          ),
                        ],
                      )
:SizedBox()
                    ],



                    backgroundColor: Colors.blueAccent,
                    centerTitle: true,
                    bottom: TabBar(
                      tabs: [
                        Tab(text: 'Files'),
                        Tab(text: 'Members'),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      // Tab 1: Files
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            widget.isAdmin
                                ? Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // لتوسيط العناصر أفقيًا
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              AppCubit.get(context)
                                                  .get_file_accepted(
                                                      id_group: widget.groupId);

                                              select = "accepte";
                                            });
                                          },
                                          child: Text('file accept '),
                                        ),
                                        SizedBox(width: screenWidth/25,),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              AppCubit.get(context).get_file_pe(
                                                  id_group: widget.groupId);

                                              select = "pending ";
                                            });
                                          },
                                          child: Text('file pending'),
                                        ),
                                        SizedBox(width: screenWidth/25,),
                                        ElevatedButton(
                                          onPressed: () => pickFiles(context),
                                          child: Text('Upload PDFs'),
                                        ),
                                      ],
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () => pickFiles(context),
                                    child: Text('Upload PDFs'),
                                  ),
                            SizedBox(height: 16),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  int crossAxisCount = 1;

                                  if (constraints.maxWidth >= 1200) {
                                    crossAxisCount = 4;
                                  } else if (constraints.maxWidth >= 800) {
                                    crossAxisCount = 3;
                                  } else if (constraints.maxWidth >= 600) {
                                    crossAxisCount = 2;
                                  }

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
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  AppCubit.get(context)
                                                      .get_file!
                                                      .data[index]
                                                      .name,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors
                                                        .blueAccent.shade700,
                                                  ),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(
                                                            Icons.download,
                                                            color: Colors
                                                                .blueAccent),
                                                        onPressed: () {
                                                          final fileUrl = "http://192.168.43.70:8000" +
                                                              AppCubit.get(
                                                                  context)
                                                                  .get_file!
                                                                  .data[
                                                              index]
                                                                  .url;
                                                          final fileName =
                                                              AppCubit.get(
                                                                      context)
                                                                  .get_file!
                                                                  .data[index]
                                                                  .name;
                                                          downloadFileFromUrl(fileUrl,fileName ); // استخدم هذه الدالة لتحميل الملف
                                                          // downloadFile(fileUrl);
                                                          // AppCubit.get(context).ge();
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //     builder: (context) =>
                                                          // TextFileViewer(fileUrl: fileUrl,)));
                                                        }),
                                                    IconButton(
                                                      icon: Icon(Icons.bookmark,
                                                          color: Colors
                                                              .blueAccent),
                                                      onPressed: () {
                                                        print(
                                                            'Reserving ${groupsFiles[index]['name']}');
                                                      },
                                                    ),
                                                    if (widget.isAdmin)
                                                      IconButton(
                                                        icon: Icon(Icons.delete,
                                                            color: Colors
                                                                .redAccent),
                                                        onPressed: () {
                                                          setState(() {
                                                            groupsFiles
                                                                .removeAt(
                                                                    index);
                                                          });
                                                          print(
                                                              'Deleted file: ${groupsFiles.isNotEmpty ? groupsFiles[index]['name'] : 'No Files Left'}');
                                                        },
                                                      ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  final fileUrl =
                                                      "http://localhost:8000" +
                                                          AppCubit.get(context)
                                                              .get_file!
                                                              .data[index]
                                                              .url;

                                                  if (fileUrl != null) {
                                                    // إذا كان الملف يحتوي على URL، افتحه في نافذة جديدة
                                                    html.window.open(
                                                        fileUrl, '_blank');
                                                  }
                                                  print('oopps');
                                                },
                                              ),
                                            );
                                          },
                                        )
                                      : Column(
                                          children: [
                                            AppCubit.get(context)
                                                        .get_file_pending !=
                                                    null
                                                ? Expanded(
                                                    child: ListView.builder(
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Card(
                                                          elevation: 3,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          child: ListTile(
                                                            onTap: () {
                                                              final fileUrl = "http://localhost:8000" +
                                                                  AppCubit.get(
                                                                          context)
                                                                      .get_file!
                                                                      .data[
                                                                          index]
                                                                      .url;

                                                              if (fileUrl !=
                                                                  null) {
                                                                // إذا كان الملف يحتوي على URL، افتحه في نافذة جديدة
                                                                html.window.open(
                                                                    fileUrl,
                                                                    '_blank');
                                                              }
                                                              print('oopps');
                                                            },
                                                            title: Text(AppCubit
                                                                    .get(
                                                                        context)
                                                                .get_file_pending!
                                                                .data[index]
                                                                .name),
                                                            trailing: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    AppCubit.get(context).change_file_status(
                                                                        status:
                                                                            "accepted",
                                                                        fileId: AppCubit.get(context)
                                                                            .get_file_pending!
                                                                            .data[index]
                                                                            .id);

                                                                    print(
                                                                        "accepted");
                                                                    AppCubit.get(
                                                                            context)
                                                                        .get_file_pe(
                                                                            id_group:
                                                                                widget.groupId);
                                                                  },
                                                                  child: Text(
                                                                      "accept"),
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    AppCubit.get(context).change_file_status(
                                                                        status:
                                                                            "rejected ",
                                                                        fileId: AppCubit.get(context)
                                                                            .get_file_pending!
                                                                            .data[index]
                                                                            .id);
                                                                    print(
                                                                        'rejected');
                                                                    AppCubit.get(
                                                                            context)
                                                                        .get_file_pe(
                                                                            id_group:
                                                                                widget.groupId);
                                                                  },
                                                                  child: Text(
                                                                      "rejected"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      itemCount:
                                                          AppCubit.get(context)
                                                              .get_file_pending!
                                                              .data
                                                              .length,
                                                    ),
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                          ],
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tab 2: Members
                      AppCubit.get(context).getUsergroup != null
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView.builder(
                                itemCount: AppCubit.get(context)
                                    .getUsergroup!
                                    .data!
                                    .length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          AppCubit.get(context)
                                              .getUsergroup!
                                              .data![index]
                                              .userName!,
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            )
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
