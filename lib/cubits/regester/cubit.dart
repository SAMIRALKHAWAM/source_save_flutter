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
    DioHelper.postData(url: baseurl + Login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      loginmodel = LoginModel.fromJson(value.data);
      print(value.data);
      emit(LoginSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState());
    });
  }
}
