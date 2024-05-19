import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proj_app/core/widget/elevated_button.dart';
import 'package:proj_app/core/widget/text_form.dart';
import 'package:proj_app/features/patient/presentation/view/patient_homepage_screen.dart';
import 'package:proj_app/features/patient/presentation/view_model/cubit/patient_cubit_cubit.dart';

class PatientLoginScreen extends StatelessWidget {
  const PatientLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff39D2C0),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Welcome Back!',
                style: TextStyle(
                    fontSize: 33,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Spirax-Regular',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
              ),
              SingleChildScrollView(
                  child: BlocConsumer<PatientCubitCubit, PatientCubitState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        final loginBlocProvide =
                            BlocProvider.of<PatientCubitCubit>(context);
                        return Form(
                            key: loginBlocProvide.patientloginKey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CustomTextForm(
                                    prefixIcon: Icon(Icons.email),
                                    validate: (data) {
                                      if (data!.isEmpty ||
                                          !data.contains('@gmail.com')) {
                                        return 'please Enter Valid Email';
                                      }
                                    },
                                    hintText: 'Email',
                                    controller: loginBlocProvide.patientemail,
                                    onpressed: () {},
                                    label: 'Email',
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextForm(
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Password',
                                    controller: loginBlocProvide.patientPass,
                                    label: 'Password',
                                    onpressed: () {
                                      loginBlocProvide.changepassVisivility();
                                    },
                                    isPassword: loginBlocProvide.isvisible,
                                    validate: (data) {
                                      if (data!.length < 6 || data.isEmpty) {
                                        return 'please Enter Valid Password';
                                      }
                                      return null;
                                    },
                                    icon: loginBlocProvide.suffixIcoon,
                                  ),
                                  SizedBox(
                                    height: 120,
                                  ),
                                  MyElevatedButton(
                                    text: 'Sign in',
                                    onPressed: () {
                                      if (loginBlocProvide
                                          .patientloginKey.currentState!
                                          .validate()) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return PatientHome();
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 55.h,
                                  ),
                                ],
                              ),
                            ));
                      }))
            ]),
          ),
        ),
      ),
    );
  }
}
