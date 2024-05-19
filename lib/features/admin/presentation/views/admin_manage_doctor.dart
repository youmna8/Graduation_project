import 'package:flutter/material.dart';
import 'package:proj_app/features/admin/presentation/views/admin_fill_doc_form.dart';
import 'package:proj_app/features/admin/presentation/views/doc_lis.dart';
import 'package:proj_app/features/admin/presentation/views/sign_up.dart';



class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 140,
                  child: Image.asset(
                    'assets/images/Ellipse 25.png',
                    color: Color.fromARGB(255, 74, 239, 198),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 30,
                  child: Image.asset('assets/images/Ellipse 24.png',
                      color: Color.fromARGB(255, 74, 239, 198)),
                ),
                Image.asset('assets/images/Frame.png'),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 130,
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xff39D2C0))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDoctorScreen()),
                );
              },
              child: Text(
                'Add Doctor',
                style: TextStyle(
                    fontFamily: 'Spirax-Regular',
                    color: Colors.black,
                    fontSize: 25),
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xff39D2C0))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorListScreen()),
                );
              },
              child: Text('Doctor List',
                  style: TextStyle(
                      fontFamily: 'Spirax-Regular',
                      color: Colors.black,
                      fontSize: 25)),
            ),
          ),
        ],
      ),
    );
  }
}
