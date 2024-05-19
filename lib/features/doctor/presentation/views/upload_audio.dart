import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class UploadAudioScreen extends StatefulWidget {
  @override
  _UploadAudioScreenState createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  Uint8List? _audioBytes;
  late TextEditingController _patientIdController;
  final Dio _dio = Dio();
  final String _apiUrl = 'http://127.0.0.1:8000/api/report/store_result';
  final String _token = 'YOUR_BEARER_TOKEN';

  @override
  void initState() {
    super.initState();
    _patientIdController = TextEditingController();
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _audioBytes = file.bytes;
      });
    }
  }

  Future<void> _uploadAudio() async {
    try {
      String patientId = _patientIdController.text;

      if (_audioBytes == null || patientId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an audio file and enter patient ID'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      FormData formData = FormData.fromMap({
        'audio_path':
            MultipartFile.fromBytes(_audioBytes!, filename: 'audio_file'),
        'patient_id': patientId,
      });

      Response response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        String result = response.data['data']['result'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Success'),
              content: Text('Result: $result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff39D2C0),
      body: Stack(children: [
        Positioned(
          top: -40,
          child: Image.asset(
            'assets/images/logo_make_11_06_2023_412.jpg',
            height: 350,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 300),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _selectAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.check)
                          : Text(
                              'Select Audio',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16)),
                    child: TextFormField(
                      controller: _patientIdController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                        labelText: 'Patient ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff39D2C0),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _audioBytes != null
                          ? Icon(Icons.cloud_upload)
                          : Text(
                              'Upload',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}




/*import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class UploadAudioScreen extends StatefulWidget {
  @override
  _UploadAudioScreenState createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  Uint8List? _audioBytes;
  late TextEditingController _patientIdController;
  final Dio _dio = Dio();
  final String _apiUrl = 'http://127.0.0.1:8000/api/report/store_result';
  final String _token = 'YOUR_BEARER_TOKEN'; // Replace with your actual token

  @override
  void initState() {
    super.initState();
    _patientIdController = TextEditingController();
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _audioBytes = file.bytes;
      });
    }
  }

  Future<void> _uploadAudio() async {
    try {
      String patientId = _patientIdController.text;

      if (_audioBytes == null || patientId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an audio file and enter patient ID'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      FormData formData = FormData.fromMap({
        'audio_path':
            MultipartFile.fromBytes(_audioBytes!, filename: 'audio_file'),
        'patient_id': patientId,
      });

      Response response = await _dio.post(
        _apiUrl,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      if (response.statusCode == 200) {
        String result = response.data['data']['result'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Success'),
              content: Text('Result: $result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Audio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _selectAudio,
              child: Text('Select Audio'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadAudio,
              child: Text('Upload'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _patientIdController,
              decoration: InputDecoration(labelText: 'Patient ID'),
            ),
          ],
        ),
      ),
    );
  }
}*/





/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

void main() => runApp(MaterialApp(home: FileUploadScreen()));

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  late File _audioFile = File('path');

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadAudio() async {
    if (_audioFile == null) {
      // Handle the case when _audioFile is null, maybe show a message to the user
      print('Error');
    }

    try {
      Dio dio = Dio();
      String uploadUrl = 'http://127.0.0.1:8000/api/report/upload_audio/1';

      FormData formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          _audioFile.path,
          filename: 'respiratory_sound.mp3',
        ),
      });

      Response response = await dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response.statusCode == 200) {
        print('Audio uploaded successfully');
        // Handle success
      } else {
        print('Failed to upload audio. Status code: ${response.statusCode}');
        // Handle failure
      }
    } catch (e) {
      print('Error uploading audio: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xff39D2C0),
            body: Center(
                child: Column(children: [
              Stack(children: [
                Container(
                  foregroundDecoration: BoxDecoration(
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'assets/images/smiling-male-doctor-writing-diagnosis-and-looking-2022-08-12-17-07-51-utc 2.png')),
                      borderRadius: BorderRadius.circular(20)),
                  height: 230,
                  width: 300,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                  ),
                )
              ]),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                height: 270,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _selectFile,
                      child: Text('Select Audio File'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (_audioFile != null) ? _uploadAudio : null,
                      child: Text('Upload Audio'),
                    )
                  ],
                ),
              ),
            ]))));
  }
}*/
