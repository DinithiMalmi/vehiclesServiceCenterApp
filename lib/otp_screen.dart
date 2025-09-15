import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';


class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String fullName, phone, vehicleName, vehicleNumber, engineType;

  OTPScreen({
    required this.verificationId,
    required this.fullName,
    required this.phone,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.engineType,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _verifyOTP() async {
    try {
      String smsCode = otpController.text.trim();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);

      // Save user info in Firestore
      await FirebaseFirestore.instance.collection('users').doc(widget.phone).set({
        'fullName': widget.fullName,
        'phone': widget.phone,
        'vehicleName': widget.vehicleName,
        'vehicleNumber': widget.vehicleNumber,
        'engineType': widget.engineType,
      });

      Fluttertoast.showToast(msg: "Sign-Up Successful!");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter OTP"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _verifyOTP, child: const Text("Verify OTP")),
          ],
        ),
      ),
    );
  }
}
