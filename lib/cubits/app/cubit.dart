import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/app/state.dart';
import '../../../network/end_point.dart';
import '../../models/get _permission_model.dart';
import '../../models/get_file_model.dart';
import '../../models/get_groups_model.dart';
import '../../models/get_user_group_model.dart';
import '../../models/get_user_model.dart';

import '../../network/dio_helper.dart';
import 'dart:html' as html;

class AppCubit extends Cubit<AppSates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  List<DataUser> getUsersearch = [];

  ///////////////////////Get Users
  GetUser? getUser;
  void getUsers() {
    getUsersearch = [];
    searchResults = [];
    emit(LoadingState());
    DioHelper.getData(
      url: baseurl + get_users,
    ).then((value) {
      emit(userSuccessState());
      getUser = GetUser.fromJson(value.data);
      getUser!.data!.forEach((element) {
        getUsersearch.add(element);
      });
      searchResults = List.from(getUsersearch); // إرجاع جميع الأعضاء

    }).catchError((error) {
      print(error.toString());
      emit(userErrorState());
    });
  }

  ///////////////////////Get Users group
  GetUserGroup? getUsergroup;
  void get_group_users({
    required id,

}) {

    emit(LoadingState());
    DioHelper.getData(
      url: baseurl +"/get_group_users?groupId=$id",
    ).then((value) {
      emit(userSuccessState());
      getUsergroup = GetUserGroup.fromJson(value.data);




    }).catchError((error) {
      print(error.toString());
      emit(userErrorState());
    });
  }

///////////////////////////////////////



///////////////////////////////////////
  GetPremmetion? getpermissions;
  void get_permissions() {
    emit(LoadingState());
    DioHelper.getData(
      url: baseurl + premmetion,
    ).then((value) {
      emit(get_permissionsSuccessState());
      getpermissions = GetPremmetion.fromJson(value.data);
    }).catchError((error) {
      print(error.toString());
      emit(get_permissionsErrorState());
    });
  }

///////////////////////////////////////////  add_group
  void add_group({
    required name,
    required userId,
    required perId,
  }) {
    emit(LoadingState());
    DioHelper.postData(
            url: baseurl + addgroup,
            data: {'name': name, 'users': userId, 'permissions': perId})
        .then((value) {
      emit(add_groupSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(add_groupErrorState());
    });
  }

///////////////////////////////////////////  add_file
  void add_file(
      {required String fileName, required List<int> fileBytes, required id}) {
    FormData formData = FormData.fromMap({
      'url': MultipartFile.fromBytes(fileBytes,
          filename: fileName), // إرسال الملف هنا كـ 'file'
      'group_id': id, // إذا كان الباكيند يحتاج معرف المجموعة
      'name': fileName,
      "description": "aaaaaaaaaaaaaaaaaaaaaa aa",
    });

    emit(LoadingState());
    DioHelper.postData(url: baseurl + addfile, data: formData).then((value) {
      print(value.data);
      emit(add_fileSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(add_fileErrorState());
    });
  }

///////////////////////////////////////////  get_file_accepted
  GetFileModel? get_file;
  void get_file_accepted({required dynamic id_group}) {
    emit(LoadingState());
    DioHelper.getData( url: baseurl + "/get_files?group_id=$id_group&status=accepted")
        .then((value) {
      emit(get_fileSuccessState());
      get_file = GetFileModel.fromJson(value.data);

    }).catchError((error) {
      print(error.toString());
      emit(get_fileErrorState());
    });
  }

  ///////////////////////////////////////////  get_file_pending
  GetFileModel? get_file_pending ;
  void get_file_pe({required dynamic id_group}) {
    emit(LoadingState());
    DioHelper.getData( url: baseurl + "/get_files?group_id=$id_group&status=pending ")
        .then((value) {
      emit(get_fileSuccessState());
      get_file_pending = GetFileModel.fromJson(value.data);

    }).catchError((error) {
      print(error.toString());
      emit(get_fileErrorState());
    });
  }

  ///////////////////////////////////////////  change_file_status
  void change_file_status({
    required status,
    required fileId,
  }) {
    emit(LoadingState());
    DioHelper.postData(
        url: baseurl + change_status,
        data: {'file_id': fileId, 'status': status, })
        .then((value) {
      emit(add_groupSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(add_groupErrorState());
    });
  }

  ///////////////////////////////////////////  check_in_files
  void check_in_files({
    required group_id,
    required files,

  }) {
    emit(LoadingState());
    DioHelper.postData(
        url: baseurl + "/check_in_files",
        data: {'group_id': group_id, 'files': files})
        .then((value) {
      emit(check_in_filesSuccessState());
    }).catchError((error) {
      print('Error: ${error.toString()}');
      if (error is DioError) {
        print('Dio error: ${error.response?.data}');
      }
      emit(check_in_filesErrorState());
    });
  }



///////////////////////////////////////////  search
  List<DataUser> searchResults = [];

  Future<void> serch_name(dynamic name) async {
    searchResults.clear();

    if (name.isEmpty) {
      searchResults.clear();
      searchResults = List.from(getUsersearch); // إرجاع جميع الأعضاء
      emit(SerchSuccessState(searchResults));
    }
    {
      searchResults.clear();
      emit(SerchState());
      print("aaaaaaaaaaaaaaaaaaaa${getUsersearch!.length}");

      getUsersearch.forEach((element) {
        if (element.name!.toLowerCase().contains(name.toLowerCase())) {
          searchResults.add(element);
          // getUsersearch= searchResults;
        }
        emit(SerchSuccessState(searchResults));
      });
      print("aaaaaaaaaaaaaaaaaaaa${searchResults.length}");
      print(searchResults.length);
    }
  }

  ///////////////////////////////////////////  get_groups

  GetGroupsModel? get_group;
  void get_groups() {
    emit(LoadingState());
    DioHelper.getData(
      url: baseurl + getgroups,
    ).then((value) {
      get_group = GetGroupsModel.fromJson(value.data);

      emit(get_groupsSuccessState());
      print(value.data);
    }).catchError((error) {
      print(error.toString());
      emit(get_groupsErrorState());
    });
  }

  ////////////////////////////////////// leave_group
  void leave_group({
    required groupId,
  }) {
    emit(LoadingState());
    DioHelper.postData(
        url: baseurl + "/leave_group",
        data: {'groupId': groupId  })
        .then((value) {
      emit(leave_groupSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(leave_groupErrorState());
    });

  }


  ///////////////////////////////
  GetFileModel?  get_file_user_ingroup_reserved;
  GetFileModel?  get_file_user_ingroup_free;
  GetFileModel?  get_file_user_ingroup;


  void get_file_user(
  {required userId,
  required f_r,
  required groupeId}
      ) {
    print(f_r);
    print(groupeId);
    print(userId);

    emit(LoadingState());
    DioHelper.getData(
      url: baseurl + "/get_user_files?groupId=$groupeId&userId=$userId&status=$f_r",
    ).then((value) {
      f_r=="free"?
      get_file_user_ingroup_free = GetFileModel.fromJson(value.data):
      f_r=="reserved"?
      get_file_user_ingroup_reserved = GetFileModel.fromJson(value.data)
:      get_file_user_ingroup= GetFileModel.fromJson(value.data);



      emit(get_groupsSuccessState());
      print(value.data);
    }).catchError((error) {
      if (error is DioException) {
        print('Dio error type: ${error.type}');
        print('Dio error message: ${error.response}');
      }      emit(get_groupsErrorState());
    });
  }


  Future<void> downloadf(String fileurl)async {
    emit(LoadingState());



    DioHelper.getdo(url: 'https://cors-anywhere.herokuapp.com/'+ fileurl)
        .then((value) async {
      emit(leave_groupSuccessState());

      // تحويل البيانات إلى Base64
      final _base64 = base64Encode(value.data);

      // إنشاء الرابط لتحميل الملف باستخدام بيانات Base64
      final anchor = html.AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
        ..target = 'blank';

      // إضافة اسم الملف
      if (fileurl != null) {
        anchor.download = "downloadName";  // أو استخدم fileurl.split('/').last لاستخراج اسم الملف من الرابط
      }

      // بدء تحميل الملف
      anchor.click();
      anchor.remove();
      return;
    }).catchError((error) {
      print(fileurl);
      print("خطأ في طلب Dio: ${error.toString()}");
      print('Dio error: ${error.response?.data}');
      emit(leave_groupErrorState());
    });
  }


  // void downloadf(String fileurl){
  //   emit(LoadingState());
  //
  //   DioHelper.getdo(url: "https://cors-anywhere.herokuapp.com/"+fileurl) .then((value) async {
  //     emit(leave_groupSuccessState());
  //     // final blob = await value.data.stream();
  //     // final urlBlob = html.Url.createObjectUrlFromBlob(blob);
  //     //
  //     // // إنشاء رابط لتحميل الملف
  //     // final anchor = html.AnchorElement(href: urlBlob)
  //     //   ..target = 'none'
  //     //   ..download = fileurl.split('/').last;
  //     //
  //     // // محاكاة النقر على الرابط لتنزيل الملف
  //     // anchor.click();
  //     //
  //     // // تنظيف الـ Blob بعد التنزيل
  //     // html.Url.revokeObjectUrl(urlBlob);
  //     //
  //     //
  //     ////////////
  //     // Encode our file in base64
  //     final _base64 = base64Encode(value.data);
  //     // Create the link with the file
  //     final anchor =
  //     html.AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
  //       ..target = 'blank';
  //     // add the name
  //     if (fileurl != null) {
  //       anchor.download = "downloadName";
  //     }
  //     // trigger download
  //     // document.body.append(anchor);
  //     anchor.click();
  //     anchor.remove();
  //     return;
  //
  //
  //
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(leave_groupErrorState());
  //   });
  //
  //
  // }


}
