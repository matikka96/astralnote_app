import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/helpers/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebviewPageParams {
  WebviewPageParams({required this.title, required this.url});
  final String title, url;
}

class WebviewPage extends StatelessWidget {
  const WebviewPage({
    required this.params,
    Key? key,
  }) : super(key: key);

  final WebviewPageParams params;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(params.title),
        actions: [
          IconButton(
            onPressed: () => launchUrlInExternalBrowser(params.url),
            icon: const Icon(Icons.open_in_new),
          ),
        ],
      ),
      body: SafeArea(
        child: WebView(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          initialUrl: params.url,
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
