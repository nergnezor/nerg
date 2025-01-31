import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rive/rive.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: MyRiveAnimation(),
    ));

class MyRiveAnimation extends StatefulWidget {
  MyRiveAnimation({super.key});

  @override
  State<MyRiveAnimation> createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  bool showText = false;

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      // ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          "https://open.spotify.com/embed/album/3486IwLwd8v9NoZiLzqA2f?utm_source=generator"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 352,
            width: 352,
            child: WebViewWidget(controller: _controller),
          ),
        ),
        if (showText)
          Align(
            alignment: Alignment.topCenter,
            // Set the child's width to a third of the screen width

            child: FractionallySizedBox(
              widthFactor: 0.2,
              heightFactor: 0.2,
              child: FutureBuilder(
                  future: rootBundle.loadString("README.md"),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Markdown(data: snapshot.data!);
                    }

                    return Container();
                  }),
            ),
          ),
        Center(
          child: RiveAnimation.asset(
            'nerg.riv',
            stateMachines: ['State Machine 1'],
            artboard: "alla",
            fit: BoxFit.cover,
            onInit: _onRiveInit,
          ),
        ),
      ]),
    );
  }

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1',
            onStateChange: (stateMachineName, stateName) => setState(() {
                  print(stateName);
                  if (stateName == 'ExitState') {
                    return;
                  }
                  if (stateName == 'fly') showText = !showText;
                }));
    artboard.addController(controller!);
  }
}
