import 'package:education_project/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

class TextToSpeechScreen extends StatefulWidget {
  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _textController = TextEditingController();
  final Dio _dio = Dio();
  final AudioPlayer _player = AudioPlayer();

  String _selectedVoice = 'female'; // Mặc định giọng nữ
  double _speakingRate = 1.0; // Tốc độ nói mặc định

  Future<void> _speakText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    try {
      final response = await _dio.get<List<int>>(
        '$BASE_URL/tts/synthesize/',
        queryParameters: {
          'text': text,
          'gender': _selectedVoice,
          'speaking_rate': _speakingRate,
        },
        options: Options(responseType: ResponseType.bytes),
      );

      Uint8List audioBytes = Uint8List.fromList(response.data!);
      await _player.play(BytesSource(audioBytes));
    } catch (e) {
      print("TTS error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chuyển văn bản thành giọng nói')),
      );
    }
  }
  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Luyện nghe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Nhập văn bản',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: 'Nhập nội dung muốn chuyển thành giọng nói...',
              ),
              maxLines: 5,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      'Chọn giọng:',
                      style: theme.textTheme.titleMedium?.copyWith(),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedVoice,
                        items: [
                          DropdownMenuItem(value: 'female', child: Text('Nữ')),
                          DropdownMenuItem(value: 'male', child: Text('Nam')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedVoice = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      'Tốc độ nói:',
                      style: theme.textTheme.titleMedium?.copyWith(),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<double>(
                        isExpanded: true,
                        value: _speakingRate,
                        items: [
                          DropdownMenuItem(value: 0.5, child: Text('0.5')),
                          DropdownMenuItem(value: 0.75, child: Text('0.75')),
                          DropdownMenuItem(value: 1.0, child: Text('1.0')),
                          DropdownMenuItem(value: 1.25, child: Text('1.25')),
                          DropdownMenuItem(value: 1.5, child: Text('1.5')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _speakingRate = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: _speakText,
              icon: Icon(Icons.volume_up, size: 26, color: Colors.white,),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Phát Giọng Nói',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
