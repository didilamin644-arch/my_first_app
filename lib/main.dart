import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: GeminiChat(),
    ));

class GeminiChat extends StatefulWidget {
  @override
  _GeminiChatState createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  final TextEditingController _controller = TextEditingController();
  String _response = "مرحباً! أنا Gemini المدمج في تطبيقك. اسألني أي شيء...";
  final String apiKey = "AIzaSyBj8rXZUUyxtwHlgCa3VG7VHAzW6dVF3p8";

  Future<void> sendRequest(String text) async {
    if (text.isEmpty) return;
    
    setState(() => _response = "جاري التفكير...");
    try {
      final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey");
      final res = await http.post(url, 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": text}]}]
        })
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _response = data['candidates'][0]['content']['parts'][0]['text']);
      } else {
        setState(() => _response = "خطأ من الخادم (رمز ${res.statusCode}). تأكد من أن المفتاح فعال.");
      }
    } catch (e) {
      setState(() => _response = "فشل الاتصال. يرجى التأكد من الإنترنت أو تشغيل VPN إذا كنت في منطقة محظورة.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini AI Pro"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.withOpacity(0.1),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: SelectableText(
                  _response,
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "اكتب رسالتك هنا...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      sendRequest(_controller.text);
                      _controller.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
