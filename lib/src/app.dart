import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'news_change_notifier.dart';
import 'news_page.dart';
import 'news_service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_)=> NewsChangeNotifier(NewsService()),
        child: const NewsPage(),

      )
    );
  }
}
