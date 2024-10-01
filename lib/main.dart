import 'package:flutter/material.dart';
import 'login_screen.dart'; // สมมุติว่าคุณมีหน้าจอ Login อยู่ในไฟล์นี้

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // ตั้งค่าหน้าจอเริ่มต้นที่นี่
    );
  }
}