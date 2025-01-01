import 'dart:io';

import 'package:connectus/common/widgets/error.dart';
import 'package:connectus/features/auth/screens/login_screen.dart';
import 'package:connectus/features/auth/screens/otp_screen.dart';
import 'package:connectus/features/auth/screens/user_information_screen.dart';
import 'package:connectus/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:connectus/features/chat/screens/mobile_chat_screen.dart';
import 'package:connectus/screens/confirm_status_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OtpScreen(verificationId: verificationId),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => UserInformationScreen());
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(builder: (context) => SelectContactsScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(name: name, uid: uid),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(file: file),
      );
    default:
      return MaterialPageRoute(
        builder:
            (context) => const Scaffold(
              body: ErrorScreen(error: "This Page Doesn\'t exist"),
            ),
      );
  }
}
