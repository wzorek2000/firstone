import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EntryDetailsScreen extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String emote;
  final String imageUrl;

  const EntryDetailsScreen({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.emote,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły - $title'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  emote,
                  style: const TextStyle(fontSize: 24.0),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              content,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/img/image.png'),
                  )
                : Image.asset('assets/img/image.png'),
          ],
        ),
      ),
    );
  }
}
