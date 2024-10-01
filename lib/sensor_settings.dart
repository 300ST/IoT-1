import 'package:flutter/material.dart';

class SensorSettings extends StatelessWidget {
  final List<dynamic> sensors;

  SensorSettings({required this.sensors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Sensors'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // ฟังก์ชันเพิ่มเซนเซอร์ใหม่
              },
              child: Text('Add Sensor'),
            ),
            // แสดงรายการเซนเซอร์ทั้งหมดที่ให้ผู้ใช้แก้ไขหรือลบได้
          ],
        ),
      ),
    );
  }
}
