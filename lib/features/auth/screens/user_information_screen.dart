import 'dart:io';

import 'package:connectus/common/utils/utils.dart';
import 'package:flutter/material.dart';

class UserInformationScreen extends StatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController namecontroller= TextEditingController();
  File? image;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    namecontroller.dispose();
  }

  void selectImage() async{
    image= await pickImageFromGallery(context);
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  image == null ? 
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg",
                    ),
                    radius: 64,
                  ) : 
                  CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 64,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width*0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller:namecontroller ,
                      decoration: const InputDecoration(
                        hintText: "Enter your name"
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.done))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
