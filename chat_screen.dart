import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];
  TextEditingController messageController = TextEditingController();
  String openAIKey = "sk-ioX6bXrT1qKCNKYo4pDAT3B|bk-FJW500qyaX2tDSFf36Nb05"; 

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
                return ListTile(
                  title: Text(messages[index]),
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
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(messageController.text);
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
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
        },
        body: '{"prompt": "$message", "max_tokens": 50}',
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.body;
        final gptResponse = jsonResponse.toString();
        setState(() {
          messages.add('User: $message');
          messages.add('ChatGPT: $gptResponse');
          messageController.clear();
        });
      } else {
        print('Failed to get GPT response: ${response.statusCode}');
        
      }
    } catch (e) {
      print('Error during API request: $e');
      
    }
  }
}
