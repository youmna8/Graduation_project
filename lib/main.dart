import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proj_app/app/app.dart';
import 'package:proj_app/core/bloc/cubit/global_cubit.dart';
import 'package:proj_app/core/database/cache_helper.dart';
import 'package:proj_app/core/services/service.dart';

import 'package:proj_app/features/doctor/data/doctor_login_cubit/login_cubit.dart';
import 'package:proj_app/features/patient/presentation/view_model/cubit/patient_cubit_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await DoctorRepository.loadDoctorsFromPrefs();
  initServiceIndicator();
  await sl<CacheHelper>().init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GlobalCubit>()..getCachedLang(),
        ),
        BlocProvider(
          create: (context) => sl<LoginCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<PatientCubitCubit>(),
        ),
      ],
      child: MyApp(),
    ),
  );
}










//yomna234@fci.bu.edu.eg
//0xSheko
//FBFOzivq6YiX3I3I
//0x0xguru
//https://youtu.be/lkqEgjn-oXI?si=yDrArz-MIhPXSWSP
//https://youtu.be/RF2VYJTNjRM?si=j1WNCIM9kKQHPhRv