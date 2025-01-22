import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/cubit.dart';
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
  Widget startwidget;
  WidgetsFlutterBinding.ensureInitialized();

  ///////////////
  await Firebase.initializeApp(
    options: FirebaseOptions(

        apiKey: "AIzaSyAomavWmzEEkSAnAmVMxXVx_Cpkz5dUnF0",
        authDomain: "sourcesave-31966.firebaseapp.com",
        projectId: "sourcesave-31966",
        storageBucket: "sourcesave-31966.firebasestorage.app",
        messagingSenderId: "452046149500",
        appId: "1:452046149500:web:4dbf88044dac13031ff6f9"

    ),
  );


  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );



  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // await messaging.requestPermission();
  // await messaging.setAutoInitEnabled(true);




  fcm_token = await
  messaging.getToken(vapidKey: "BKy2z6NS818o11IMKWbkh9a2nl3p4ZFu2PW-tEwdmN_dMKEWohQB9zcrYLaDCGnOru8UFW-bfHFDEVPxHOTqrbM");





  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground Notification Received: ${message.notification?.title}');
    print('Message Data: ${message.data}');

  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Notification Clicked: ${message.notification?.title}');
  });




  print("FCM Token: $fcm_token");

/////////


  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer=MyBlocObserver();
  DioHelper.init();
  await CachHelper.init();
  token=CachHelper.getData(key: "token");
  id=CachHelper.getData(key: "id");
  print(token);
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
        BlocProvider(create: (BuildContext context) =>adminCubit()),


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

