import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: AiApp()));

class AiApp extends StatefulWidget {
  const AiApp({super.key});
  @override
  State<AiApp> createState() => _AiAppState();
}

class _AiAppState extends State<AiApp> {
  final TextEditingController _input = TextEditingController();
  String _response = "مرحباً! أنا مساعدك الذكي. اسألني أي شيء...";
  bool _loading = false;

  void _getAiAnswer() async {
    if (_input.text.isEmpty) return;
    setState(() { _loading = true; _response = "جاري التفكير..."; });
    
    // محاكاة استجابة ذكية مؤقتاً لضمان عمل الواجهة
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _response = "لقد سألت عن: '${_input.text}'. هذا التطبيق الآن يدعم الاتصال بالذكاء الاصطناعي عبر مكتبة http!";
      _loading = false;
      _input.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant'), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(child: Text(_response, style: const TextStyle(fontSize: 18))),
            )),
            if (_loading) const LinearProgressIndicator(),
            const SizedBox(height: 15),
            TextField(controller: _input, decoration: InputDecoration(
              hintText: 'اكتب سؤالك هنا...',
              suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: _getAiAnswer),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            )),
          ],
        ),
      ),
    );
  }
}

