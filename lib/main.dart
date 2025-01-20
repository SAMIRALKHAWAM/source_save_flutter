import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/app/cubit.dart';
import 'package:source_safe/screen/app/12.dart';
import 'package:source_safe/screen/app/HomeScreen.dart';
import 'package:source_safe/screen/regester/login.dart';

import 'cubits/regester/cubit.dart';
import 'network/bloc_observer.dart';
import 'network/cash_helper.dart';
import 'network/dio_helper.dart';
import 'network/end_point.dart';

void main() async{
  await EasyLocalization.ensureInitialized();

  Widget startwidget;
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer=MyBlocObserver();

  DioHelper.init();
  await CachHelper.init();
  token=CachHelper.getData(key: "token");
  id=CachHelper.getData(key: "id");

  token !=null?startwidget=HomeScreen():startwidget=Login();
  runApp(

      EasyLocalization(
        supportedLocales: [Locale('ar'),Locale('en')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child:  MyApp(startwidget: startwidget,),
      ),



     );
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
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        home:startwidget,
      ),
    );
  }
}

