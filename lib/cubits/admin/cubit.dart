import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/state.dart';

import '../../models/get_file_admain.dart';
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
      print(value.data);
    }).catchError((error) {
      if (error is DioException) {
        // الطباعة بطريقة مفصلة
        print('Dio error type: ${error.type}');
        if (error.response != null) {
          print('Dio error response: ${error.response}');
        } else {
          print('No response data');
        }
        print('Dio error message: ${error.message}');
      } else {
        // في حال كان هناك نوع آخر من الأخطاء
        print('Error: $error');
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
      get_group = GetGroupAdminModel.fromJson(value.data);

      emit(get_groupsSuccessState());
      print(value.data);
    }).catchError((error) {
      if (error is DioException) {
        // الطباعة بطريقة مفصلة
        print('Dio error type: ${error.type}');
        if (error.response != null) {
          print('Dio error response: ${error.response}');
        } else {
          print('No response data');
        }
        print('Dio error message: ${error.message}');
      } else {
        // في حال كان هناك نوع آخر من الأخطاء
        print('Error: $error');
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
      emit(userSuccessState());

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
      url: baseurladmain +"/get_group_users?groupId=$id",
    ).then((value) {
      emit(userSuccessState());
      getUsergroup = GetUserGroup.fromJson(value.data);




    }).catchError((error) {
      print(error.toString());
      emit(userErrorState());
    });
  }







}
