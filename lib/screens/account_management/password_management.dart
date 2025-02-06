import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/generated/l10n.dart';

class PasswordManagementPage extends StatefulWidget {
  const PasswordManagementPage({super.key});

  @override
  State<PasswordManagementPage> createState() => _PasswordManagementPageState();
}

class _PasswordManagementPageState extends State<PasswordManagementPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _errorMessage = '';

  Future<void> _changePassword() async {
    final localization = S.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;

      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: _currentPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(_newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.passwordUpdateSuccess)),
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localization.passwordManagement)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: localization.currentPassword,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.pleaseEnterPassword;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localization.newPassword,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.pleaseEnterNewPassword;
                  }
                  if (value.length < 6) {
                    return localization.passwordValidation;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localization.confirmNewPassword,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.pleaseConfirmNewPassword;
                  }
                  if (value != _newPasswordController.text) {
                    return localization.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100, 50),
                  backgroundColor: Colors.blue.shade800,
                ),
                child: Text(
                    localization.changePassword,
                    style: TextStyle(fontSize: 18, color: Colors.white)
                ),
              ),
              SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
