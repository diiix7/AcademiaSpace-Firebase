import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:academiaspace/helper/enum.dart';
import 'package:academiaspace/state/bookmarkState.dart';
import 'package:academiaspace/ui/theme/theme.dart';
import 'package:academiaspace/widgets/customAppBar.dart';
import 'package:academiaspace/widgets/newWidget/emptyList.dart';
import 'package:provider/provider.dart';

class ChatGPT extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();

  static Route<T> getRoute<T>() {
    return MaterialPageRoute(
      builder: (_) {
        return Provider(
          create: (_) => BookmarkState(),
          child: ChangeNotifierProvider(
            create: (BuildContext context) => BookmarkState(),
            builder: (_, child) => ChatGPT(),
          ),
        );
      },
    );
  }
}

class _ChatPageState extends State<ChatGPT> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _messages = [];

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({'text': message, 'sender': 'user'});
    });

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci/completions'),
      //Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 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',
      },
      body: json.encode({
        'prompt': message,
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final completion = data['choices'][0]['text'];

      setState(() {
        _messages.add({'text': completion, 'sender': 'chatbot'});
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with GPT-3.5'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(
                    message['text']!,
                    textAlign: message['sender'] == 'user'
                        ? TextAlign.right
                        : TextAlign.left,
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
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _messageController.clear();
                      _sendMessage(message);
                    }
                  },
                  child: Text('Send to gpt'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
