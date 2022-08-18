import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatelessWidget {
  const WebviewPage({
    required this.title,
    required this.url,
    Key? key,
  }) : super(key: key);

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: url,
        ),
      ),
    );
  }
}

class WebviewPageArguemnts {
  WebviewPageArguemnts({required this.url, this.title = ''});
  final String url;
  final String title;
}
