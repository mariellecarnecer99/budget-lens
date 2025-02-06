import 'package:expense_tracker/screens/account_management/password_management.dart';
import 'package:expense_tracker/screens/account_management/profile.dart';
import 'package:expense_tracker/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/generated/l10n.dart';

class AccountManagementList extends StatefulWidget {
  const AccountManagementList({super.key});

  @override
  State<AccountManagementList> createState() => _AccountManagementListState();
}

class _AccountManagementListState extends State<AccountManagementList> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.accountManagement),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue.shade800),
            title: Text(localization.profileDetails),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          Divider(
            color: Colors.blue.shade800,
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.blue.shade800),
            title: Text(localization.passwordManagement),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PasswordManagementPage()),
              );
            },
          ),
          Divider(
            color: Colors.blue.shade800,
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue.shade800),
            title: Text(localization.signOut),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.loggedOutSuccess)),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.loggedOutError)),
                );
              }
            },
          ),
          Divider(
            color: Colors.blue.shade800,
          ),
        ],
      ),
    );
  }
}