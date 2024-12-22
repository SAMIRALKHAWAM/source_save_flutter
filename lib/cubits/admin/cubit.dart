import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/state.dart';

import '../../models/get_groups_model.dart';
import '../../network/dio_helper.dart';
import '../../network/end_point.dart';



class adminCubit extends Cubit<adminSates> {
  adminCubit() : super(LoginInitialState());
  static adminCubit get(context) => BlocProvider.of(context);


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


}
