import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late List<Patient> _patients = [];
  final String _apiUrl = 'http://127.0.0.1:8000/api/report/upload_audio/1';
  final String _token = 'YOUR_BEARER_TOKEN'; // Replace with your actual token
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      Response response = await _dio.get(
        _apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _patients = (response.data['data']['patients'] as List)
              .map((patientJson) => Patient.fromJson(patientJson))
              .toList();
        });
      } else {
        throw Exception('Failed to fetch patients');
      }
    } catch (e) {
      print('Error fetching patients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
      ),
      body: _patients.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _patients.length,
              itemBuilder: (context, index) {
                Patient patient = _patients[index];
                return ListTile(
                  title: Text(patient.fullName),
                  subtitle: Text('ID: ${patient.id}'),
                );
              },
            ),
    );
  }
}

class Patient {
  final int id;
  final String fullName;
  final int docId;

  Patient({
    required this.id,
    required this.fullName,
    required this.docId,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
      docId: json['doc_id'],
    );
  }
}
