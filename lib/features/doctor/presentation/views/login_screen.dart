import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proj_app/core/commons/commons.dart';
import 'package:proj_app/features/doctor/presentation/views/bottom_navigation_bar.dart';

class DoctorLoginScreen extends StatefulWidget {
  @override
  _DoctorLoginScreenState createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final Dio _dio = Dio();
  final String _apiUrl = 'http://127.0.0.1:8000/api/doctor_login';
  final String _token = 'YOUR_BEARER_TOKEN'; // Replace with your actual token
  bool _passwordVisible = false; // Track password visibility

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginDoctor() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      // Validate email and password
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email and password are required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Response response = await _dio.post(
        _apiUrl,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        String message = response.data['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
        );
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 35,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Spirax-Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordVisible,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff39D2C0)),
                      ),
                      onPressed: _loginDoctor,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proj_app/core/commons/commons.dart';
import 'package:proj_app/features/doctor/presentation/views/bottom_navigation_bar.dart';

class DoctorLoginScreen extends StatefulWidget {
  @override
  _DoctorLoginScreenState createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final Dio _dio = Dio();
  final String _apiUrl = 'http://127.0.0.1:8000/api/doctor_login';
  final String _token = 'YOUR_BEARER_TOKEN'; // Replace with your actual token

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginDoctor() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      Response response = await _dio.post(
        _apiUrl,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        String message = response.data['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
        );
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff39D2C0),
        resizeToAvoidBottomInset: false,
        body: Center(
            child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                  fontSize: 35,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Spirax-Regular',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff39D2C0))),
                    onPressed: _loginDoctor,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )));
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proj_app/core/widget/elevated_button.dart';
import 'package:proj_app/core/widget/text_form.dart';
import 'package:proj_app/features/doctor/data/doctor_login_cubit/login_cubit.dart';
import 'package:proj_app/features/doctor/data/doctor_login_cubit/login_state.dart';
import 'package:proj_app/features/doctor/presentation/views/bottom_navigation_bar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xff39D2C0),
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                            fontSize: 35,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Spirax-Regular',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      SingleChildScrollView(
                        child: BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              final loginBlocProvide =
                                  BlocProvider.of<LoginCubit>(context);
                              return Form(
                                  key: loginBlocProvide.loginKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Column(
                                        children: [
                                          CustomTextForm(
                                            prefixIcon: Icon(Icons.email),
                                            validate: (data) {
                                              if (data!.isEmpty ||
                                                  !data
                                                      .contains('@gmail.com')) {
                                                return 'please Enter Valid Email';
                                              }
                                            },
                                            hintText: 'Email',
                                            controller: loginBlocProvide.login,
                                            onpressed: () {},
                                            label: 'Email',
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          CustomTextForm(
                                            prefixIcon: Icon(Icons.lock),
                                            hintText: 'Password',
                                            controller: loginBlocProvide.pass,
                                            label: 'Password',
                                            onpressed: () {
                                              loginBlocProvide
                                                  .changepassVisivility();
                                            },
                                            isPassword:
                                                loginBlocProvide.isvisible,
                                            validate: (data) {
                                              if (data!.length < 6 ||
                                                  data.isEmpty) {
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
                                                  .loginKey.currentState!
                                                  .validate()) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) {
                                                      return MyBottomNavigationBar();
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
                                    ]),
                                  ));
                            }),
                      )
                    ]),
              ),
            )));
  }
}*/
