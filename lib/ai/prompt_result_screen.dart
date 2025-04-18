import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_monitor/api.dart';
import 'package:water_monitor/models/monitored_data.dart';

Future<String> sendPrompt(String prompt) async {
  String url = API2; // Replace with your API URL

  Map<String, dynamic> requestData = {
    "prompt": prompt, // Sending prompt in JSON format
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),
    );

    try {
      var responseData = jsonDecode(response.body);
      // var responseData = response.body;
      return responseData["result"];
    } catch (e) {
      return "Error: Received non-JSON response";
    }
  } catch (e) {
    return "Error: $e";
  }
}

class ContentScreen extends StatefulWidget {
  final MonitoredData latestAlertData;
  const ContentScreen({super.key, required this.latestAlertData});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)); // Copies text to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xff767D9A),
        content: Text(
          "Copied to clipboard!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String data = '';
    final prompt =
        "pH: ${widget.latestAlertData.p}  Turbidity: ${widget.latestAlertData.u}  TDS: ${widget.latestAlertData.d} want to make the water drinkable";
    return Scaffold(
      appBar: AppBar(title: Text("AI Helper"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff323445),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "pH: ${widget.latestAlertData.p}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Turbidity: ${widget.latestAlertData.u}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "TDS: ${widget.latestAlertData.d}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Temperature: ${widget.latestAlertData.t}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Now: We want to make the water drinkable ",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: sendPrompt(prompt),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                data = snapshot.data!;
                return Container(
                  decoration: BoxDecoration(
                    color: Color(0xff323445),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      MarkdownBody(
                        data: data,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(fontSize: 16, color: Colors.white),
                          h1: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          h2: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          h3: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () => copyToClipboard(data),
                        icon: Icon(Icons.copy),
                        label: Text(
                          "Copy to Clipboard",
                          // style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
