import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/app/cubit.dart';
import 'package:source_safe/screen/app/HomeScreen.dart';
import 'package:source_safe/screen/regester/login.dart';

import 'cubits/regester/cubit.dart';
import 'network/bloc_observer.dart';
import 'network/cash_helper.dart';
import 'network/dio_helper.dart';
import 'network/end_point.dart';

void main() async{
  Widget startwidget;
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer=MyBlocObserver();
  DioHelper.init();
  await CachHelper.init();
  // token=CachHelper.getData(key: "token");
  token !=null?startwidget=HomeScreen():startwidget=Login();
  runApp( MyApp(startwidget: startwidget,));
}

class MyApp extends StatelessWidget {
   MyApp({required this.startwidget});
   Widget startwidget;


   @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) =>registerCubit()),
        BlocProvider(create: (BuildContext context) =>AppCubit()),


      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'file App',
        theme: ThemeData(
      
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:startwidget,
      ),
    );
  }
}

