import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/state.dart';


class adminCubit extends Cubit<adminSates> {
  adminCubit() : super(LoginInitialState());


}
