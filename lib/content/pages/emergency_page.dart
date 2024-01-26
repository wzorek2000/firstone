import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({super.key});

  void navigateToContent(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomoc'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => navigateToContent(context),
        ),
      ),
      body: ListView(
        children: const <Widget>[
          ContentCard(
            imagePath: 'assets/img/telZaufania.jpg',
            title: 'Kryzysowy Telefon Zaufania',
            description:
                'Od poniedziałku do piątku w godzinach od 14:00 do 22:00',
            phoneNumber: '116123',
          ),
          ContentCard(
            imagePath: 'assets/img/telefonDzieciIMlodziezy.png',
            title: 'Telefon Zaufania dla dzieci i młodzieży',
            description: '24 godziny 7 dni w tygodniu',
            phoneNumber: '116111',
          ),
          ContentCard(
            imagePath: 'assets/img/niebiskalinia.png',
            title: 'Niebieska Linia',
            description: '24 godziny 7 dni w tygodniu',
            phoneNumber: '800120002',
          ),
          ContentCard(
            imagePath:
                'assets/img/92efe20_10347786-10154661143875702-4083118599215029043-n.png',
            title: 'Telefon Zaufania dla osób starszych',
            description: 'W poniedziałki, środy i czwartki od 17:00 do 20:00',
            phoneNumber: '226350954',
          ),
          ContentCard(
            imagePath: 'assets/img/fundacjaPrawKobiet.png',
            title: 'Kryzysowy Telefon Centrum Praw Kobiet',
            description: '24 godziny 7 dni w tygodniu',
            phoneNumber: '800107777',
          ),
        ],
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String phoneNumber;

  const ContentCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    const double h = 150.0;

    return Card(
      child: Column(
        children: <Widget>[
          Container(
            height: h,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    imagePath.isNotEmpty ? imagePath : 'assets/img/image.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: imagePath.isEmpty
                ? const Placeholder(color: Colors.transparent)
                : null,
          ),
          ListTile(
            title: Text(title),
            subtitle: Text(description),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
            ),
            onPressed: () async {
              final url = "tel:$phoneNumber";
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Nie udało się wykonać połączenia';
              }
            },
            child: const Text(
              'Zadzwoń',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
