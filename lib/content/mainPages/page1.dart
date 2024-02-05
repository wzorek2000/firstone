import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/emergency_page.dart';
import '../bottom_navigation_bar.dart';
import 'page2.dart';
import 'page3.dart';
import '../pages/settings.dart';
import '../addEntry/add_entry.dart';
import '../addEntry/entry_window.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  int currentIndex = 0;
  final AddEntryModal _addEntryModal = AddEntryModal();

  void navigateToEmergency(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmergencyButton()),
    );
  }

  void navigateToSettings(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    const double bottomNavBarHeight = kBottomNavigationBarHeight;

    return Scaffold(
      key: const ValueKey('contentScreen'),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton(
              key: const ValueKey('emergencyButton'),
              onPressed: () => navigateToEmergency(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: const Text(
                "Emergency",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            key: const ValueKey('settings'),
            icon: const Icon(Icons.settings),
            iconSize: 40,
            onPressed: () => navigateToSettings(context),
          ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: currentIndex == 0
          ? Container(
              margin: const EdgeInsets.only(bottom: bottomNavBarHeight + 20),
              child: FloatingActionButton(
                onPressed: () => _addEntryModal.showAddEntryModal(context),
                child: const Icon(Icons.add),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBarScreen(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }

  Widget _buildContent() {
    switch (currentIndex) {
      case 0:
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('entries')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('date', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    Timestamp? timestamp = data['date'] as Timestamp?;
                    String formattedDate = timestamp != null
                        ? DateFormat('dd.MM.yyyy HH:mm')
                            .format(timestamp.toDate())
                        : 'No date provided';
                    return _buildEntryItem(
                      title: data['title'],
                      content: data['content'],
                      date: formattedDate,
                      emote: data['emoji'] ?? '',
                      imageUrl: data['imageUrl'] ?? '',
                    );
                  }).toList(),
                );
            }
          },
        );
      case 1:
        return const Page2();
      case 2:
        return const Page3();
      default:
        return Container();
    }
  }

  Widget _buildEntryItem({
    required String title,
    required String content,
    required String date,
    required String emote,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EntryDetailsScreen(
              title: title,
              content: content,
              date: date,
              emote: emote,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[300],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date),
                Text(
                  emote,
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
