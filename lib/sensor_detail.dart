import 'package:flutter/material.dart';

class SensorDetail extends StatefulWidget {
  final Map<String, dynamic> sensor;
  final Function(String) onSave;

  SensorDetail({required this.sensor, required this.onSave});

  @override
  _SensorDetailState createState() => _SensorDetailState();
}

class _SensorDetailState extends State<SensorDetail> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.sensor['value']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // เปลี่ยนสีพื้นหลังเป็นสีขาว
      appBar: AppBar(
        backgroundColor: Colors.grey,  // สีของ AppBar เป็นสีเทา
        elevation: 0,
        title: Text('${widget.sensor['type']} Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sensor Type: ${widget.sensor['type']}', style: TextStyle(fontSize: 22, color: Colors.black)),
            SizedBox(height: 10),
            Text('Value: ${widget.sensor['value']} ${widget.sensor['unit']}', style: TextStyle(fontSize: 18, color: Colors.black)),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showEditDialog();
                  },
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.grey[300],  // สีข้อความของปุ่ม Edit เป็นสีดำ
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red, // สีข้อความของปุ่ม Delete เป็นสีขาว
                  ),
                  onPressed: () {
                    _resetSensorValue();
                  },
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _resetSensorValue() {
    setState(() {
      widget.sensor['value'] = ""; // รีเซ็ตค่า value ให้เป็นค่าเริ่มต้น (สามารถปรับเปลี่ยนตามต้องการ)
    });
    widget.onSave(widget.sensor['value']); // เรียกใช้ callback เพื่ออัพเดตค่าในหน้า Dashboard
    Navigator.of(context).pop(widget.sensor); // กลับไปยังหน้าก่อนหน้า
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Sensor Value'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Sensor Value',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showConfirmationDialog(_controller.text);
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(String newValue) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Changes'),
          content: Text('Do you want to save the following changes?\n\nNew Sensor Value: $newValue'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onSave(newValue);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
