import 'dart:convert'; // นำเข้าไลบรารีสำหรับการเข้ารหัสและถอดรหัส JSON

import 'package:flutter/material.dart'; // นำเข้าไลบรารี Flutter สำหรับการสร้าง UI

import 'package:flutter/services.dart'; // นำเข้าไลบรารีสำหรับเข้าถึงบริการของระบบ (ในโค้ดนี้ไม่ได้ใช้)

import 'package:path_provider/path_provider.dart'; // นำเข้าไลบรารีสำหรับเข้าถึง path ของ directory ในอุปกรณ์

import 'dart:io'; // นำเข้าไลบรารีสำหรับการทำงานกับไฟล์และระบบไฟล์

class ConfirmationScreen extends StatelessWidget { // กำหนดคลาส ConfirmationScreen ซึ่งเป็น StatelessWidget
  final Map<String, dynamic> sensor; // ตัวแปรสำหรับข้อมูลเซนเซอร์ในรูปแบบ Map
  final String newValue; // ตัวแปรสำหรับค่าที่ผู้ใช้กรอกใหม่
  final Function(String) onSave;  // Callback สำหรับอัปเดตค่าใน dashboard

  ConfirmationScreen({ // คอนสตรัคเตอร์ที่กำหนดให้ sensor, newValue, และ onSave เป็นค่าที่จำเป็น
    required this.sensor,
    required this.newValue,
    required this.onSave,
  });

  Future<void> _saveChanges(BuildContext context) async { // ฟังก์ชันที่ทำงานเมื่อผู้ใช้กด "Save"
    sensor['value'] = newValue; // อัปเดตค่าใน sensor ด้วย newValue

    final directory = await getApplicationDocumentsDirectory(); // เข้าถึง directory สำหรับเก็บข้อมูลของแอป
    final path = directory.path; // เก็บ path ของ directory
    final file = File('$path/sensor_data.json'); // สร้าง path สำหรับไฟล์ sensor_data.json
    String jsonString = await file.readAsString(); // อ่านข้อมูล JSON จากไฟล์
    Map<String, dynamic> jsonMap = json.decode(jsonString); // แปลง JSON string เป็น Map

    int sensorIndex = jsonMap['sensors'].indexWhere((s) => s['id'] == sensor['id']); // ค้นหาตำแหน่งของเซนเซอร์ใน List
    if (sensorIndex != -1) { // หากเซนเซอร์ถูกพบ
      jsonMap['sensors'][sensorIndex]['value'] = newValue; // อัปเดตค่า value ของเซนเซอร์นั้น
    }

    jsonString = json.encode(jsonMap); // แปลง Map กลับเป็น JSON string
    await file.writeAsString(jsonString); // บันทึก JSON string ลงไฟล์

    onSave(newValue);  // เรียกใช้ callback เพื่ออัปเดตค่าบน dashboard
    Navigator.of(context).pop(); // ปิดหน้าจอยืนยัน
    Navigator.of(context).pop(sensor); // กลับไปยังหน้าจอก่อนหน้าและส่งเซนเซอร์ที่อัปเดต
  }

  @override
  Widget build(BuildContext context) { // สร้าง UI ของหน้าจอ
    return Scaffold( // สร้าง Scaffold เป็นโครงสร้างหลักของหน้าจอ
      appBar: AppBar( // สร้าง AppBar
        title: Text('Confirm Changes'), // ชื่อเรื่องของ AppBar
        backgroundColor: Colors.black, // สีพื้นหลังของ AppBar
      ),
      body: Padding( // ใช้ Padding เพื่อเพิ่มระยะห่างจากขอบ
        padding: const EdgeInsets.all(20.0),
        child: Column( // ใช้ Column เพื่อจัดเรียง widget แนวตั้ง
          crossAxisAlignment: CrossAxisAlignment.start, // จัดเรียง widget ให้เริ่มต้นจากซ้าย
          children: [
            Text('Do you want to save the following changes?', style: TextStyle(fontSize: 18)), // ข้อความยืนยันการบันทึก
            SizedBox(height: 20), // เพิ่มระยะห่าง
            Text('New Sensor Value: $newValue', style: TextStyle(fontSize: 16)), // แสดงค่าของเซนเซอร์ใหม่
            SizedBox(height: 20), // เพิ่มระยะห่าง
            Row( // ใช้ Row เพื่อจัดเรียงปุ่ม
              children: [
                ElevatedButton( // ปุ่ม "Cancel"
                  onPressed: () => Navigator.of(context).pop(), // ยกเลิกและกลับไป
                  child: Text('Cancel'),
                ),
                SizedBox(width: 10), // เพิ่มระยะห่างระหว่างปุ่ม
                ElevatedButton( // ปุ่ม "Save"
                  onPressed: () => _saveChanges(context), // บันทึกการเปลี่ยนแปลง
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
