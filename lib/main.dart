import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: AnimationPage(),
    );
  }
}

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  late final AnimationController _boxController;
  late final AnimationController _textController;
  late final Animation<double> _boxAnimation;
  late final Animation<double> _textAnimation;
  bool _isBoxOpen = false;
  String _quote = "";

  @override
  void initState() {
    super.initState();
    _boxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _boxAnimation = Tween<double>(begin: 0, end: pi / 4).animate(_boxController);
    _textAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _boxController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toggleBox() {
    setState(() {
      _isBoxOpen = !_isBoxOpen;
      if (_isBoxOpen) {
        _generateQuote();
        _boxController.forward().then((_) => _textController.forward());
      } else {
        _textController.reverse().then((_) => _boxController.reverse());
      }
    });
  }

  void _generateQuote() {

    List<String> quotes = [

      "Learn Flutter",
      "Everything is widget",
      "Programmer will change the world",
      "Keep Struggle",
    ];
    _quote = quotes[Random().nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tap the box for see the quotes again again"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleBox,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _boxAnimation,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..rotateX(_boxAnimation.value),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.pink,
                      alignment: Alignment.center,
                      child: !_isBoxOpen
                          ? const Text(
                        'Click on me',
                        style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
                      )
                          : Container(),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: 100 - 100 * _textAnimation.value,
                    child: Opacity(
                      opacity: _textAnimation.value,
                      child: Text(
                        _quote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20,color: Colors.blueAccent,fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
