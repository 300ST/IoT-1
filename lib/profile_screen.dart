import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  ProfileScreen({required this.firstName, required this.lastName, required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('My Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/icons/profile.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14,
                    child: IconButton(
                      icon: Icon(Icons.edit, size: 16, color: Colors.grey),
                      onPressed: () {
                        // ฟังก์ชันแก้ไขรูป
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${widget.firstName} ${widget.lastName}',  // แสดงชื่อและนามสกุล
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(widget.email, style: TextStyle(fontSize: 16, color: Colors.grey)),  // แสดงอีเมล
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Image.asset('assets/icons/antenna.png', width: 24, height: 24),
                title: Text('4 devices connected'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/icons/setting-lines.png', width: 24, height: 24),
                title: Text('Advanced account settings'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/icons/exit.png', width: 24, height: 24),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
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
