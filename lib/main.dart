import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      home: AIChat(),
      debugShowCheckedModeBanner: false,
    ));

class AIChat extends StatefulWidget {
  @override
  _AIChatState createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final TextEditingController _controller = TextEditingController();
  String _response = "مرحباً! أنا مساعدك الذكي، كيف يمكنني مساعدتك اليوم؟";
  
  // مفتاح الذكاء الخاص بك الذي قمت بإنشائه
  final String apiKey = "AIzaSyB1po-OkPEhOWkxe9LrAvz24CH-LWYMheA"; 

  Future<void> askAI(String question) async {
    if (question.isEmpty) return;
    
    setState(() => _response = "جاري التفكير...");
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [{"text": question}]
            }
          ]
        }),
      );
      
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() => _response = data['candidates'][0]['content']['parts'][0]['text']);
      } else {
        setState(() => _response = "حدث خطأ في طلب الذكاء: ${data['error']['message']}");
      }
    } catch (e) {
      setState(() => _response = "خطأ في الاتصال: تأكد من تشغيل الإنترنت.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("المساعد الذكي Gemini"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  _response,
                  style: TextStyle(fontSize: 18),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "اسألني أي شيء...", border: InputBorder.none),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () {
                    askAI(_controller.text);
                    _controller.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

