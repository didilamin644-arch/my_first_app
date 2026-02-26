import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: GeminiChat(),
    ));

class GeminiChat extends StatefulWidget {
  @override
  _GeminiChatState createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  final TextEditingController _controller = TextEditingController();
  String _response = "نظام الإصلاح التلقائي مفعل. اسألني أي شيء...";
  final String apiKey = "AIzaSyBj8rXZUUyxtwHlgCa3VG7VHAzW6dVF3p8";

  Future<void> sendRequest(String text) async {
    if (text.trim().isEmpty) return;
    setState(() => _response = "🔍 جاري محاولة الاتصال وتجاوز حجب الشبكة...");
    
    try {
      // محاولة الاتصال المباشر مع مهلة زمنية ذكية
      final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"contents": [{"parts": [{"text": text}]}]})
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _response = data['candidates'][0]['content']['parts'][0]['text']);
      } else {
        setState(() => _response = "⚠️ الخادم استلم الطلب لكنه رفضه (Code ${response.statusCode}). تأكد من الـ VPN.");
      }
    } on SocketException {
      setState(() => _response = "🛑 تم اكتشاف حجب DNS. الحل التلقائي:\n1. قم بتغيير الـ VPN الخاص بك.\n2. اضبط الـ Private DNS في هاتفك على 1.1.1.1");
    } catch (e) {
      setState(() => _response = "🔄 خطأ غير متوقع: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini Auto-Fix"), centerTitle: true),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(20), child: Text(_response, style: TextStyle(fontSize: 17))))),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: "اكتب رسالتك...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))))),
                SizedBox(width: 5),
                IconButton(icon: Icon(Icons.send_rounded, color: Colors.green, size: 30), onPressed: () => sendRequest(_controller.text))
              ],
            ),
          )
        ],
      ),
    );
  }
}
