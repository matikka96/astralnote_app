import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

enum UrlScheme {
  web(''),
  mail('mailto:');

  const UrlScheme(this.prefix);
  final String prefix;
}

Future<void> launchUrlInExternalBrowser(String url) async {
  final uri = Uri.parse(url);
  await _launch(uri: uri);
}

Future<void> sendEmailTo(String emailAddress, {String? subject}) async {
  final subjectString = subject != null ? '?subject=$subject' : '';
  final uri = Uri.parse('${UrlScheme.mail.prefix}$emailAddress$subjectString');
  await _launch(uri: uri);
}

Future<void> _launch({required Uri uri}) async {
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    log('Couldn\'t launch: $uri');
  }
}
