
import 'package:get_it/get_it.dart';
import 'package:proj_app/core/bloc/cubit/global_cubit.dart';
import 'package:proj_app/core/database/cache_helper.dart';
import 'package:proj_app/features/doctor/data/doctor_login_cubit/login_cubit.dart';
import 'package:proj_app/features/patient/presentation/view_model/cubit/patient_cubit_cubit.dart';

final sl = GetIt.instance;
void initServiceIndicator() {
  sl.registerLazySingleton(() => GlobalCubit());
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => LoginCubit());
  sl.registerLazySingleton(() => PatientCubitCubit());
}
