import 'package:flutter/material.dart';
import 'add_entry_logic.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class AddEntryModal {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _emojis = ["🥰", "☺️", "🙂", "😔", "😞"];
  String? _selectedEmoji;
  XFile? _imageFile;
  String? _imagePath;
  bool _isLoading = false;

  void _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageFile = image;
      _imagePath = image.path;
      (context as Element).markNeedsBuild();
    }
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showAddEntryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding:
                MediaQuery.of(bc).viewInsets.add(const EdgeInsets.all(16.0)),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Tytuł wpisu",
                        border: OutlineInputBorder(),
                      ),
                      controller: _titleController,
                      maxLength: 50,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Proszę podać tytuł wpisu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Treść wpisu",
                        border: OutlineInputBorder(),
                      ),
                      controller: _contentController,
                      maxLength: 500,
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Proszę podać treść wpisu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_imagePath == null)
                              ElevatedButton(
                                onPressed: () => _pickImage(context),
                                child: const Text('Wybierz zdjęcie'),
                              ),
                            if (_imagePath != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => _pickImage(context),
                                    child: Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.deepPurple, width: 3),
                                      ),
                                      child: ClipOval(
                                        child: Image.file(
                                          File(_imagePath!),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _imagePath = null;
                                      });
                                    },
                                    child: Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 150,
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Emoji",
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedEmoji,
                        hint: const Text('Wybierz'),
                        isExpanded: true,
                        items: _emojis.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _selectedEmoji = value;
                          _formKey.currentState?.validate();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Proszę wybrać emoji';
                          }
                          return null;
                        },
                        iconSize: 32,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          try {
                            await AddEntryLogic.addNewEntry(
                              formKey: _formKey,
                              context: context,
                              titleController: _titleController,
                              contentController: _contentController,
                              selectedEmoji: _selectedEmoji,
                              imageFile: _imageFile,
                            );
                            _showToast('Wpis dodany!', Colors.green);
                          } catch (e) {
                            _showToast("Coś poszło nie tak, spróbuj ponownie",
                                Colors.red);
                          } finally {
                            setState(() => _isLoading = false);
                          }
                          if (_formKey.currentState!.validate()) {
                            setState(() {});
                          }
                        },
                        child: const Text('Dodaj nowy wpis'),
                      ),
                    ),
                    if (_isLoading) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
