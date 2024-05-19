import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proj_app/core/commons/commons.dart';
import 'package:proj_app/features/admin/presentation/views/admin_manage_doctor.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> addDoctor() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/doctors/store';
    final String token = 'YOUR_AUTH_TOKEN'; // Replace with your actual token

    final Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    // Perform field validations
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        experienceController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    // Validate phone number
    if (!phoneController.text.startsWith('0') ||
        phoneController.text.length != 11) {
      _showSnackBar('Phone number must be 11 digits');
      return;
    }

    // Validate years of experience
    final int? yearsOfExperience = int.tryParse(experienceController.text);
    if (yearsOfExperience == null ||
        yearsOfExperience < 1 ||
        yearsOfExperience > 100) {
      _showSnackBar('Years of experience must be an integer between 1 and 100');
      return;
    }

    // Validate email format
    if (!emailController.text.endsWith('@gmail.com')) {
      _showSnackBar('Invalid email format');
      return;
    }

    // Validate password length
    if (passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'name': nameController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'years_of_experience': experienceController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      // Handle the response here
      // You can show a success message or navigate to another screen
      _showSnackBar('Doctor added successfully');
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return AdminScreen();
      }));
    } catch (error) {
      // Handle the error here
      _showSnackBar('Failed to add doctor');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff39D2C0),
        key: _scaffoldKey,
        body: Center(
            child: Stack(children: [
          Positioned(
            child: Image.asset(
              'assets/images/male-doctor-portrait-isolated-white-background-56744085-removebg-preview 1.png',
              width: double.infinity,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 170,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: experienceController,
                    decoration: InputDecoration(
                        labelText: 'Years of Experience',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff39D2C0))),
                    onPressed: addDoctor,
                    child: Text(
                      'Add Doctor',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])));
  }
}


/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proj_app/core/commons/commons.dart';

import '../../../../core/widget/text_form.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> addDoctor() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/doctors/store';
    final String token = 'YOUR_AUTH_TOKEN'; // Replace with your actual token

    final Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    // Perform field validations
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        experienceController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    if (!emailController.text.endsWith('@gmail.com')) {
      _showSnackBar('Invalid email format');
      return;
    }

    if (phoneController.text.length != 11) {
      _showSnackBar('Phone number must be 11 digits');
      return;
    }

    if (passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }
    final int? yearsOfExperience = int.tryParse(experienceController.text);
    if (yearsOfExperience == null ||
        yearsOfExperience < 1 ||
        yearsOfExperience > 30) {
      _showSnackBar('Years of experience must be an integer between 1 and 30');
      return;
    }

    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'name': nameController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'years_of_experience': experienceController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      print(response.data);
      // Handle the response here
      // You can show a success message or navigate to another screen
      _showSnackBar('Doctor added successfully');
    } catch (error) {
      print(error.toString());
      // Handle the error here
      _showSnackBar('Failed to add doctor');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff39D2C0),
        key: _scaffoldKey,
        body: Center(
            child: Stack(children: [
          Positioned(
            child: Image.asset(
              'assets/images/male-doctor-portrait-isolated-white-background-56744085-removebg-preview 1.png',
              width: double.infinity,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 170,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      focusColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //CustomTextForm(hintText:'' , controller: , label: '', onpressed: () {  },),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: experienceController,
                    decoration: InputDecoration(
                        labelText: 'Years of Experience',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        focusColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff39D2C0))),
                    onPressed: addDoctor,
                    child: Text(
                      'Add Doctor',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])));
  }
}*/



/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proj_app/core/widget/text_form.dart';
import 'package:proj_app/features/doctor/data/doctor_login_cubit/login_cubit.dart';
import 'package:proj_app/features/doctor/data/doctor_login_cubit/login_state.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorForm extends StatefulWidget {
  @override
  _DoctorFormState createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  final TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final TextEditingController specializationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff39D2C0),
        appBar: AppBar(
          title: Text('Add Doctor',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        body: Center(
          child: Stack(
            children: [
              Positioned(
                child: Image.asset(
                  'assets/images/male-doctor-portrait-isolated-white-background-56744085-removebg-preview 1.png',
                  width: double.infinity,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      final loginBlocProvide =
                          BlocProvider.of<LoginCubit>(context);

                      return Form(
                        key: loginKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 220,
                                  ),
                                  SizedBox(height: 13),
                                  CustomTextForm(
                                    hintText: 'name',
                                    controller: nameController,
                                    label: 'Name',
                                    validate: (data) {
                                      if (data!.isEmpty) {
                                        return 'please Enter Valid Name ';
                                      }
                                      return null;
                                    },
                                    onpressed: () {},
                                  ),
                                  SizedBox(height: 13),
                                  CustomTextForm(
                                    validate: (data) {
                                      if (data!.isEmpty ||
                                          !data.contains('@gmail.com')) {
                                        return 'please Enter Valid Email';
                                      }
                                    },
                                    hintText: 'Email',
                                    controller: emailController,
                                    onpressed: () {},
                                    label: 'Email',
                                  ),
                                  SizedBox(height: 13),
                                  TextFormField(
                                    validator: (data) {
                                      if (data!.length != 11 || data.isEmpty) {
                                        return 'please Enter Valid Phone';
                                      }
                                      return null;
                                    },
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Phone',
                                      hintText: 'Phone',
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                  CustomTextForm(
                                    hintText: 'Password',
                                    controller: passwordController,
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
                                  SizedBox(height: 13),
                                  CustomTextForm(
                                    hintText: 'Confirm Password',
                                    controller: confirmpasswordController,
                                    label: 'Confirm Password',
                                    isPassword: loginBlocProvide.isvisible,
                                    icon: loginBlocProvide.suffixIcoon,
                                    validate: (data) {
                                      if (data!.isEmpty ||
                                          data != passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    onpressed: () {
                                      loginBlocProvide.changepassVisivility();
                                    },
                                  ),
                                  SizedBox(height: 50),
                                 /* ElevatedButton(
                                    onPressed: () {
                                      if (loginKey.currentState!.validate()) {
                                        DoctorRepository.addDoctor(
                                          Doctor(
                                            name: nameController.text,
                                            specialization:
                                                specializationController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phone: phoneController.text,
                                          ),
                                        );
                                        Navigator.pop(
                                            context); // Close the form after adding a doctor
                                      }
                                    },
                                    child: Text('Add Doctor',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}*/












/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proj_app/core/widget/text_form.dart';
import 'package:proj_app/features/tasks/presentation/cubit/login_cubit.dart';
import 'package:proj_app/features/tasks/presentation/cubit/login_state.dart';
import 'package:proj_app/features/tasks/presentation/screens/model.dart';
import 'package:proj_app/features/tasks/presentation/screens/rep.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorForm extends StatefulWidget {
  @override
  _DoctorFormState createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  final TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final TextEditingController specializationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Doctor',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  transform: GradientRotation(6.7),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0XFF31A7FB).withOpacity(.2),
                    Color(0xFFFFFFFF),
                    Color(0xffF9F6F6),
                    Color(0xff0EBE7F).withOpacity(.6)
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 220,
            foregroundDecoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        'assets/images/male-doctor-portrait-isolated-white-background-56744085-removebg-preview 1.png'))),
          ),
          Center(
            child: SingleChildScrollView(
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final loginBlocProvide = BlocProvider.of<LoginCubit>(context);

                  return Form(
                    key: loginKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 220,
                              ),
                              TextField(
                                controller: nameController,
                                decoration:
                                    InputDecoration(labelText: 'Doctor Name'),
                              ),
                              SizedBox(height: 13),
                              CustomTextForm(
                                validate: (data) {
                                  if (data!.isEmpty ||
                                      !data.contains('@gmail.com')) {
                                    return 'please Enter Valid Email';
                                  }
                                },
                                hintText: 'Email',
                                controller: emailController,
                                onpressed: () {},
                                label: 'Email',
                              ),
                              SizedBox(height: 13),
                              CustomTextForm(
                                hintText: 'phone',
                                controller: passwordController,
                                label: 'Phone',
                                validate: (data) {
                                  if (data!.length < 11 || data.isEmpty) {
                                    return 'please Enter Valid Phone';
                                  }
                                  return null;
                                },
                                onpressed: () {},
                              ),
                              SizedBox(height: 13),
                              CustomTextForm(
                                hintText: 'Password',
                                controller: passwordController,
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
                              SizedBox(height: 13),
                              TextField(
                                controller: confirmpasswordController,
                                decoration: InputDecoration(
                                    labelText: 'Confirm Password'),
                              ),
                              SizedBox(height: 50),
                              ElevatedButton(
                                onPressed: () {
                                  if (loginKey.currentState!.validate()) {
                                    DoctorRepository.addDoctor(
                                      Doctor(
                                        name: nameController.text,
                                        specialization:
                                            specializationController.text,
                                        email: nameController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text,
                                      ),
                                    );
                                    Navigator.pop(
                                        context); // Close the form after adding a doctor
                                  }
                                },
                                child: Text('Add Doctor',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
