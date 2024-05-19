/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_patient.dart';
import '../view_model/patient_model.dart';

class NewPatientList extends StatefulWidget {
  @override
  _NewPatientListState createState() => _NewPatientListState();
}

class _NewPatientListState extends State<NewPatientList> {
  List<Patient> _patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return ListTile(
            title: Text(
              patient.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Age:', patient.age.toString(), index),
                _buildInfoRow('Gender:', patient.gender, index),
                _buildInfoRow('Email:', patient.email, index),
                _buildInfoRow('Phone:', patient.phone, index),
                _buildInfoRow('Password:', patient.password, index),
              ],
            ),
            onTap: () {
              _editPatient(index);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _confirmDelete(patient),
            ),
          );
        },
      ),
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
            _savePatients();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _editPatient(int index) {
    final nameController = TextEditingController(text: _patients[index].name);
    final ageController =
        TextEditingController(text: _patients[index].age.toString());
    final genderController =
        TextEditingController(text: _patients[index].gender);
    final emailController = TextEditingController(text: _patients[index].email);
    final phoneController = TextEditingController(text: _patients[index].phone);
    final passwordController =
        TextEditingController(text: _patients[index].password);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Patient'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Name', nameController),
                _buildTextField('Age', ageController),
                _buildTextField('Gender', genderController),
                _buildTextField('Email', emailController),
                _buildTextField('Phone', phoneController),
                _buildTextField('Password', passwordController),
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
            TextButton(
              onPressed: () {
                _saveChanges(
                  index,
                  nameController.text,
                  int.parse(ageController.text),
                  genderController.text,
                  emailController.text,
                  phoneController.text,
                  passwordController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges(
    int index,
    String name,
    int age,
    String gender,
    String email,
    String phone,
    String password,
  ) {
    setState(() {
      _patients[index].name = name;
      _patients[index].age = age;
      _patients[index].gender = gender;
      _patients[index].email = email;
      _patients[index].phone = phone;
      _patients[index].password = password;
    });
    _savePatients();
  }

  Future<void> _loadPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? patientsJson = prefs.getStringList('patients');

    if (patientsJson != null) {
      setState(() {
        _patients = patientsJson
            .map((json) => Patient.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  Future<void> _savePatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> patientsJson =
        _patients.map((patient) => jsonEncode(patient.toJson())).toList();
    prefs.setStringList('patients', patientsJson);
  }

  Future<void> _confirmDelete(Patient patient) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete the patient named "${patient.name}"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _patients.remove(patient);
                _savePatients();
                setState(() {}); // Update UI
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}*/


/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proj_app/features/doctor/presentation/views/edit%20patient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_patient.dart';
import '../view_model/patient_model.dart';

class NewPatientList extends StatefulWidget {
  @override
  _NewPatientListState createState() => _NewPatientListState();
}

class _NewPatientListState extends State<NewPatientList> {
  List<Patient> _patients = [];
  

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return ListTile(
            title: Text(
              patient.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Age:', patient.age.toString()),
                _buildInfoRow('Gender:', patient.gender),
                _buildInfoRow('Email:', patient.email),
                _buildInfoRow('Phone:', patient.phone),
                _buildInfoRow(
                    'Password:', patient.password), // Display the password
              ],
            ),
            onTap: () {
              //_editPatient(patient);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _confirmDelete(patient),
            ),
          );
        },
      ),
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
            _savePatients();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _loadPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? patientsJson = prefs.getStringList('patients');

    if (patientsJson != null) {
      setState(() {
        _patients = patientsJson
            .map((json) => Patient.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  Future<void> _savePatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> patientsJson =
        _patients.map((patient) => jsonEncode(patient.toJson())).toList();
    prefs.setStringList('patients', patientsJson);
  }

  Future<void> _confirmDelete(Patient patient) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete the patient named "${patient.name}"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _patients.remove(patient);
                _savePatients();
                setState(() {}); // Update UI
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}*/
