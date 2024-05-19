/*import 'package:flutter/material.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';
import 'package:dio/dio.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late Future<List<Doctor>> _futureDoctors;
  final Dio _dio = Dio();
  final String _baseUrl =
      'http://127.0.0.1:8000'; //https://1b30-197-33-172-55.ngrok-free.app

  @override
  void initState() {
    super.initState();
    _futureDoctors = DoctorRepository.fetchDoctors();
  }

  Future<void> _deleteDoctor(int id) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/api/doctors/destroy/$id',
        queryParameters: {'_method': 'DELETE'},
        options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
      );
      if (response.statusCode == 200) {
        // Doctor deleted successfully, refresh the list
        setState(() {
          _futureDoctors = DoctorRepository.fetchDoctors();
        });
      } else {
        throw Exception('Failed to delete doctor');
      }
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
  }

  Future<void> _editDoctor(int id) async {
    // Fetch the doctor's details
    final response = await _dio.get(
      '$_baseUrl/api/doctors/$id/edit',
      options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
    );

    if (response.statusCode == 200) {
      // Extract doctor data from response
      final Map<String, dynamic> data = response.data['data']['doctor'];

      // Open a dialog to edit doctor details
      await showDialog(
        context: context,
        builder: (context) {
          bool isSaving = false; // Track if saving is in progress
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Edit Doctor'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: data['name'],
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) {
                          // Update name in data map
                          data['name'] = value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['email'],
                        decoration: InputDecoration(labelText: 'email'),
                        onChanged: (value) {
                          // Update name in data map
                          data['email'] = value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['address'],
                        decoration: InputDecoration(labelText: 'address'),
                        onChanged: (value) {
                          // Update name in data map
                          data['address'] = value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['phone'],
                        decoration: InputDecoration(labelText: 'Phone'),
                        onChanged: (value) {
                          // Update phone in data map
                          data['phone'] = value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      // Add other fields as needed (address, years_of_experience, email, password)
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            // Prevent multiple save requests
                            setState(() {
                              isSaving = true;
                            });
                            try {
                              final updateResponse = await _dio.post(
                                '$_baseUrl/api/doctors/update?_method=PUT',
                                data: data,
                                options: Options(
                                  headers: {
                                    'Authorization': 'Bearer your_token_here'
                                  },
                                ),
                              );
                              if (updateResponse.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Doctor updated successfully'),
                                  ),
                                );
                                // Refresh the doctor list after updating
                                setState(() {
                                  _futureDoctors =
                                      DoctorRepository.fetchDoctors();
                                });
                                Navigator.of(context).pop(); // Close the dialog
                              } else {
                                throw Exception('Doctor updated successfully');
                              }
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(' $e'),
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                    child:
                        isSaving ? CircularProgressIndicator() : Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      throw Exception('Failed to fetch doctor details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: FutureBuilder<List<Doctor>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            final doctors = snapshot.data!;
            return Center(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return Dismissible(
                    key: Key(doctor.id.toString()),
                    onDismissed: (_) => _deleteDoctor(doctor.id as int),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => _editDoctor(doctor.id),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 400,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${doctor.name}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Email: ${doctor.email}'),
                                  Text('Phone: ${doctor.phone}'),
                                  Text('address: ${doctor.address}'),
                                  Text(
                                      'Years of Experience: ${doctor.yearsOfExperience}'),
                                  //Text('password: ${doctor.password}'),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 380,
                            top: 30,
                            child: Image.asset(
                              'assets/images/Stetoscope.png',
                              width: 100,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';

import 'admin_manage_doctor.dart';

/*class Doctor {
  final int id;
  final String name;
  final String phone;
  final String address;
  final int yearsOfExperience;
  final String? token;
  final String email;
  final String password;
  final String createdAt;
  final String updatedAt;

  Doctor({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.yearsOfExperience,
    required this.token,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      yearsOfExperience: json['years_of_experience'],
      token: json['token'],
      email: json['email'],
      password: json['password'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}*/

/*class DoctorService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://127.0.0.1:8000';

  Future<List<Doctor>> fetchDoctors() async {
    try {
      final response = await _dio.get('$_baseUrl/api/doctors/all');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['doctors'];
        return data.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch doctors');
      }
    } catch (e) {
      throw Exception('Failed to fetch doctors: $e');
    }
  }

  
}*/

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  late Future<List<Doctor>> _futureDoctors;
  final DoctorService _doctorService = DoctorService();
  final Dio _dio = Dio();
  final String _baseUrl = 'http://127.0.0.1:8000';

  Future<void> _deleteDoctor(int id) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/api/doctors/destroy/$id',
        queryParameters: {'_method': 'DELETE'},
        options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
      );
      if (response.statusCode == 200) {
        // Doctor deleted successfully, refresh the list
        setState(() {
          _futureDoctors = _doctorService.fetchDoctors();
        });
      } else {
        throw Exception('Failed to delete doctor');
      }
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
  }

  Future<void> _editDoctor(int id) async {
    // Fetch the doctor's details
    final response = await _dio.get(
      '$_baseUrl/api/doctors/$id/edit',
      options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
    );

    if (response.statusCode == 200) {
      // Extract doctor data from response
      final Map<String, dynamic> data = response.data['data']['doctor'];

      // Open a dialog to edit doctor details
      await showDialog(
        context: context,
        builder: (context) {
          bool isSaving = false; // Track if saving is in progress
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Edit Doctor'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: data['name'],
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) {
                          // Update name in data map
                          data['name'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['email'],
                        decoration: InputDecoration(labelText: 'email'),
                        onChanged: (value) {
                          // Update name in data map
                          data['email'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['address'],
                        decoration: InputDecoration(labelText: 'address'),
                        onChanged: (value) {
                          // Update name in data map
                          data['address'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['phone'],
                        decoration: InputDecoration(labelText: 'Phone'),
                        onChanged: (value) {
                          // Update phone in data map
                          data['phone'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // Add other fields as needed (address, years_of_experience, email, password)
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            // Prevent multiple save requests
                            setState(() {
                              isSaving = true;
                            });
                            try {
                              final updateResponse = await _dio.post(
                                '$_baseUrl/api/doctors/update?_method=PUT',
                                data: data,
                                options: Options(
                                  headers: {
                                    'Authorization': 'Bearer your_token_here'
                                  },
                                ),
                              );
                              if (updateResponse.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Doctor updated successfully'),
                                  ),
                                );
                                // Refresh the doctor list after updating
                                setState(() {
                                  _futureDoctors =
                                      _doctorService.fetchDoctors();
                                });
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return AdminScreen();
                                })); // Close the dialog
                              } else {
                                throw Exception('Doctor updated successfully');
                              }
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(' $e'),
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                    child:
                        isSaving ? const CircularProgressIndicator() : Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      throw Exception('Failed to fetch doctor details');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureDoctors = _doctorService.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff39D2C0),
        body: FutureBuilder<List<Doctor>>(
            future: _futureDoctors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {



                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final doctors = snapshot.data!;
                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Dismissible(
                      key: Key(doctor.id.toString()),
                      onDismissed: (_) => _deleteDoctor(doctor.id as int),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => _editDoctor(doctor.id),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                width: 400,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${doctor.name}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Email: ${doctor.email}'),
                                    Text('Phone: ${doctor.phone}'),
                                    Text('address: ${doctor.address}'),
                                    Text(
                                        'Years of Experience: ${doctor.yearsOfExperience}'),
                                    //Text('password: ${doctor.password}'),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 380,
                              top: 30,
                              child: Image.asset(
                                'assets/images/Stetoscope.png',
                                width: 100,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }));
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor List Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DoctorListScreen(),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';
import 'package:dio/dio.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late Future<List<Doctor>> _futureDoctors;
  final Dio _dio = Dio();
  final String _baseUrl =
      'http://127.0.0.1:8000'; //https://1b30-197-33-172-55.ngrok-free.app

  @override
  void initState() {
    super.initState();
    _futureDoctors = DoctorRepository.fetchDoctors();
  }

  Future<void> _deleteDoctor(int id) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/api/doctors/destroy/$id',
        queryParameters: {'_method': 'DELETE'},
        options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
      );
      if (response.statusCode == 200) {
        // Doctor deleted successfully, refresh the list
        setState(() {
          _futureDoctors = DoctorRepository.fetchDoctors();
        });
      } else {
        throw Exception('Failed to delete doctor');
      }
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
  }

  Future<void> _editDoctor(int id) async {
    // Fetch the doctor's details
    final response = await _dio.get(
      '$_baseUrl/api/doctors/$id/edit',
      options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
    );

    if (response.statusCode == 200) {
      // Extract doctor data from response
      final Map<String, dynamic> data = response.data['data']['doctor'];

      // Open a dialog to edit doctor details
      await showDialog(
        context: context,
        builder: (context) {
          bool isSaving = false; // Track if saving is in progress
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Edit Doctor'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: data['name'],
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) {
                          // Update name in data map
                          data['name'] = value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['email'],
                        decoration: InputDecoration(labelText: 'email'),
                        onChanged: (value) {
                          // Update name in data map
                          data['email'] = value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['address'],
                        decoration: InputDecoration(labelText: 'address'),
                        onChanged: (value) {
                          // Update name in data map
                          data['address'] = value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['phone'],
                        decoration: InputDecoration(labelText: 'Phone'),
                        onChanged: (value) {
                          // Update phone in data map
                          data['phone'] = value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      // Add other fields as needed (address, years_of_experience, email, password)
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            // Prevent multiple save requests
                            setState(() {
                              isSaving = true;
                            });
                            try {
                              final updateResponse = await _dio.post(
                                '$_baseUrl/api/doctors/update?_method=PUT',
                                data: data,
                                options: Options(
                                  headers: {
                                    'Authorization': 'Bearer your_token_here'
                                  },
                                ),
                              );
                              if (updateResponse.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Doctor updated successfully'),
                                  ),
                                );
                                // Refresh the doctor list after updating
                                setState(() {
                                  _futureDoctors =
                                      DoctorRepository.fetchDoctors();
                                });
                                Navigator.of(context).pop(); // Close the dialog
                              } else {
                                throw Exception('Doctor updated successfully');
                              }
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(' $e'),
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                    child:
                        isSaving ? CircularProgressIndicator() : Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      throw Exception('Failed to fetch doctor details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: FutureBuilder<List<Doctor>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final doctors = snapshot.data!;
            return Center(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return Dismissible(
                    key: Key(doctor.id.toString()),
                    onDismissed: (_) => _deleteDoctor(doctor.id as int),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => _editDoctor(doctor.id),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 400,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${doctor.name}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Email: ${doctor.email}'),
                                  Text('Phone: ${doctor.phone}'),
                                  Text('address: ${doctor.address}'),
                                  Text(
                                      'Years of Experience: ${doctor.yearsOfExperience}'),
                                  //Text('password: ${doctor.password}'),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 380,
                            top: 30,
                            child: Image.asset(
                              'assets/images/Stetoscope.png',
                              width: 100,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late Future<List<Doctor>> _futureDoctors;

  @override
  void initState() {
    super.initState();
    _futureDoctors = DoctorRepository.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: FutureBuilder<List<Doctor>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${doctor.name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      //  Text('Email: ${doctor.email}'),
                      //  Text('Phone: ${doctor.phone}'),
                      //  Text('Years of Experience: ${doctor.yearsOfExperience}'),
                      //Text('Password: ${doctor.password}'),

                      // Display other doctor information as needed
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late Future<List<Doctor>> _futureDoctors;

  @override
  void initState() {
    super.initState();
    _futureDoctors = DoctorRepository.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: FutureBuilder<List<Doctor>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return ListTile(
                  title: Text('Name: ${doctor.name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${doctor.email}'),
                      Text('Phone: ${doctor.phone}'),
                      Text('Years of Experience: ${doctor.yearsOfExperience}'),
                      // Display other doctor information as needed
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late Future<List<Doctor>> _futureDoctors;

  @override
  void initState() {
    super.initState();
    _futureDoctors = DoctorRepository.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor List'),
      ),
      body: FutureBuilder<List<Doctor>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return ListTile(
                  title: Text(doctor.name),
                  subtitle: Text(doctor.email),
                  // Display other doctor information as needed
                );
              },
            );
          }
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:proj_app/features/admin/data/doc_list_model.dart';
import 'package:proj_app/features/admin/data/rep.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  bool isEditing = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff39D2C0),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Doctor List',
            style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontFamily: 'Spirax-Regular'),
          ),
        ),
        body: ListView.builder(
          itemCount: DoctorRepository.getDoctors().length,
          itemBuilder: (context, index) {
            Doctor doctor = DoctorRepository.getDoctors()[index];
            nameController.text = doctor.name;
            emailController.text = doctor.email;
            passwordController.text = doctor.password;
            phoneController.text = doctor.phone;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Container(
                      foregroundDecoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      height: 230,
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Doctor Name :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                isEditing
                                    ? Expanded(
                                        child: TextFormField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        doctor.name,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text(
                                  'Email :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                isEditing
                                    ? Expanded(
                                        child: TextFormField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        doctor.email,
                                        style: TextStyle(fontSize: 18),
                                      ),
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  'Password :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                isEditing
                                    ? Expanded(
                                        child: TextFormField(
                                          controller: passwordController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        doctor.password,
                                        style: TextStyle(fontSize: 18),
                                      ),
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  'Phone :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                isEditing
                                    ? Expanded(
                                        child: TextFormField(
                                          controller: phoneController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        doctor.phone,
                                        style: TextStyle(fontSize: 18),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 260,
                    child: Image.asset(
                      'assets/images/Stetoscope.png',
                      height: 100,
                    ),
                  ),
                  Positioned(
                    left: 230,
                    top: 160,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(isEditing ? Icons.save : Icons.edit),
                          onPressed: () {
                            setState(() {
                              if (isEditing) {
                                doctor.name = nameController.text;
                                doctor.email = emailController.text;
                                doctor.password = passwordController.text;
                                doctor.phone = phoneController.text;
                              }
                              isEditing = !isEditing;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, doctor);
                          },
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
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${doctor.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                DoctorRepository.getDoctors().remove(doctor);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}*/














































































/*import 'package:flutter/material.dart';
import 'package:proj_app/features/tasks/presentation/screens/model.dart';
import 'package:proj_app/features/tasks/presentation/screens/rep.dart';
import 'List_ViewDoctor.dart';

class DoctorList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 100, 205, 179),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Doctor List',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView.builder(
          itemCount: DoctorRepository.getDoctors().length,
          itemBuilder: (context, index) {
            Doctor doctor = DoctorRepository.getDoctors()[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Container(
                      foregroundDecoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      height: 200,
                      width: 340,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Doctor Name :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  doctor.name,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Email :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  doctor.email,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Password :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  doctor.password,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Phone :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  doctor.phone,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 310,
                    child: Image.asset(
                      'assets/images/Stetoscope.png',
                      height: 100,
                    ),
                  ),
                  Positioned(
                    left: 270,
                    top: 150,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Handle edit action here
                            _editDoctor(context, doctor);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, doctor);
                          },
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
    );
  }

  void _editDoctor(BuildContext context, Doctor doctor) {
    // Navigate to edit doctor screen or show dialog for editing
    // You can implement the editing logic here according to your requirements
  }

  void _showDeleteConfirmationDialog(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${doctor.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                DoctorRepository.getDoctors().remove(doctor);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}*/





/*import 'package:flutter/material.dart';
import 'package:proj_app/features/tasks/presentation/screens/model.dart';
import 'package:proj_app/features/tasks/presentation/screens/rep.dart';

import 'List_ViewDoctor.dart';
// ... (previous code)

class DoctorList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 100, 205, 179),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Doctor List',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: DoctorRepository.getDoctors().length,
                    itemBuilder: (context, index) {
                      Doctor doctor = DoctorRepository.getDoctors()[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Center(
                              child: Container(
                                foregroundDecoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 7), // changes position of shadow
                                    ),
                                  ],
                                ),
                                height: 200,
                                width: 340,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Doctor Name :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                doctor.name,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Email :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(doctor.email,
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Password :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(doctor.password.toString(),
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Phone :',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(doctor.phone,
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 310,
                              child: Image.asset(
                                'assets/images/Stetoscope.png',
                                height: 100,
                              ),
                            ),
                            Positioned(
                              left: 270,
                              top: 150,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                     
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, doctor);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${doctor.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                DoctorRepository.getDoctors().remove(doctor);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}*/





  /*ListTile(
                title: Text(doctor.name),
                subtitle: Text(doctor.specialization),
                
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, doctor);
                  },
                ),
              );*/
