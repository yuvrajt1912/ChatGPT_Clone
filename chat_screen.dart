import 'dart:convert'; // Import for JSON parsing
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For environment variables

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, String>> messages = [];
  TextEditingController messageController = TextEditingController();
  String openAIKey = dotenv.env['OPENAI_API_KEY'] ?? ''; // Load API key from .env file

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT Clone'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'User';
                return ListTile(
                  leading: isUser ? null : Icon(Icons.chat, color: Colors.blue),
                  trailing: isUser ? Icon(Icons.person, color: Colors.green) : null,
                  title: Text(
                    message['text'] ?? '',
                    style: TextStyle(
                      color: isUser ? Colors.green : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      _sendMessage(messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      messages.add({'sender': 'User', 'text': message});
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/engines/text-davinci-003/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
        },
        body: jsonEncode({
          'prompt': message,
          'max_tokens': 100,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final gptResponse = jsonResponse['choices'][0]['text']?.trim() ?? 'No response';

        setState(() {
          messages.add({'sender': 'ChatGPT', 'text': gptResponse});
        });
      } else {
        _showError('Failed to get response from OpenAI: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error during API request: $e');
    } finally {
      messageController.clear();
    }
  }

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}
