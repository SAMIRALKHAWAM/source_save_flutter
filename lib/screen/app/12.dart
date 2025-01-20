import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReservedFilesPage extends StatefulWidget {
  @override
  _ReservedFilesPageState createState() => _ReservedFilesPageState();
}

class _ReservedFilesPageState extends State<ReservedFilesPage> {
  // قائمة من الملفات المحجوزة (داتا وهمية)
  final List<String> reservedFiles = [
    "Document_A.pdf",
    "Report_B.csv",
    "Image_C.txt",
    "Spreadsheet_Xlsx.xlsx",
    "Presentation.pptx",
  ];

  void showFileOptions(BuildContext context, String fileName) {
    // عرض الـ BottomSheet لخيارات فك الحجز
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'What would you like to do with "$fileName"?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // فك الحجز بدون رفع ملف إضافي
                  Navigator.pop(context);
                  _showMessage('File "$fileName" unlocked without upload.');
                },
                child: Text('Unlock without file upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // استخدام اللون الأساسي
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // فك الحجز مع رفع ملف جديد
                  Navigator.pop(context);
                  _showFileUploadDialog(context, fileName);
                },
                child: Text('Unlock with file upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // نفس اللون الأساسي للتصميم
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFileUploadDialog(BuildContext context, String fileName) {
    // عرض مربع حوار لرفع الملف في المنتصف
    showDialog(
      context: context,
      barrierDismissible: true,  // يسمح بإغلاق الـ Dialog عند النقر خارج النافذة
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 12,
          insetPadding: EdgeInsets.symmetric(horizontal: 30),
          contentPadding: EdgeInsets.all(20),
          title: Text(
            'Upload New File for "$fileName"',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Choose File',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showMessage('File "$fileName" unlocked with new upload.');
                    },
                    child: Text('Submit', style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    // عرض رسالة بعد فك الحجز
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700, // استخدام backgroundColor بدلاً من primaryColor
        title: Text('File'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0, // إزالة الظل
      ),
      body: ListView.builder(
        itemCount: reservedFiles.length,
        itemBuilder: (context, index) {
          final fileName = reservedFiles[index];
          return GestureDetector(
            onTap: () => showFileOptions(context, fileName),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              elevation: 4, // تأثير الظل
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                title: Text(fileName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                trailing: Icon(Icons.lock_open, color: Colors.blue),
              ),
            ),
          );
        },
      ),
    );
  }
}
