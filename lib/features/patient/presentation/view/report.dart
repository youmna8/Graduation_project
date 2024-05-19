import 'package:flutter/material.dart';

class PatientReportScreen extends StatelessWidget {
  const PatientReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportItem('Doctor Name', 'Dr. John Doe'),
              Divider(), // Add divider here
              _buildReportItem('Patient Name', 'Alice Smith'),
              Divider(), // Add divider here
              _buildReportItem('Patient ID', '123456'),
              Divider(), // Add divider here
              SizedBox(height: 20),
              _buildReportItem('Disease Name', 'Some Disease'),
              Divider(), // Add divider here
              SizedBox(height: 20),
              Text(
                'أسماء الأدوية:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildMedicineItem('Medicine A'),
              Divider(), // Add divider here
              _buildMedicineItem('Medicine B'),
              Divider(), // Add divider here
              _buildMedicineItem('Medicine C'),
              Divider(), // Add divider here
              SizedBox(height: 20),
              _buildReportItem('ميعاد المتابعة', '15/03/2024'),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add onPressed action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff39D2C0),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Print Report',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: Text(
        '- $name',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
