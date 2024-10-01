import 'package:flutter/material.dart'; // นำเข้าไลบรารี Flutter สำหรับการสร้าง UI
import 'package:http/http.dart' as http; // นำเข้าไลบรารี HTTP สำหรับการทำคำขอ HTTP
import 'dart:convert'; // ใช้สำหรับ encode/decode JSON
import 'confirmation_screen.dart'; // นำเข้า ConfirmationScreen สำหรับนำทางไปยังหน้าจอยืนยัน

class EditSensorScreen extends StatefulWidget { // กำหนดคลาส EditSensorScreen ซึ่งเป็น StatefulWidget
  final Map<String, dynamic> sensor; // ตัวแปรสำหรับข้อมูลเซนเซอร์ในรูปแบบ Map
  final Function(String) onSave;  // Callback สำหรับอัปเดตค่าใน dashboard

  EditSensorScreen({required this.sensor, required this.onSave}); // คอนสตรัคเตอร์ที่กำหนดให้ sensor และ onSave เป็นค่าที่จำเป็น

  @override
  _EditSensorScreenState createState() => _EditSensorScreenState(); // สร้าง State สำหรับ EditSensorScreen
}

class _EditSensorScreenState extends State<EditSensorScreen> { // สร้าง State สำหรับ EditSensorScreen
  late TextEditingController _valueController; // ตัวควบคุมสำหรับ TextField

  @override
  void initState() { // ฟังก์ชันที่เรียกเมื่อ State ถูกสร้าง
    super.initState();
    _valueController = TextEditingController(text: widget.sensor['value']); // กำหนดค่าเริ่มต้นให้กับ TextEditingController
    print('EditSensorScreen initialized with value: ${widget.sensor['value']}'); // แสดงค่าที่กำหนด
  }

  @override
  void dispose() { // ฟังก์ชันที่เรียกเมื่อ State ถูกทำลาย
    _valueController.dispose(); // ปล่อยตัวควบคุม
    super.dispose();
  }

  // ฟังก์ชันสำหรับอัปเดตข้อมูลเซ็นเซอร์ผ่าน HTTP PUT request
  Future<void> updateSensor(String sensorId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put( // ทำคำขอ PUT ไปยังเซิร์ฟเวอร์
        Uri.parse('http://localhost:3000/sensors/$sensorId'),  // ใช้ localhost แทน IP Address
        headers: {'Content-Type': 'application/json'}, // กำหนด Content-Type
        body: jsonEncode(updatedData), // แปลงข้อมูลเป็น JSON
      );

      if (response.statusCode == 200) { // ตรวจสอบสถานะการตอบกลับ
        print('แก้ไขข้อมูลเซ็นเซอร์สำเร็จ'); // แสดงข้อความเมื่อสำเร็จ
      } else {
        throw Exception('ไม่สามารถแก้ไขข้อมูลเซ็นเซอร์ได้: ${response.statusCode}'); // แสดงข้อความเมื่อเกิดข้อผิดพลาด
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปเดตเซ็นเซอร์: $e'); // แสดงข้อความเมื่อเกิดข้อผิดพลาด
    }
  }

  // ฟังก์ชันสำหรับการนำไปหน้าจอการยืนยัน
  void _navigateToConfirmationScreen() async {
    print('Navigating to confirmation screen...'); // แสดงข้อความเมื่อนำทางไปยังหน้าจอยืนยัน
    if (_valueController.text.isNotEmpty) { // ตรวจสอบว่ามีค่าใน TextField หรือไม่
      try {
        await updateSensor(widget.sensor['id'], { // เรียกฟังก์ชัน updateSensor
          'value': _valueController.text, // ส่งค่าที่ผู้ใช้กรอก
        });

        // นำทางไปที่หน้าจอยืนยันหลังจากอัปเดตสำเร็จ
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen( // สร้างหน้าจอยืนยัน
              sensor: widget.sensor,
              newValue: _valueController.text,
              onSave: widget.onSave,
            ),
          ),
        );
      } catch (e) {
        print('เกิดข้อผิดพลาด: $e'); // แสดงข้อความเมื่อเกิดข้อผิดพลาด
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar( // แสดง SnackBar หากไม่มีค่า
        SnackBar(content: Text('กรุณากรอกค่าเซ็นเซอร์')),
      );
    }
  }

  @override
  Widget build(BuildContext context) { // สร้าง UI ของหน้าจอ
    print('Building EditSensorScreen'); // แสดงข้อความเมื่อสร้าง UI
    return Scaffold( // สร้าง Scaffold เป็นโครงสร้างหลักของหน้าจอ
      appBar: AppBar(
        title: Text('Edit Sensor Value'), // ชื่อเรื่องของ AppBar
        backgroundColor: Colors.black, // สีพื้นหลังของ AppBar
      ),
      body: Padding( // ใช้ Padding เพื่อเพิ่มระยะห่างจากขอบ
        padding: const EdgeInsets.all(20.0),
        child: Column( // ใช้ Column เพื่อจัดเรียง widget แนวตั้ง
          children: <Widget>[
            TextField( // สร้าง TextField สำหรับกรอกค่าเซนเซอร์
              controller: _valueController, // กำหนดตัวควบคุม
              decoration: InputDecoration(
                labelText: 'Sensor Value', // ข้อความ label
                labelStyle: TextStyle(color: Colors.white), // สีของ label
                enabledBorder: OutlineInputBorder( // รูปแบบขอบเมื่อใช้งานอยู่
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder( // รูปแบบขอบเมื่อโฟกัสอยู่
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: TextStyle(color: Colors.white), // สีของข้อความใน TextField
            ),
            SizedBox(height: 20), // เพิ่มระยะห่าง
            ElevatedButton( // ปุ่ม "Next"
              onPressed: _navigateToConfirmationScreen, // เรียกฟังก์ชันเมื่อกดปุ่ม
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
