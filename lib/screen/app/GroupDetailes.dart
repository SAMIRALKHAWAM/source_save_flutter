import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class GroupDetailsScreen extends StatefulWidget {
  final String groupName;
  final bool isAdmin;

  GroupDetailsScreen({required this.groupName, this.isAdmin = true});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final List<Map<String, dynamic>> groupsFiles = [];

  final List<String> groupMembers = [
    'Member 1',
    'Member 2',
    'Member 3',
    'Member 4',
  ];

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
            setState(() {
              groupsFiles.add({'name': fileName, 'bytes': bytes});
            });
            print('File selected: $fileName');
          }
        }
      }
    } on PlatformException catch (e) {
      print('Unsupported operation: $e');
    } catch (e) {
      print('Error: $e');
    }
  }

  void downloadFile(String fileName, List<int> bytes) {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    html.Url.revokeObjectUrl(url);
    print('Downloading $fileName');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName),
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
                  ElevatedButton(
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

                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 3,
                          ),
                          itemCount: groupsFiles.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  groupsFiles[index]['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent.shade700,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.download, color: Colors.blueAccent),
                                      onPressed: () {
                                        downloadFile(
                                          groupsFiles[index]['name'],
                                          groupsFiles[index]['bytes'],
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.bookmark, color: Colors.blueAccent),
                                      onPressed: () {
                                        print('Reserving ${groupsFiles[index]['name']}');
                                      },
                                    ),
                                    if (widget.isAdmin)
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () {
                                          setState(() {

                                            groupsFiles.removeAt(index);
                                          });
                                          print('Deleted file: ${groupsFiles.isNotEmpty ? groupsFiles[index]['name'] : 'No Files Left'}');
                                        },
                                      ),

                                  ],
                                ),
                                onTap: () {
                                  final fileName = groupsFiles[index]['name'];
                                  final fileBytes = groupsFiles[index]['bytes'];

                                  if (fileName.endsWith('.pdf')) {

                                    print('Opening file: $fileName');
                                    final url = html.Url.createObjectUrlFromBlob(
                                      html.Blob([fileBytes], 'application/pdf'),
                                    );
                                    html.window.open(url, '_blank');
                                    html.Url.revokeObjectUrl(url);
                                  } else if (fileName.endsWith('.csv')) {

                                    print('Opening CSV file: $fileName');
                                    final csvContent = utf8.decode(fileBytes);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('CSV Content'),
                                        content: SingleChildScrollView(
                                          child: Text(csvContent),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: Text('Close'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    print('Unknown file type: $fileName');
                                  }
                                },

                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Tab 2: Members
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: groupMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        groupMembers[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent.shade700,
                        ),
                      ),
                      leading: CircleAvatar(
                        child: Text(
                          groupMembers[index][0],
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      trailing: widget.isAdmin
                          ? IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            groupMembers.removeAt(index);
                          });
                          print('Removed member: ${groupMembers[index]}');
                        },
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
