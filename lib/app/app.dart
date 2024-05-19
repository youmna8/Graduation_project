import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages

import 'package:proj_app/core/bloc/cubit/global_cubit.dart';
import 'package:proj_app/core/bloc/cubit/global_state.dart';

import 'package:proj_app/core/theme/theme_app.dart';
import 'package:proj_app/features/Splash/presentation/views/splach_screen.dart';
import 'package:proj_app/features/admin/presentation/views/admin_fill_doc_form.dart';
import 'package:proj_app/features/admin/presentation/views/admin_manage_doctor.dart';
import 'package:proj_app/features/admin/presentation/views/doc_lis.dart';
import 'package:proj_app/features/doctor/presentation/views/appointment.dart';
import 'package:proj_app/features/doctor/presentation/views/bottom_navigation_bar.dart';
import 'package:proj_app/features/doctor/presentation/views/patientsss_list_api.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';
import 'package:proj_app/features/home/presentation/screens/docoradmin.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) =>
          BlocBuilder<GlobalCubit, GlobalState>(builder: (context, state) {
        return MaterialApp(
          theme: getAppTheme(),
          debugShowCheckedModeBanner: false,
          home: MyBottomNavigationBar(),
        );
      }),
    );
  }
}









//nyemer59
//nyemer59