import 'package:connectus/colors.dart';
import 'package:connectus/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpScreen extends ConsumerWidget {
  static const String routeName = "/otp-screen";
  const OtpScreen({super.key, required this.verificationId});
  final String verificationId;

  void verifyOTP(BuildContext context, String userOTP, WidgetRef ref) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text("Verifying your number"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text("We have sent an SMS with a code."),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(fontSize: size.height * 0.05),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if(val.length==6){
                    verifyOTP(context, val.trim(), ref);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
