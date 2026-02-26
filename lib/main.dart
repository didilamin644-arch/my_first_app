import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: GeminiChat(),
    ));

class GeminiChat extends StatefulWidget {
  @override
  _GeminiChatState createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  final TextEditingController _controller = TextEditingController();
  String _response = "أنا الآن مجهز بنظام إصلاح الاتصال التلقائي. اسألني أي شيء...";
  final String apiKey = "AIzaSyBj8rXZUUyxtwHlgCa3VG7VHAzW6dVF3p8";

  Future<void> sendRequest(String text) async {
    if (text.trim().isEmpty) return;
    setState(() => _response = "🔍 جاري فحص الشبكة والاتصال بـ Gemini...");
    
    try {
      final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
      
      // إعداد مهلة زمنية للاتصال (Timeout) لضمان عدم تعليق التطبيق
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"contents": [{"parts": [{"text": text}]}]})
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _response = data['candidates'][0]['content']['parts'][0]['text']);
      } else {
        setState(() => _response = "⚠️ رد من الخادم ($ {response.statusCode}): تأكد من تشغيل الـ VPN بشكل صحيح.");
      }
    } on SocketException catch (e) {
      setState(() => _response = "🚫 خطأ DNS: هاتفك لا يستطيع رؤية خوادم جوجل. الحل: \n1. فعل الـ VPN.\n2. غير الـ DNS في إعدادات الهاتف إلى 1.1.1.1");
    } on HttpException {
      setState(() => _response = "❌ فشل الاتصال بالخادم. حاول تغيير سيرفر الـ VPN.");
    } catch (e) {
      setState(() => _response = "🔄 حدث خطأ غير متوقع: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini Auto-Fix Mode"), centerTitle: true),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(20), child: Text(_response, style: TextStyle(fontSize: 16))))),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: "اسأل هنا...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))))),
                SizedBox(width: 8),
                FloatingActionButton(onPressed: () => sendRequest(_controller.text), child: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
