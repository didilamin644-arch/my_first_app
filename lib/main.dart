import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeminiChat(),
    ));

class GeminiChat extends StatefulWidget {
  @override
  _GeminiChatState createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  final TextEditingController _controller = TextEditingController();
  String _response = "اسألني وسأكشف لك سبب الخطأ...";
  final String apiKey = "AIzaSyBj8rXZUUyxtwHlgCa3VG7VHAzW6dVF3p8";

  Future<void> sendRequest(String text) async {
    setState(() => _response = "جاري الفحص والاتصال...");
    try {
      final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
      final res = await http.post(url, 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"contents": [{"parts": [{"text": text}]}]})
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _response = data['candidates'][0]['content']['parts'][0]['text']);
      } else {
        // سيخبرنا هنا بالسبب الحقيقي للرفض
        setState(() => _response = "خطأ رقم (${res.statusCode}): ${res.body}");
      }
    } catch (e) {
      setState(() => _response = "عطل في الشبكة: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini Debug Mode"), backgroundColor: Colors.orange),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(20), child: Text(_response)))),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(icon: Icon(Icons.send), onPressed: () => sendRequest(_controller.text))
              ],
            ),
          )
        ],
      ),
    );
  }
}
