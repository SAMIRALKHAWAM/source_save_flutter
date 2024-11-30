import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/regester/state.dart';
import '../../../network/end_point.dart';
import '../../network/dio_helper.dart';


class registerCubit extends Cubit<registerSates>{

  registerCubit():super(LoginInitialState());
  static registerCubit get(context)=>BlocProvider.of(context);
///////////////////////// sign up

  ///////////////////////////// sign in
  void SignIn({
    required  email,
    required  password,

  }){
    emit(LoginLoadingState());
    DioHelper.postData(
        url:baseurl,
        data: {
          'email':email,
          'password':password,
        }
    ).then((value) {
      print(value.data);
      emit(LoginSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(LoginErrorState());
    });
  }





}