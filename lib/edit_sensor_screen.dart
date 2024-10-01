import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // ใช้สำหรับ encode/decode JSON
import 'confirmation_screen.dart';

class EditSensorScreen extends StatefulWidget {
  final Map<String, dynamic> sensor;
  final Function(String) onSave;  // Callback to update value in dashboard

  EditSensorScreen({required this.sensor, required this.onSave});

  @override
  _EditSensorScreenState createState() => _EditSensorScreenState();
}

class _EditSensorScreenState extends State<EditSensorScreen> {
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(text: widget.sensor['value']);
    print('EditSensorScreen initialized with value: ${widget.sensor['value']}');
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  // ฟังก์ชันสำหรับอัปเดตข้อมูลเซ็นเซอร์ผ่าน HTTP PUT request
  Future<void> updateSensor(String sensorId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/sensors/$sensorId'),  // ใช้ localhost แทน IP Address
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        print('แก้ไขข้อมูลเซ็นเซอร์สำเร็จ');
      } else {
        throw Exception('ไม่สามารถแก้ไขข้อมูลเซ็นเซอร์ได้: ${response.statusCode}');
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปเดตเซ็นเซอร์: $e');
    }
  }

  // ฟังก์ชันสำหรับการนำไปหน้าจอการยืนยัน
  void _navigateToConfirmationScreen() async {
    print('Navigating to confirmation screen...');
    if (_valueController.text.isNotEmpty) {
      try {
        await updateSensor(widget.sensor['id'], {
          'value': _valueController.text,
        });

        // นำทางไปที่หน้าจอยืนยันหลังจากอัปเดตสำเร็จ
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              sensor: widget.sensor,
              newValue: _valueController.text,
              onSave: widget.onSave,
            ),
          ),
        );
      } catch (e) {
        print('เกิดข้อผิดพลาด: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกค่าเซ็นเซอร์')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building EditSensorScreen');
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Sensor Value'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Sensor Value',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToConfirmationScreen,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
