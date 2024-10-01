import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sensor_detail.dart';
import 'sensor_settings.dart';
import 'profile_screen.dart'; // Import โปรไฟล์หน้าจอใหม่
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class SensorDashboard extends StatefulWidget {
  final String name;  // เพิ่มตัวแปรสำหรับชื่อ
  final String email;  // เพิ่มตัวแปรสำหรับอีเมล

  SensorDashboard({required this.name, required this.email}); // รับค่า name และ email จากหน้าจอก่อนหน้า

  @override
  _SensorDashboardState createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  List<dynamic> sensors = [];

  @override
  void initState() {
    super.initState();
    loadSensorData();
  }

  Future<void> loadSensorData() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/sensor_data.json');

    if (!await file.exists()) {
      final String response = await rootBundle.loadString('assets/sensor_data.json');
      await file.writeAsString(response);
    }

    final String jsonString = await file.readAsString();
    final data = await json.decode(jsonString);
    setState(() {
      sensors = data['sensors'];
    });
  }

  void _updateSensorValue(int index, String newValue) {
    setState(() {
      sensors[index]['value'] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Image.asset('assets/icons/menu.png', width: 30, height: 30),
            onPressed: () {},
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Image.asset('assets/icons/notification.png', width: 30, height: 30),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Image.asset('assets/icons/profile.png', width: 30, height: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      firstName: widget.name,  // ส่งชื่อผู้ใช้จากตัวแปรที่รับเข้ามา
                      lastName: '',  // กรณีไม่มีนามสกุลให้ส่งเป็นค่าว่าง
                      email: widget.email,  // ส่งอีเมลผู้ใช้จากตัวแปรที่รับเข้ามา
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image.asset('assets/icons/smart-home.png', width: 80, height: 80),
                  ),
                  SizedBox(height: 10),
                  Text('Welcome Home', style: TextStyle(color: Colors.black, fontSize: 20)),
                  Text(widget.name, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Smart Devices', style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sensors.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SensorDetail(
                            sensor: sensors[index],
                            onSave: (newValue) {
                              _updateSensorValue(index, newValue);
                            },
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          sensors[index]['value'] = result['value'];
                        });
                      }
                    },
                    child: SensorCard(
                      sensorType: sensors[index]['type'],
                      sensorValue: sensors[index]['value'],
                      sensorUnit: sensors[index]['unit'],
                      sensorIcon: sensors[index]['icon'],
                      sensorStatus: sensors[index]['status'] ?? false,
                      onSwitchChanged: (bool value) {
                        setState(() {
                          sensors[index]['status'] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String sensorType;
  final String sensorValue;
  final String sensorUnit;
  final String sensorIcon;
  final bool sensorStatus;
  final Function(bool) onSwitchChanged;

  SensorCard({
    required this.sensorType,
    required this.sensorValue,
    required this.sensorUnit,
    required this.sensorIcon,
    required this.sensorStatus,
    required this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: ListTile(
        leading: Image.asset('assets/icons/$sensorIcon.png', width: 40, height: 40),
        title: Text(sensorType, style: TextStyle(color: Colors.black)),
        subtitle: Text('Value: $sensorValue $sensorUnit', style: TextStyle(color: Colors.black54)),
        trailing: Switch(
          value: sensorStatus,
          onChanged: onSwitchChanged,
        ),
      ),
    );
  }
}
