import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.phoneNumber)
            .get();
        if (doc.exists) {
          setState(() {
            userData = doc.data();
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load user data");
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    DateTime? nextService;
    if (userData!['nextServiceDate'] != null) {
      nextService = (userData!['nextServiceDate'] as Timestamp).toDate();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, ${userData!['fullName']}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("Vehicle Name: ${userData!['vehicleName']}"),
            Text("Vehicle Number: ${userData!['vehicleNumber']}"),
            Text("Engine Type: ${userData!['engineType']}"),
            const SizedBox(height: 20),
            if (nextService != null)
              Text("Next Service Date: ${nextService.toLocal().toString().split(' ')[0]}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                DateTime next = DateTime.now().add(const Duration(days: 180));
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser!.phoneNumber)
                    .update({'nextServiceDate': Timestamp.fromDate(next)});
                Fluttertoast.showToast(msg: "Next service scheduled");
                _loadUserData();
              },
              child: const Text("Schedule Next Service"),
            ),
          ],
        ),
      ),
    );
  }
}
