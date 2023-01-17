import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LogoApp(),
    );
  }
}

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late Animation<double> animation;
  late Animation<double> animation2;

  @override
  void initState() {
    super.initState();
    // controller animated from zero to one linear.
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut, //easeInOut,
    );

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    animation.addListener(() {
      print(animation.value);
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyTransition(animation: animation, child: LogoWidget()),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogo();
  }
}

class MyTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final sizeTween = Tween<double>(begin: 0, end: 300);
  final opacityTween = Tween<double>(begin: 0.1, end: 1.0);

  MyTransition({
    required this.child,
    required this.animation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            // elastic animation pass 1.0 upper limit, so we need to clamp.
            opacity: opacityTween.evaluate(animation).clamp(0, 1),
            child: SizedBox(
              height: sizeTween.evaluate(animation),
              width: sizeTween.evaluate(animation),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}


/*class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo(Animation<double> animation, {super.key})
      : super(listenable: animation);

  @override
  Widget build(Object context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: SizedBox(
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}*/
