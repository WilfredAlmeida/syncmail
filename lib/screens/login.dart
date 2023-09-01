import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncloop/screens/signup.dart';

import '../utils/utils.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  var _isLoading = false;

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                    _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                var headers = {'Content-Type': 'application/json', 'Authorization': "Bearer $API_TOKEN"};

                                var request = http.Request('POST', Uri.parse('https://cloud.syncloop.com/tenant/1692080445861/packages.chaturMail.user.login.main'));
                                request.body = json.encode({"email": _emailController.text});
                                request.headers.addAll(headers);

                                http.StreamedResponse response = await request.send();

                                if (response.statusCode == 200) {
                                  final responseRaw = await response.stream.bytesToString();
                                  final responseParsed = jsonDecode(responseRaw);

                                  if (responseParsed.containsKey("id")) {
                                    print(responseParsed["id"]);

                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setInt("userId", responseParsed["id"]);

                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DashboardScreen(),
                                      ),
                                    );
                                  } else {
                                    print("User not found");
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('User not found'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                } else {
                                  print(response.reasonPhrase);
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
                            child: const Text(
                              'Login',
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
          Positioned(
            bottom: 40,
            left: 100,
            right: 100,
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0057FF),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
