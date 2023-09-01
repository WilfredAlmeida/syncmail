import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';
import 'emailDetails.dart';

class EmailComposeScreen extends StatefulWidget {
  final int promptId;

  const EmailComposeScreen({super.key, required this.promptId});

  @override
  _EmailComposeScreenState createState() => _EmailComposeScreenState();
}

class _EmailComposeScreenState extends State<EmailComposeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();

  var _isLoading = false;

  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return 'Subject is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Keywords are required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Generate Email")),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0057FF), Color(0xFF00BFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Generate Email',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: _validateName, // Name validation
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _keywordsController,
                      decoration: InputDecoration(
                        labelText: 'Keywords',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: _validateEmail, // Email validation
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          if (_formKey.currentState!.validate()) {
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            final userId = prefs.getInt("userId");

                            var headers = {'userId': "${userId!}", 'Content-Type': 'application/json', 'Authorization': "Bearer $API_TOKEN"};

                            var request = http.Request(
                              'POST',
                              Uri.parse(
                                'https://cloud.syncloop.com/tenant/1692080445861/packages.chaturMail.email.generateEmail.main',
                              ),
                            );
                            request.body = json.encode({
                              "promptId": 1,
                              "keywords": _keywordsController.text,
                              "subject": _subjectController.text,
                            });
                            request.headers.addAll(headers);

                            http.StreamedResponse response = await request.send();

                            if (response.statusCode == 200) {
                              final generatedEmailRaw = await response.stream.bytesToString();
                              final generatedEmail = jsonDecode(generatedEmailRaw);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmailDetailScreen(
                                    subject: _subjectController.text,
                                    keywords: _keywordsController.text,
                                    result: generatedEmail["generatedEmail"],
                                  ),
                                ),
                              );

                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              print(response.reasonPhrase);
                              _isLoading = false;
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Generate Email',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0057FF),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
