import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/views/login_screen.dart';
import 'package:proj_app/features/admin/presentation/views/admin_login.dart';
import 'package:proj_app/features/patient/presentation/view/patient_login.dart';

class AdminORDoctor extends StatefulWidget {
  const AdminORDoctor({super.key});

  @override
  State<AdminORDoctor> createState() => _AdminORDoctorState();
}

class _AdminORDoctorState extends State<AdminORDoctor> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xff39D2C0),
          body: Center(
              child: Column(children: [
            Stack(children: [
              Padding(
                padding: EdgeInsets.only(top: 110),
                child: Container(
                  foregroundDecoration: BoxDecoration(
                      image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/22222.png')),
                      borderRadius: BorderRadius.circular(20)),
                  height: 250,
                  width: 300,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                  ),
                ),
              )
            ]),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                height: 390,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Please tell us are you ',
                        style: TextStyle(
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'RobotoMono-VariableFont_wght',
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xff39D2C0))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return AdminloginScreen();
                              },
                            ),
                          );
                        },
                        child: Text('Admin',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMono-VariableFont_wght',
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xff39D2C0))),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return DoctorLoginScreen();
                          }));
                        },
                        child: Text('Doctor',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMono-VariableFont_wght',
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xff39D2C0))),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return PatientLoginScreen();
                          }));
                        },
                        child: Text('Patient',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoMono-VariableFont_wght',
                                color: Colors.white))),
                  ],
                ))
          ])),
        ));
  }
}
/*
Stack(children: [
        Container(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/boba-online-consultation-with-doctor-via-smartphone-1.png',
              width: 210,
              height: 400,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'please tell us Are you',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 3, 169, 127))),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return LoginScreen();
                          }));
                        },
                        child: Text('Doctor',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 3, 169, 127))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return AdminloginScreen();
                              },
                            ),
                          );
                        },
                        child: Text('Admin',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)))
                  ],
                )
              ],
            )
          ],
        ),
      ])*/