import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/app/state.dart';
import '../../../network/end_point.dart';
import '../../models/get _permission_model.dart';
import '../../models/get_user_model.dart';
import '../../models/login_model.dart';
import '../../network/dio_helper.dart';

class AppCubit extends Cubit<AppSates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  GetUser? getUser;
  List<DataUser> getUsersearch=[];
  ///////////////////////Get Users
void getUsers(){
  emit(LoadingState());
  DioHelper.getData(url: baseurl+get_users,

  ).then((value){
    emit(userSuccessState());
    getUser = GetUser.fromJson(value.data);
    getUser!.data!.forEach((element) {
      getUsersearch.add(element);});
    searchResults = List.from(getUsersearch); // إرجاع جميع الأعضاء

    print(value.data);
  }).catchError((error) {
    print(error.toString());
    emit(userErrorState());
  });
}
///////////////////////////////////////
  GetPremmetion? getpermissions;
  void get_permissions(){
    emit(LoadingState());
    DioHelper.getData(url: baseurl+premmetion,

    ).then((value){
      emit(get_permissionsSuccessState());
      getpermissions = GetPremmetion.fromJson(value.data);
      print(value.data);
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

  }){
    emit(LoadingState());
    DioHelper.postData(url: baseurl+addgroup,data: {
      'name':name,
      'users':userId,
      'permissions':perId
    }).then((value){
      print(value.data);
      emit(add_groupSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(add_groupErrorState());
    });

  }


  List<DataUser> searchResults = [];

  Future<void> serch_name (dynamic name)async{

    searchResults.clear();

    if(name.isEmpty){
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


}
