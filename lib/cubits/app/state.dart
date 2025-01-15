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

class get_fileSuccessState extends AppSates{}
class get_fileErrorState extends AppSates{}

class check_in_filesSuccessState extends AppSates{}
class check_in_filesErrorState extends AppSates{}

class get_groupsSuccessState extends AppSates{}
class get_groupsErrorState extends AppSates{}



class leave_groupSuccessState extends AppSates{}
class leave_groupErrorState extends AppSates{}


class SerchState extends AppSates {}
class SerchSuccessState extends AppSates {
  final List<DataUser> results;
  SerchSuccessState(this.results);

}