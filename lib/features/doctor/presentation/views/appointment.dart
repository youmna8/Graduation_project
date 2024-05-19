import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  late List<Appointment> _appointments = [];
  late String _doctorName = '';
  final String BaseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();
    _fetchDoctorAppointments();
  }

  Future<void> _fetchDoctorAppointments() async {
    try {
      Dio dio = Dio();
      String apiUrl = '$BaseUrl/api/appointments/doctor_appointments/1';
      Response response = await dio.get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer YOUR_BEARER_TOKEN'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data['data'];
        setState(() {
          _doctorName = responseData['doctor_name'];
          _appointments = (responseData['refollow_dates'] as List)
              .map((appointmentJson) => Appointment.fromJson(appointmentJson))
              .toList();
        });
      } else {
        print(
            'Failed to fetch doctor appointments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor appointments: $e');
    }
  }

  Future<void> _addAppointment(int patientId, String refollowDate) async {
    try {
      Dio dio = Dio();
      String apiUrl = '$BaseUrl/api/appointments/store';
      Response response = await dio.post(
        apiUrl,
        data: {
          'patient_id': patientId,
          'refollow_date': refollowDate,
          'doc_id': 1, // Replace with the actual doctor ID
        },
        options: Options(
          headers: {'Authorization': 'Bearer YOUR_BEARER_TOKEN'},
        ),
      );

      if (response.statusCode == 201) {
        print('Appointment successfully created');
        // Refresh appointments list
        await _fetchDoctorAppointments();
      } else {
        print(
            'Failed to create appointment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _appointments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = _appointments[index];
                return AppointmentCard(
                  appointment: appointment,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Show form to add appointment
          _showAddAppointmentDialog();
        },
        child: Icon(
          Icons.add,
          color: Color(0xff39D2C0),
        ),
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int? patientId;
        String refollowDate = '';

        return AlertDialog(
          title: Text('Add Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Patient ID'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    patientId = int.tryParse(value);
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Refollow Date'),
                  onChanged: (value) {
                    refollowDate = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (patientId != null && refollowDate.isNotEmpty) {
                  _addAppointment(patientId!, refollowDate);
                  Navigator.pop(context);
                } else {
                  // Show error message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Please enter patient ID and refollow date'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Appointment {
  final int patientId;
  final String patientName;
  final String refollowDate;

  Appointment({
    required this.patientId,
    required this.patientName,
    required this.refollowDate,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      refollowDate: json['refollow_date'],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient: ${appointment.patientName}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Refollow Date: ${appointment.refollowDate}'),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  late List<Appointment> _appointments = [];
  late String _doctorName = '';

  @override
  void initState() {
    super.initState();
    _fetchDoctorAppointments();
  }

  Future<void> _fetchDoctorAppointments() async {
    try {
      Dio dio = Dio();
      String apiUrl =
          'http://127.0.0.1:8000/api/appointments/doctor_appointments/1';
      Response response = await dio.get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer YOUR_BEARER_TOKEN'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data['data'];
        setState(() {
          _doctorName = responseData['doctor_name'];
          _appointments = (responseData['refollow_dates'] as List)
              .map((appointmentJson) => Appointment.fromJson(appointmentJson))
              .toList();
        });
      } else {
        print(
            'Failed to fetch doctor appointments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor appointments: $e');
    }
  }

  Future<void> _addAppointment(int patientId, String refollowDate) async {
    try {
      Dio dio = Dio();
      String apiUrl = 'http://127.0.0.1:8000/api/appointments/store';
      Response response = await dio.post(
        apiUrl,
        data: {
          'patient_id': patientId,
          'refollow_date': refollowDate,
          'doc_id': 1, // Replace with the actual doctor ID
        },
        options: Options(
          headers: {'Authorization': 'Bearer YOUR_BEARER_TOKEN'},
        ),
      );

      if (response.statusCode == 201) {
        print('Appointment successfully created');
        // Refresh appointments list
        await _fetchDoctorAppointments();
      } else {
        print(
            'Failed to create appointment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _appointments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = _appointments[index];
                return AppointmentCard(
                  appointment: appointment,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show form to add appointment
          _showAddAppointmentDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int? patientId;
        String refollowDate = '';

        return AlertDialog(
          title: Text('Add Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Patient ID'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    patientId = int.tryParse(value);
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Refollow Date'),
                  onChanged: (value) {
                    refollowDate = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (patientId != null && refollowDate.isNotEmpty) {
                  _addAppointment(patientId!, refollowDate);
                  Navigator.pop(context);
                } else {
                  // Show error message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Please enter patient ID and refollow date'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Appointment {
  final int patientId;
  final String patientName;
  final String refollowDate;

  Appointment({
    required this.patientId,
    required this.patientName,
    required this.refollowDate,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      refollowDate: json['refollow_date'],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient: ${appointment.patientName}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Refollow Date: ${appointment.refollowDate}'),
          ],
        ),
      ),
    );
  }
}*/




/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  late List<Appointment> _appointments = [];
  late String _doctorName = '';

  @override
  void initState() {
    super.initState();
    _fetchDoctorAppointments();
  }

  Future<void> _fetchDoctorAppointments() async {
    try {
      Dio dio = Dio();
      String apiUrl =
          'http://127.0.0.1:8000/api/appointments/doctor_appointments/1';
      Response response = await dio.get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer YOUR_BEARER_TOKEN'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data['data'];
        setState(() {
          _doctorName = responseData['doctor_name'];
          _appointments = (responseData['refollow_dates'] as List)
              .map((appointmentJson) => Appointment.fromJson(appointmentJson))
              .toList();
        });
      } else {
        print(
            'Failed to fetch doctor appointments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor appointments: $e');
    }
  }

  Future<void> _addAppointment(int patientId, String refollowDate) async {
    try {
      Dio dio = Dio();
      String apiUrl = 'http://127.0.0.1:8000/api/appointments/store';
      Response response = await dio.post(
        apiUrl,
        data: {
          'patient_id': patientId,
          'refollow_date': refollowDate,
          'doc_id': 1, // Replace with the actual doctor ID
        },
        options: Options(
          headers: {'Authorization': 'Bearer YOUR_BEARER_TOKEN'},
        ),
      );

      if (response.statusCode == 200) {
        print('Appointment successfully created');
        // Refresh appointments list
        _fetchDoctorAppointments();
      } else {
        print(
            'Failed to create appointment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _appointments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = _appointments[index];
                return ListTile(
                  title: Text(appointment.patientName),
                  subtitle: Text('Date: ${appointment.refollowDate}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show form to add appointment
          _showAddAppointmentDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int? patientId;
        String refollowDate = '';

        return AlertDialog(
          title: Text('Add Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Patient ID'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    patientId = int.tryParse(value);
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Refollow Date'),
                  onChanged: (value) {
                    refollowDate = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (patientId != null && refollowDate.isNotEmpty) {
                  _addAppointment(patientId!, refollowDate);
                  Navigator.pop(context);
                } else {
                  // Show error message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Please enter patient ID and refollow date'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Appointment {
  final int patientId;
  final String patientName;
  final String refollowDate;

  Appointment({
    required this.patientId,
    required this.patientName,
    required this.refollowDate,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      refollowDate: json['refollow_date'],
    );
  }
}*/



/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  late List<Appointment> _appointments = [];
  late String _doctorName = '';

  @override
  void initState() {
    super.initState();
    _fetchDoctorAppointments();
  }

  Future<void> _fetchDoctorAppointments() async {
    try {
      Dio dio = Dio();
      String apiUrl =
          'http://127.0.0.1:8000/api/appointments/doctor_appointments/1';
      Response response = await dio.get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer YOUR_BEARER_TOKEN'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data['data'];
        setState(() {
          _doctorName = responseData['doctor_name'];
          _appointments = (responseData['refollow_dates'] as List)
              .map((appointmentJson) => Appointment.fromJson(appointmentJson))
              .toList();
        });
      } else {
        print(
            'Failed to fetch doctor appointments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: _appointments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = _appointments[index];
                return ListTile(
                  title: Text(appointment.patientName),
                  subtitle: Text('Date: ${appointment.refollowDate}'),
                );
              },
            ),
    );
  }
}

class Appointment {
  final int patientId;
  final String patientName;
  final String refollowDate;

  Appointment({
    required this.patientId,
    required this.patientName,
    required this.refollowDate,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      refollowDate: json['refollow_date'],
    );
  }
}*/
