import 'dart:async';

import 'package:app_tutorial_heyteacher/app_tutorial_heyteacher.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Example App
class MyApp extends StatelessWidget {
  /// Creates the widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tutorial Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App Tutorial Demo'),
    );
  }
}

/// Example Home Page
class MyHomePage extends StatefulWidget {
  /// Creates the widget. create
  const MyHomePage({required String title, super.key}) : _title = title;

  final String _title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<TutorialItem> items = [];

  final GlobalKey<State<StatefulWidget>> _incrementKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> _avatarKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> _textKey = GlobalKey();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void initItems() {
    items.addAll({
      TutorialItem(
        globalKey: _incrementKey,
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: const Radius.circular(15),
        child: const TutorialItemContent(
          title: 'Increment button',
          content: 'This is the increment button',
        ),
      ),
      TutorialItem(
        globalKey: _textKey,
        shapeFocus: ShapeFocus.square,
        borderRadius: const Radius.circular(15),
        child: const TutorialItemContent(
          title: 'Counter text',
          content: 'This is the text that displays the status of the counter',
        ),
      ),
      TutorialItem(
        globalKey: _avatarKey,
        color: Colors.black.withValues(alpha: 0.6),
        shapeFocus: ShapeFocus.oval,
        child: const TutorialItemContent(
          title: 'Avatar',
          content: 'This is the avatar that displays something',
        ),
      ),
    });
  }

  @override
  void initState() {
    initItems();
    unawaited(
      Future<void>.delayed(const Duration(microseconds: 200)).then((_) {
        if (mounted) {
          unawaited(
            Tutorial.showTutorial(
              context,
              items,
              onTutorialComplete: () {
                // Code to be executed after the tutorial ends
                debugPrint('Tutorial is complete!');
              },
            ),
          );
        } else {
          debugPrint('Context is not mounted!, tutorial not shown.');
        }
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget._title),
        leading: Icon(
          Icons.add_circle_outline_rounded,
          key: _avatarKey,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              key: _textKey,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _incrementKey,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Tutorial Item Content
class TutorialItemContent extends StatelessWidget {
  /// Creates the widget.
  const TutorialItemContent({
    required String title,
    required String content,
    super.key,
  })  : _content = content,
        _title = title;

  final String _title;
  final String _content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            children: [
              Text(
                _title,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                _content,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Tutorial.skipAll(context),
                    child: const Text(
                      'Skip onboarding',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const TextButton(
                    onPressed: null,
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
