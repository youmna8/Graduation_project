import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/views/patient_listt_body.dart';
import 'package:proj_app/features/admin/presentation/views/admin_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proj_app/features/admin/presentation/views/setting.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';
import 'package:proj_app/features/patient/presentation/view/healthcare.dart';
import 'package:proj_app/features/patient/presentation/view/report.dart';

class PatientHome extends StatefulWidget {
  @override
  _PatientHome createState() => _PatientHome();
}

class _PatientHome extends State<PatientHome> {
  int _currentIndex = 0;
  final List<Widget> _pages = [PatientReportScreen(), HealthCare()];
  static const List<String> _appBarTitles = [
    'Report',
    'About diseases',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff39D2C0),
          elevation: 2,
          centerTitle: true,
          title: Text(
            _appBarTitles[_currentIndex],
            style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: 'Spirax-Regular',
                fontWeight: FontWeight.bold),
          )),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(color: Color(0xff447055)),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.notesMedical,
              color: Color(0xff447055),
            ),
            label: 'Medical report',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 147, 166, 155),
            icon: Icon(FontAwesomeIcons.handHoldingMedical,
                color: Color(0xff447055)),
            label: 'Health care',
          ),
        ],
      ),
    );
  }
}
