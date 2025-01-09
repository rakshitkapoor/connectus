import 'dart:io';

import 'package:connectus/colors.dart';
import 'package:connectus/features/status/controller/status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const String routeName = '/consumer-status-screen';
  final File file;
  const ConfirmStatusScreen({super.key, required this.file});


  void addStatus(WidgetRef ref,BuildContext context){
    ref.read(statusControllerProvider).addStatus(file, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(aspectRatio: 9 / 16, child: Image.file(file)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStatus(ref, context),
        child: const Icon(Icons.done, color: Colors.white),
        backgroundColor: tabColor,
      ),
    );
  }
}
