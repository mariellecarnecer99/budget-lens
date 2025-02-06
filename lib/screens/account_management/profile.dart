import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/generated/l10n.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _phoneNumber, _bio;
  XFile? _profileImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  Future<void> _pickImage() async {
    await _requestPermissions();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = image;
      });

      final file = File(image.path);
      try {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

        await ref.putFile(file);

        String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'profileImage': downloadUrl});
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _updateProfile() async {
    final localization = S.of(context);
    if (_formKey.currentState?.validate() ?? false) {
      User? user = FirebaseAuth.instance.currentUser;

      if (_name != null) {
        await user?.updateDisplayName(_name);
      }

      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid);

      await userRef.set({
        'fullName': _name,
        'phoneNumber': _phoneNumber,
        'bio': _bio,
        'profileImage': _profileImage != null
            ? await _uploadProfileImage(_profileImage!)
            : null,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.profileUpdateSuccess)),
      );
    }
  }

  Future<String?> _uploadProfileImage(XFile image) async {
    try {
      File file = File(image.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

      await ref.putFile(file);

      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _loadProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;

        setState(() {
          _name = data['fullName'];
          _phoneNumber = data['phoneNumber'];
          _bio = data['bio'];
          _profileImage = data['profileImage'] != null
              ? XFile(data['profileImage'])
              : null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.profile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _profileImage != null
                          ? NetworkImage(_profileImage!.path)
                          : AssetImage('assets/default_profile.png') as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  hintText: localization.fullName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.pleaseEnterFullName;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: InputDecoration(
                  hintText: localization.phoneNumber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => _phoneNumber = value,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _bio,
                decoration: InputDecoration(
                  hintText: localization.bio,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => _bio = value,
                maxLines: 3,
                maxLength: 200,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100, 50),
                  backgroundColor: Colors.blue.shade800,
                ),
                child: Text(
                  localization.updateProfile,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
