import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncloop/screens/emailDetails.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map> prompts = [];

  List<Map> generatedEmails = [];

  Future<void> fetchData() async {
    final promptsResponse = await http.get(
      Uri.parse('https://cloud.syncloop.com/tenant/1692080445861/packages.chaturMail.prompts.getPrompts.main'),
      headers: {
        "Authorization":
            "Bearer 5zX/2VXijNuKmwQIwaM2mTxLIUcrMw/l8djfBMZyBOklB5bXVUH6+fd+qV8hA0QG0cMfuZKeddg0zztf2o72KCfkU3U+npM8xcBKwFSXdFXMDvzqQ8xx+XlowQzNckqUQMxkR6lKlQFC8h0zoWyg27fNO5ISYaSivgX50BN41eQvK+oAWlAPZM3rNVzNQx+taRev5BBcDBz3+20yQ5Mud5qCzupWAYidFGVVcSxHphsFuvAZI/G9ZTDFSiLUQb64nHfptE07Jrd8cn4XBk5X640s5H4Z1opLpD0Lmb1uVk82DpdKsnkYVSSPadOKH3pKe+haFk6qN3E8FSAGj+Qec9ZRoWnDo4APw5e7x4izcMB8uiISsXh4ZQf/mMHpfJGZ6TjNgTV7xwzd7JPmu6+DWIjRofKY9OErDC9+a3rob3/JEBdkCK9jrZx8k8QJNtNfLhF9xwj1TJMFYnRFAP6yqyvbDvedZLiLUxiwzzY6KXzHREJF24rlWuxrb+WpSwon6x9J2MjSyoIKP+9rNDr/Eg=="
      },
    );
    final emailsResponse = await http.get(
      Uri.parse('https://cloud.syncloop.com/tenant/1692080445861/packages.chaturMail.email.getEmails.main?userId=1'),
      headers: {
        "Authorization":
            "Bearer 5zX/2VXijNuKmwQIwaM2mTxLIUcrMw/l8djfBMZyBOklB5bXVUH6+fd+qV8hA0QG0cMfuZKeddg0zztf2o72KCfkU3U+npM8xcBKwFSXdFXMDvzqQ8xx+XlowQzNckqUQMxkR6lKlQFC8h0zoWyg27fNO5ISYaSivgX50BN41eQvK+oAWlAPZM3rNVzNQx+taRev5BBcDBz3+20yQ5Mud5qCzupWAYidFGVVcSxHphsFuvAZI/G9ZTDFSiLUQb64nHfptE07Jrd8cn4XBk5X640s5H4Z1opLpD0Lmb1uVk82DpdKsnkYVSSPadOKH3pKe+haFk6qN3E8FSAGj+Qec9ZRoWnDo4APw5e7x4izcMB8uiISsXh4ZQf/mMHpfJGZ6TjNgTV7xwzd7JPmu6+DWIjRofKY9OErDC9+a3rob3/JEBdkCK9jrZx8k8QJNtNfLhF9xwj1TJMFYnRFAP6yqyvbDvedZLiLUxiwzzY6KXzHREJF24rlWuxrb+WpSwon6x9J2MjSyoIKP+9rNDr/Eg=="
      },
    );

    if (promptsResponse.statusCode == 200 && emailsResponse.statusCode == 200) {
      final promptsData = jsonDecode(promptsResponse.body);
      final emailsData = jsonDecode(emailsResponse.body);

      setState(() {
        if (promptsData.containsKey("prompts")) {
          List<dynamic> promptList = promptsData["prompts"];
          for (var promptData in promptList) {
            if (promptData is Map<String, dynamic>) {
              prompts.add(promptData);
            }
          }
        }

        if (emailsData.containsKey("emails")) {
          List<dynamic> emailsList = emailsData["emails"];
          for (var emailData in emailsList) {
            if (emailData is Map<String, dynamic>) {
              generatedEmails.add(emailData);
            }
          }
        }
      });

      return;
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  void initState() {
    Future.wait([fetchData()]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF0057FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0057FF), Color(0xFF00BFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prompts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: prompts.length,
                      itemBuilder: (context, index) {
                        return PromptCard(
                          promptId: prompts[index]["promptId"],
                          title: prompts[index]["title"],
                          description: prompts[index]["description"],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Generated Emails',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: generatedEmails.length,
                      itemBuilder: (context, index) {
                        return GeneratedEmailCard(
                          subject: generatedEmails[index]["subject"],
                          keywords: generatedEmails[index]["keywords"],
                          generatedEmail: generatedEmails[index]["result"],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromptCard extends StatelessWidget {
  final String title;
  final String description;
  final int promptId;

  PromptCard({required this.title, required this.description, required this.promptId});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent.withOpacity(0.4),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              children: const [
                Icon(
                  Icons.info_outline,
                  size: 15,
                  color: Colors.white,
                ),
                SizedBox(width: 2),
                Text(
                  "Click to generate",
                  style: TextStyle(
                    fontSize: 10,
                    overflow: TextOverflow.visible,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
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

class GeneratedEmailCard extends StatelessWidget {
  final String generatedEmail;
  final String subject;
  final String keywords;

  GeneratedEmailCard({required this.generatedEmail, required this.keywords, required this.subject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailDetailScreen(
              subject: subject,
              keywords: keywords,
              result: generatedEmail,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.blueAccent.withOpacity(0.6),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Text(
                  keywords,
                  style: const TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    size: 15,
                    color: Colors.white,
                  ),
                  SizedBox(width: 2),
                  Text(
                    "Click to view",
                    style: TextStyle(
                      fontSize: 10,
                      overflow: TextOverflow.visible,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
