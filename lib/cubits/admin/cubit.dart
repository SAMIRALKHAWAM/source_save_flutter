import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/state.dart';

import '../../models/get_file_admain.dart';
import '../../models/get_file_model.dart';
import '../../models/get_groups_model.dart';
import '../../models/get_user_group_model.dart';
import '../../models/get_user_model.dart';
import '../../network/dio_helper.dart';
import '../../network/end_point.dart';



class adminCubit extends Cubit<adminSates> {
  adminCubit() : super(LoginInitialState());
  static adminCubit get(context) => BlocProvider.of(context);


  ///////////////////////////////////////////  get_groups

  GetGroupAdminModel? get_group;
  void get_groups() {
    emit(LoadingState());
    DioHelper.getData(
      url: baseurladmain + "/get_groups?status=accepted",
    ).then((value) {
      get_group = GetGroupAdminModel.fromJson(value.data);

      emit(get_groupsSuccessState());
      // print(value.data);
    }).catchError((error) {
      if (error is DioException) {
        print('Dio error type: ${error.type}');
        print('Dio error message: ${error.response}');
      }


      print(error.toString());
      emit(get_groupsErrorState());
    });
  }


  ///////////////////////////////////////////  get_groups

  GetGroupAdminModel? get_group_p;
  void get_groups_p() {
    emit(LoadingState());
    DioHelper.getData(
      url: baseurladmain + "/get_groups?status=pending",
    ).then((value) {
      get_group_p = GetGroupAdminModel.fromJson(value.data);

      emit(get_groupsSuccessState());
      // print(value.data);
    }).catchError((error) {
      if (error is DioException) {
        print('Dio error type: ${error.type}');
        print('Dio error message: ${error.response}');
      }

      print(error.toString());
      emit(get_groupsErrorState());
    });
  }



  ///////////////////////Get Users
  GetUser? getUser;
  void getUsers() {

    emit(LoadingState());
    DioHelper.getData(
      url: baseurladmain + get_users,
    ).then((value) {
      getUser = GetUser.fromJson(value.data);
      emit(userSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(userErrorState());
    });
  }


  ///////////////////////Get Users group
  GetUserGroup? getUsergroup;
  void get_users_group({
    required id,

  }) {

    emit(LoadingState());
    DioHelper.getData(
      url: baseurladmain +"/get_group_users?groupId=$id",
    ).then((value) {
      emit(userSuccessState());
      getUsergroup = GetUserGroup.fromJson(value.data);
      // print(value.data);
    }).catchError((error) {
      print(error.toString());
      emit(userErrorState());
    });
  }

  ///////////////////////Get  groups Users
  GetGroupAdminModel? getgroupsuser;
  void get_groups_user({
    required id,

  }) {

    emit(LoadingState());
    DioHelper.getData(
      url: baseurladmain +"/get_user_groups?userId=$id",
    ).then((value) {
      emit(get_groupsSuccessState());
      getgroupsuser = GetGroupAdminModel.fromJson(value.data);
      // print(value.data);
    }).catchError((error) {
      print(error.toString());
      emit(get_groupsErrorState());
    });
  }


  ////////////////////////////
  void change_status({
    required status,
    required groupId,
  }) {
    emit(LoadingState());
    DioHelper.postData(url: baseurladmain + "/change_group_status?groupId=$groupId", data: {
      'status': status,
    }).then((value) {
      emit(changeSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(changeErrorState());
    });
  }


///////////////////////////////
  GetFileModel? get_file_user_ingroup_reserved;
  GetFileModel? get_file_user_ingroup_free;
  GetFileModel? get_file_user_ingroup;

  void get_file_user({required userId, required f_r, required groupeId}) {
    print(f_r);
    print(groupeId);
    print(userId);

    emit(LoadingState());
    DioHelper.getData(
      url: baseurladmain +
          "/get_user_files?groupId=$groupeId&userId=$userId&status=$f_r",
    ).then((value) {
      f_r == "free"
          ? get_file_user_ingroup_free = GetFileModel.fromJson(value.data)
          : f_r == "reserved"
          ? get_file_user_ingroup_reserved =
          GetFileModel.fromJson(value.data)
          : get_file_user_ingroup = GetFileModel.fromJson(value.data);

      emit(get_groupsSuccessState());
      print(value.data);
    }).catchError((error) {
      if (error is DioException) {
        print('Dio error type: ${error.type}');
        print('Dio error message: ${error.response}');
      }
      emit(get_groupsErrorState());
    });
  }






}
