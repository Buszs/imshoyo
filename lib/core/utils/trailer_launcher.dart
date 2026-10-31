import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openTrailer(BuildContext context, String? youtubeKey) async{
  final messenger = ScaffoldMessenger.of(context);

  if (youtubeKey == null) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Trailer tidak ada'))
    );
    return;
  }

  final opened = await launchUrl(
    Uri.parse('https://www.youtube.com/watch?v=$youtubeKey'),
    mode: LaunchMode.externalApplication
  );

  if(!opened) {
    messenger.showSnackBar(
      const SnackBar(content: Text('gagal membuka youtube'))
    );
  }
}
