import '../../models/get_user_model.dart';

abstract class AppSates{}
class AppInitialState extends AppSates{}

class LoadingState extends AppSates{}
class userSuccessState extends AppSates{}
class userErrorState extends AppSates{}

class get_permissionsSuccessState extends AppSates{}
class get_permissionsErrorState extends AppSates{}

class add_groupSuccessState extends AppSates{}
class add_groupErrorState extends AppSates{}

class add_fileSuccessState extends AppSates{}
class add_fileErrorState extends AppSates{}


class SerchState extends AppSates {}
class SerchSuccessState extends AppSates {
  final List<DataUser> results;
  SerchSuccessState(this.results);

}