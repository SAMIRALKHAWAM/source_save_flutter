import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/regester/state.dart';
import '../../../network/end_point.dart';
import '../../models/login_model.dart';
import '../../network/dio_helper.dart';

class registerCubit extends Cubit<registerSates> {
  registerCubit() : super(LoginInitialState());
  static registerCubit get(context) => BlocProvider.of(context);
  late LoginModel loginmodel;
///////////////////////// sign up

  void SignUp({
    required email,
    required password,
    required c_password,
    required name,
  }) {
    emit(SignupLoadingState());
    DioHelper.postData(url: baseurl + register, data: {
      'email': email,
      'password': password,
      'password_confirmation': c_password,
      'name': name,
    }).then((value) {
      print(value.data);
      emit(SignupSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SignupErrorState());
    });
  }

  ///////////////////////////// sign in
  void SignIn({
    required email,
    required password,

  }) {
    emit(LoginLoadingState());
    DioHelper.postData(url: baseurl + login, data: {
      'email': email,
      'password': password,
      'fcm_token':fcm_token
    }).then((value) {
      loginmodel = LoginModel.fromJson(value.data);
      print(value.data);
      print("Generated FCM Token: $fcm_token");

      emit(LoginSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        print('Dio error type: ${error.type}');
        print('Dio error message: ${error.response}');
      }

      print(error.toString());
      emit(LoginErrorState());
    });
  }

///////////////////////////////////////////  resend_otp


  void resend_otp({
    required String email,
  }){
    emit(ForgetLoadingState());
    DioHelper.postData(
        url: baseurl+resendotp,
        data: {
          'email':email,
        }
    ).then((value) {
      print(value.data);
      emit(ForgetSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ForgetErrorState());
    });
  }
///////////////////////////////////////////  verify_account


  void verify_account({
    required String code,
    required String email,
  }){
    emit(CodeLoadingState());
    DioHelper.postData(
        url: baseurl+verifyaccount,
        data:{
          "email": email,
          "code": code}
    ).then((value){
      emit(CodeSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(CodeErrorState());

    });
  }

///////////////////////////////////////////  resetpassword

  void resetpassword({
    required  code,
    required String email,
    required String password,
    required String c_password,
  }){
    emit(ResetLoadingState());
    DioHelper.postData(
        url: baseurl+reset_password,
        data:{
          "email":email,
          "code": code,
          "password": password,
          "password_confirmation":c_password
        }
    ).then((value){
      emit(ResetSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ResetErrorState());

    });
  }

  ////////////////////////  logout
  void log_out() {
    emit(LogoutSuccessState());
    DioHelper.postData(
      url: baseurl + logout,
    ).then((value) {
      print(value.data);
      print("logout succsess");
      emit(LogoutSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LogoutErrorState());
    });
  }

}
