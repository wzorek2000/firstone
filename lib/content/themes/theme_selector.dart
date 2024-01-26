import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_manager.dart';
import 'themes.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  _loadSelectedIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int selectedIndex = prefs.getInt('selectedIndex') ?? 0;
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }

  _saveSelectedIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        MyThemes.themes.length,
        (index) {
          bool isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              _saveSelectedIndex(index);
              themeManager.setTheme(index);
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MyThemes.themes[index].primaryColor,
                    MyThemes.themes[index].primaryColorDark,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: const Color.fromARGB(126, 255, 255, 255),
                        width: 5,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
