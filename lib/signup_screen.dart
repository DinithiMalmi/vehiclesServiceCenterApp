import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  String? engineType;

  List<String> engineTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];

  void _submit() async {
    if (_formKey.currentState!.validate() && engineType != null) {
      String phone = "+94${phoneController.text}"; // adjust country code

      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: e.message ?? "Error");
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                verificationId: verificationId,
                fullName: fullNameController.text,
                phone: phone,
                vehicleName: vehicleNameController.text,
                vehicleNumber: vehicleNumberController.text,
                engineType: engineType!,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      Fluttertoast.showToast(msg: "Please fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (v) => v!.isEmpty ? "Enter Full Name" : null,
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: (v) => v!.isEmpty ? "Enter Phone Number" : null,
              ),
              TextFormField(
                controller: vehicleNameController,
                decoration: const InputDecoration(labelText: "Vehicle Name"),
                validator: (v) => v!.isEmpty ? "Enter Vehicle Name" : null,
              ),
              TextFormField(
                controller: vehicleNumberController,
                decoration: const InputDecoration(labelText: "Vehicle Number"),
                validator: (v) => v!.isEmpty ? "Enter Vehicle Number" : null,
              ),
              DropdownButtonFormField(
                items: engineTypes
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                hint: const Text("Select Engine Type"),
                onChanged: (String? value) {
                  setState(() {
                    engineType = value;
                  });
                },
                validator: (v) => v == null ? "Select Engine Type" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}
