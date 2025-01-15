import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class TextFileViewer extends StatelessWidget {
  final String fileUrl;

  TextFileViewer({required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Dio().get(fileUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('خطأ في تحميل الملف'));
        } else {
          // تحليل النص لإزالة أي محتوى HTML غير مرغوب فيه
          final cleanText =snapshot.data?.data;

          return Scaffold(
            appBar: AppBar(title: Text('عرض الملف النصي')),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(cleanText.toString(), style: TextStyle(fontFamily: 'Courier', fontSize: 14)),
            ),
          );
        }
      },
    );
  }

  Future<String> _loadFile(String url) async {
    final request = await html.HttpRequest.request(url, method: 'GET');
    return request.responseText ?? '';
  }

  // دالة لإزالة علامات HTML من النص
  String _removeHtmlTags(String htmlContent) {
    final document = parse(htmlContent); // تحليل النص كـ HTML
    return document.body?.text ?? ''; // استخراج النص بدون HTML
  }
}
