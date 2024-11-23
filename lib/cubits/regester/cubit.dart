import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/regester/state.dart';
import '../../../network/end_point.dart';
import '../../network/dio_helper.dart';


class registerCubit extends Cubit<registerSates>{

  registerCubit():super(LoginInitialState());
  static registerCubit get(context)=>BlocProvider.of(context);
///////////////////////// sign up
  void SignUp({
    required  email,
    required  password,
    required  c_password,
    required  address,
    required  name,
    required  phone,
    required String? photo,
    required  gender,

  }){
    emit(SignupLoadingState());
    DioHelper.postData(
        url: baseurl+'/user/signup',
        data: {
          'email':email,
          'password':password,
          'c_password':c_password,
          'address':address,
          'name':name,
          'phone':phone,
          'gender':gender,
          'photo':photo,
        }
    ).then((value) {
      print(value.data);
      emit(SignupSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SignupErrorState());
    });
  }




}