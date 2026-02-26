import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: AIChat(), debugShowCheckedModeBanner: false));

class AIChat extends StatefulWidget {
  @override
  _AIChatState createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final TextEditingController _controller = TextEditingController();
  String _response = "مرحباً! أنا جاهز الآن لشرح الصور والنصوص. اسألني أي شيء.";
  // مفتاحك الفعال
  final String apiKey = "AIzaSyB1po-OkPEhOWkxe9LrAvz24CH-LWYMheA"; 

  Future<void> askAI(String question) async {
    if (question.isEmpty) return;
    setState(() => _response = "جاري التحليل والتحقق...");
    
    // الرابط المحدث والنهائي ليعمل مع gemini-1.5-flash بنجاح
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
    
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [{
              "parts": [{"text": question}]
            }]
          }));
      
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() => _response = data['candidates'][0]['content']['parts'][0]['text']);
      } else {
        setState(() => _response = "تنبيه: ${data['error']['message']}");
      }
    } catch (e) {
      setState(() => _response = "فشل في الاتصال. تأكد من الإنترنت.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini المطور"), backgroundColor: Colors.deepPurple),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(20), 
          child: Text(_response, style: TextStyle(fontSize: 18), textDirection: TextDirection.rtl)))),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
          child: Row(children: [
            Icon(Icons.camera_alt, color: Colors.deepPurple), // رمز الكاميرا التي فعلت أذوناتها
            SizedBox(width: 10),
            Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: "اسأل أو اطلب شرحاً..."))),
            IconButton(icon: Icon(Icons.send, color: Colors.deepPurple), onPressed: () {
              askAI(_controller.text);
              _controller.clear();
            })
          ]),
        )
      ]),
    );
  }
}


