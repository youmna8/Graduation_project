import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/views/add_patients.dart';
import '../view_model/patient_model.dart';
import '../view_model/patient_rep.dart';
import 'package:dio/dio.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late Future<List<Patient>> _futurePatients;
  final Dio _dio = Dio();
  final String _baseUrl = 'http://127.0.0.1:8000';
  final String _token = 'YOUR_BEARER_TOKEN'; // Replace with your actual token

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() {
      _futurePatients = PatientApi().getAllPatients(_token);
    });
  }

  Future<void> _deletePatient(int patientId) async {
    try {
      final response = await Dio().delete(
        '$_baseUrl/api/patients/destroy/$patientId',
        options: Options(headers: {
          'Authorization': 'Bearer $_token',
        }),
        queryParameters: {
          '_method': 'DELETE',
        },
      );
      if (response.statusCode == 200) {
        // Patient deleted successfully, show success message or perform additional actions if needed
        print('Patient deleted successfully');
        _fetchPatients(); // Refresh the patient list
      } else {
        // Show an error message or handle the error case
        print('Failed to delete patient');
      }
    } catch (error) {
      // Show an error message or handle the error case
      print('Error: $error');
    }
  }

  Future<void> _confirmDelete(int patientId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _deletePatient(patientId); // Delete the patient
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editDoctor(int id) async {
    // Fetch the doctor's details
    final response = await _dio.get(
      '$_baseUrl/api/patients/$id/edit',
      options: Options(headers: {'Authorization': 'Bearer your_token_here'}),
    );

    if (response.statusCode == 200) {
      // Extract doctor data from response
      final Map<String, dynamic> data = response.data['data']['patient'];

      // Open a dialog to edit doctor details
      // ignore: use_build_context_synchronously
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
                        initialValue: data['fullName'],
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) {
                          // Update name in data map
                          data['fullName'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: data['email'],
                        decoration: const InputDecoration(labelText: 'email'),
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
                        decoration: const InputDecoration(labelText: 'address'),
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
                        decoration: const InputDecoration(labelText: 'Phone'),
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
                                '$_baseUrl/api/patients/update?_method=PUT',
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
                                  _futurePatients =
                                      PatientApi().getAllPatients(_token);
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
                    child: isSaving
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Save'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return AddPatientScreen();
          }));
        },
        child: const Icon(
          Icons.add,
          color: Color(0xff39D2C0),
        ),
      ),
      backgroundColor: const Color(0xff39D2C0),
      body: RefreshIndicator(
        onRefresh: _fetchPatients,
        child: FutureBuilder<List<Patient>>(
          future: _futurePatients,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  color: Colors.redAccent,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchPatients,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final patients = snapshot.data!;
              return ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  patient.fullName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Phone: ${patient.phone}'),
                                Text('Address: ${patient.address}'),
                                Text('Age: ${patient.age}'),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                _confirmDelete(patient
                                    .id); // Show confirmation dialog before deleting
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xff39D2C0))),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _editDoctor(patient.id);
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xff39D2C0))),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/views/add_patients.dart';
import '../view_model/patient_model.dart';
import '../view_model/patient_rep.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late Future<List<Patient>> _futurePatients;
  final String _token = 'YOUR_BEARER_TOKEN'; // Replace with your actual token

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() {
      _futurePatients = PatientApi().getAllPatients(_token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return AddPatientScreen();
          }));
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Color(0xff39D2C0),
      body: RefreshIndicator(
        onRefresh: _fetchPatients,
        child: FutureBuilder<List<Patient>>(
          future: _futurePatients,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  color: Colors.redAccent,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchPatients,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final patients = snapshot.data!;
              return ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return Padding(
                    padding: EdgeInsets.all(3),
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            patient.fullName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Phone: ${patient.phone}'),
                          Text('Address: ${patient.address}'),
                          Text('Age: ${patient.age}')
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import '../view_model/patient_model.dart';
import '../view_model/patient_rep.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late Future<List<Patient>> _futurePatients;
  final String _token = 'YOUR_BEARER_TOKEN'; // Replace with your actual token

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() {
      _futurePatients = PatientApi().getAllPatients(_token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPatients,
        child: FutureBuilder<List<Patient>>(
          future: _futurePatients,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  color: Colors.redAccent,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchPatients,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final patients = snapshot.data!;
              return ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return ListTile(
                    title: Text(patient.fullName),
                    subtitle: Text(patient.phone),
                    trailing: Text('Age: ${patient.age}'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}*/



/*import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/view_model/patient_model.dart';
import '../view_model/patient_rep.dart';


class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late Future<List<Patient>> _futurePatients;
  final String _token = 'YOUR_BEARER_TOKEN'; // Replace with your actual token

  @override
  void initState() {
    super.initState();
    _futurePatients = PatientApi().getAllPatients(_token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: _futurePatients,
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
            final patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  title: Text(patient.fullName),
                  subtitle: Text(patient.phone),
                  trailing: Text('Age: ${patient.age}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}*/

