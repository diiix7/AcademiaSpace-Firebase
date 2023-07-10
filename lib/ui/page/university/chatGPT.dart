import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:academiaspace/state/bookmarkState.dart';
import 'package:provider/provider.dart';

//import 'package:academiaspace/helper/enum.dart';
//import 'package:academiaspace/ui/theme/theme.dart';
//import 'package:academiaspace/widgets/customAppBar.dart';
//import 'package:academiaspace/widgets/newWidget/emptyList.dart';

class ChatGPT extends StatefulWidget {
  @override
  _ChatGPTState createState() => _ChatGPTState();

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

class _ChatGPTState extends State<ChatGPT> {
  late WebViewController _webViewController;
  final String initialUrl = 'https://chat.openai.com/auth/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT'),
      ),
      body: Container(
        child: WebView(
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
        ),
      ),
    );
  }
}
