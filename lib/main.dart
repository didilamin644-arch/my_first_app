import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(
  home: AIChat(), 
  theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
  debugShowCheckedModeBanner: false,
));

class AIChat extends StatefulWidget {
  @override
  _AIChatState createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final TextEditingController _controller = TextEditingController();
  String _response = "مرحباً بك! أنا مساعدك الذكي المطور. يمكنك الآن إرسال نصوص أو صور لأقوم بتحليلها لك فوراً.";
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final String apiKey = "AIzaSyB1po-OkPEhOWkxe9LrAvz24CH-LWYMheA"; 

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _response = "تم اختيار الصورة. اكتب سؤالك الآن واضغط إرسال.";
      });
    }
  }

  Future<void> askAI(String text) async {
    if (text.isEmpty && _image == null) return;
    setState(() => _response = "جاري التفكير والتحليل العميق...");
    
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
    
    try {
      List<Map<String, dynamic>> parts = [{"text": text.isEmpty ? "ماذا ترى في هذه الصورة؟" : text}];
      
      if (_image != null) {
        String base64Image = base64Encode(_image!.readAsBytesSync());
        parts.add({
          "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
        });
      }

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [{"parts": parts}]
          }));
      
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _response = data['candidates'][0]['content']['parts'][0]['text'];
          _image = null; // إعادة تعيين الصورة بعد الرد
        });
      } else {
        setState(() => _response = "تنبيه: ${data['error']['message']}");
      }
    } catch (e) {
      setState(() => _response = "حدث خطأ في الاتصال. تأكد من جودة الإنترنت.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini AI Pro"), centerTitle: true, elevation: 2),
      body: Column(children: [
        if (_image != null) 
          Container(height: 200, width: double.infinity, child: Image.file(_image!, fit: BoxFit.cover)),
        Expanded(child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(child: Text(_response, style: TextStyle(fontSize: 17), textDirection: TextDirection.rtl)),
        )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Row(children: [
            IconButton(icon: Icon(Icons.photo_library, color: Colors.deepPurple), onPressed: _pickImage),
            Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: "اسأل عن الصورة أو نص..."))),
            IconButton(icon: Icon(Icons.send, color: Colors.deepPurple), onPressed: () => askAI(_controller.text)),
          ]),
        )
      ]),
    );
  }
}

