import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rank133/Colors/appColors.dart';
import 'package:rank133/homeScreen.dart';


class ProfileEditScreen extends StatefulWidget {
  static const routeName = '/profileedit';
  const ProfileEditScreen({Key? key, User? user}) : super(key: key);
  
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();

}

final auth = FirebaseAuth.instance;
final storageRef = FirebaseStorage.instance.ref();
final profileImageRef = storageRef.child("userImages/${auth.currentUser!.uid}.jpg");

class _ProfileEditScreenState extends State<ProfileEditScreen> {

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      print(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  final _nameTextController = TextEditingController();
  final name = auth.currentUser!.displayName;

  @override
  Widget build(BuildContext context) {
    _nameTextController.text = name!;
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: genericAppBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(140),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                child: CircleAvatar(
                  radius: 120,
                  backgroundImage: NetworkImage(auth.currentUser!.photoURL ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                ),
                onTap: () async {
                  await pickImage();
                  if(image != null){
                    await profileImageRef.putFile(image!.absolute).catchError((error)=>print(error));
                    String url = await profileImageRef.getDownloadURL();
                    await auth.currentUser!.updatePhotoURL(url);
                  }
                  setState((){});

                },
              )
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: genericTextFieldBackgroundColor,
                border: Border.all(
                  color: genericTextFieldOutlineColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 60,
              child: TextFormField(
                style: TextStyle(color: genericTextColor),
                controller: _nameTextController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Name'
                ),
                // initialValue: name,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: LogInButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      await auth.currentUser!.updateDisplayName(_nameTextController.text);
                      Navigator.pop(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: LogInButtonTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}

