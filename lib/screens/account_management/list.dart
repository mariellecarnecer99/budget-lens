import 'package:expense_tracker/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountManagementList extends StatefulWidget {
  const AccountManagementList({super.key});

  @override
  State<AccountManagementList> createState() => _AccountManagementListState();
}

class _AccountManagementListState extends State<AccountManagementList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Management"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile Details"),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Password Management"),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sign Out"),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logged out successfully")),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error logging out")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}