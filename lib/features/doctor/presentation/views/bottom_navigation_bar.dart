import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proj_app/features/doctor/presentation/views/appointment.dart';
import 'package:proj_app/features/doctor/presentation/views/patient_list.dart';
import 'package:proj_app/features/admin/presentation/views/setting.dart';
import 'package:proj_app/features/doctor/presentation/views/patientsss_list_api.dart';
import 'package:proj_app/features/doctor/presentation/views/records.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    UploadAudioScreen(),
    Report(),
    Setting(),
    PatientListScreen(),
    Appointments()
  ];

  static const List<String> _appBarTitle = [
    'Upload audio',
    'Previous records',
    'Setting',
    'Patient list',
    'Appointments'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff39D2C0),
        elevation: 2,
        centerTitle: true,
        title: Text(
          _appBarTitle[_currentIndex],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Spirax-Regular',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff39D2C0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[300],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            label: 'Upload Audio',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.microphone),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patient List',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calendarCheck),
            label: 'Appointments',
          ),
        ],
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/views/appointment.dart';
import 'package:proj_app/features/doctor/presentation/views/patient_list.dart';
import 'package:proj_app/features/doctor/presentation/views/patient_listt_body.dart';
import 'package:proj_app/features/admin/presentation/views/admin_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proj_app/features/admin/presentation/views/setting.dart';
import 'package:proj_app/features/doctor/presentation/views/patientsss_list_api.dart';
import 'package:proj_app/features/doctor/presentation/views/records.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBar createState() => _MyBottomNavigationBar();
}

class _MyBottomNavigationBar extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    FileUploadScreen(),
    RecorsScreen(),
    Setting(),
    PatientListScreen(),
    Appointments()
  ];
  static const List<String> _appBarTitle = [
    'Upload audio',
    'previous records',
    'Setting',
    'Patient list',
    'Appointments'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xff39D2C0),
            elevation: 2,
            centerTitle: true,
            title: Text(
              _appBarTitle[_currentIndex],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Spirax-Regular',
                  fontWeight: FontWeight.bold),
            )),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.black,
          selectedLabelStyle: TextStyle(color: Colors.black),
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.cloud_upload,
                color: Color(0xff39D2C0),
              ),
              label: 'Upload audio',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(FontAwesomeIcons.microphone, color: Color(0xff39D2C0)),
              label: 'Records',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.person, color: Color(0xff39D2C0)),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(FontAwesomeIcons.bars, color: Color(0xff39D2C0)),
              label: 'Patients list',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(FontAwesomeIcons.calendarCheck,
                  color: Color(0xff39D2C0)),
              label: 'Appointment',
            ),
          ],
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proj_app/features/admin/presentation/views/setting.dart';
import 'package:proj_app/features/doctor/presentation/views/add_patient.dart';
import 'package:proj_app/features/doctor/presentation/views/patient_list.dart';
import 'package:proj_app/features/doctor/presentation/views/records.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../view_model/patient_model.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Patient> _patients = [];

  final List<String> _appBarTitles = [
    'Upload audio',
    'previous records',
    'Setting',
    'Patient list'
  ];

  final List<Widget> _pages = [
    FileUploadScreen(),
    RecorsScreen(),
    Setting(),
    NewPatientList()
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 100, 205, 179),
          elevation: 2,
          centerTitle: true,
          title: Text(
            _appBarTitles[_currentIndex],
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          )),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPatient = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPatientScreen()),
          );

          if (newPatient != null) {
            setState(() {
              _patients.add(newPatient);
            });
          }
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: Color.fromARGB(255, 100, 205, 179),

        icons: [
          Icons.cloud_upload,
          FontAwesomeIcons.microphone,
          Icons.settings,
          FontAwesomeIcons.list,
        ],

        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
          });
        },
        // Customize other properties as needed
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No Records'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Screen'),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proj_app/features/doctor/presentation/views/patient_listt_body.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _appBarTitles = [
    'Upload audio',
    'View your previous record',
    'Setting',
    'Patient list'
  ];

  final List<Widget> _pages = [
    FileUploadScreen(),
    SearchScreen(),
    MyHomePage(),
    PatientList()
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 205, 179),
        elevation: 2,
        centerTitle: true,
        title: AnimatedOpacity(
          opacity: _currentIndex == 0 ? 1 : 0, // Only show title for first item
          duration: Duration(milliseconds: 300),
          child: Text(
            _appBarTitles[_currentIndex],
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(_animation.value),
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor:
                  Color(0xff447055), // Change color of selected item
              unselectedItemColor:
                  Colors.black, // Change color of unselected items
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  if (_currentIndex == 0) {
                    _animationController.reverse();
                  } else {
                    _animationController.forward();
                  }
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.cloud_upload),
                  label: 'Upload audio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.microphone),
                  label: 'Records',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Setting',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.list),
                  label: 'Patient list',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No Records'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Screen'),
    );
  }
}*/






/*import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/views/patient_listt_body.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proj_app/features/admin/presentation/views/logout_screen.dart';
import 'package:proj_app/features/doctor/presentation/views/upload_audio.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    FileUploadScreen(),
    SearchScreen(),
    MyHomePage(),
    PatientList()
  ];
  static const List<String> _appBarTitles = [
    'Upload audio',
    'View your previous record',
    'setting',
    'Patient list'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 100, 205, 179),
          elevation: 2,
          centerTitle: true,
          title: Text(
            _appBarTitles[_currentIndex],
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          )),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cloud_download,
              color: Color(0xff447055),
            ),
            label: 'Upload audio',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.microphoneLines,
                color: Color(0xff447055)),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Color(0xff447055)),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.list, color: Color(0xff447055)),
            label: 'Patient list',
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No Records'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}*/
