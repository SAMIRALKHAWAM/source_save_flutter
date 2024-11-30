import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/app/state.dart';
import '../../../network/end_point.dart';
import '../../models/get_user_model.dart';
import '../../models/login_model.dart';
import '../../network/dio_helper.dart';

class AppCubit extends Cubit<AppSates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
 late GetUser getUser;
  /////Get Users
void getUsers(){
  emit(LoadingState());
  DioHelper.getData(url: baseurl+get_users,

  ).then((value){
    emit(userSuccessState());
    getUser = GetUser.fromJson(value.data);

    print(value.data);
  }).catchError((error) {
    print(error.toString());
    emit(userErrorState());
  });
}
  
  
  
}
