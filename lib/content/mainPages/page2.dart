import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/breathing.dart';

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Quote> motivationalQuotes = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    fetchQuotes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void fetchQuotes() async {
    var response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes?category=inspirational'),
      headers: {
        'X-Api-Key': 'qdzV0QYg1AseVH3oBur1aQ==5uhXZ8hjIeLPnzPp',
      },
    );

    if (response.statusCode == 200) {
      var quotesJson = json.decode(response.body) as List;
      List<Quote> loadedQuotes = [];

      for (var quoteJson in quotesJson) {
        loadedQuotes.add(Quote(
          text: quoteJson['quote'],
          author: quoteJson['author'],
        ));
      }

      setState(() {
        motivationalQuotes = loadedQuotes;
      });
    } else {
      print('Failed to load quotes');
    }
  }

  void toggleAnimation() {
    if (!_controller.isAnimating) {
      _controller.forward();
    } else {
      _controller.stop();
    }
  }

  String get breathingText {
    if (!_controller.isAnimating) {
      return 'tap to start';
    } else if (_controller.value < 0.5) {
      return 'Wdech';
    } else {
      return 'Wydech';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          motivationalQuotes.isEmpty
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageView.builder(
                          itemCount: motivationalQuotes.length,
                          controller: PageController(initialPage: currentIndex),
                          onPageChanged: (int index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    motivationalQuotes[index].text,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      motivationalQuotes[index].author,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: FloatingActionButton(
                            onPressed: fetchQuotes,
                            tooltip: 'Fetch New Quotes',
                            backgroundColor: Colors.purple,
                            child: const Icon(Icons.casino),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BreathingAnimationPage()));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
              ),
              child: const Text('Przejdź do ćwiczenia oddechowego'),
            ),
          ),
        ],
      ),
    );
  }
}
