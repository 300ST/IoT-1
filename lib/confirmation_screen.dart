import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> sensor;
  final String newValue;
  final Function(String) onSave;  // Callback to update value in dashboard

  ConfirmationScreen({
    required this.sensor,
    required this.newValue,
    required this.onSave,
  });

  Future<void> _saveChanges(BuildContext context) async {
    sensor['value'] = newValue;

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/sensor_data.json');
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    int sensorIndex = jsonMap['sensors'].indexWhere((s) => s['id'] == sensor['id']);
    if (sensorIndex != -1) {
      jsonMap['sensors'][sensorIndex]['value'] = newValue;
    }

    jsonString = json.encode(jsonMap);
    await file.writeAsString(jsonString);

    onSave(newValue);  // Trigger the callback to update the dashboard
    Navigator.of(context).pop(); // Close the confirmation screen
    Navigator.of(context).pop(sensor); // Navigate back to the detail screen with updated sensor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Changes'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Do you want to save the following changes?', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('New Sensor Value: $newValue', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(), // Cancel and go back
                  child: Text('Cancel'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _saveChanges(context), // Save and go back with data
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
