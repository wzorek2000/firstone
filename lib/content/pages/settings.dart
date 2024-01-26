import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import '../themes/theme_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _deleteAllEntries() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Pobranie kolekcji wpisów bieżącego użytkownika
      var collection = FirebaseFirestore.instance.collection('entries');
      var snapshots = await collection.where('userId', isEqualTo: userId).get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      // Usunięcie wpisów
      await batch.commit();
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Potwierdzenie"),
        content: const Text(
            "Czy na pewno chcesz usunąć wszystkie swoje wpisy? Proces ten jest nieodwracalny."),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await _deleteAllEntries();
              Navigator.of(ctx).pop();
            },
            child: const Text("Tak"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Nie"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Zmień motyw',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const ThemeSelector(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showDeleteConfirmationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Usuń moje wpisy',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Wyloguj się',
                  style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text("Obecnie zalogowany - ${user?.email}"),
            ),
          ],
        ),
      ),
    );
  }
}
