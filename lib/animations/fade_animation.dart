import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation({required this.delay, required this.child});
  final opacity = MovieTweenProperty<double>();
  final translateY = MovieTweenProperty<double>();
  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(opacity, 0.0.tweenTo(1.0), duration: 500.milliseconds)
      ..tween(translateY, (-30.0).tweenTo(0.0),
          duration: 500.milliseconds, curve: Curves.easeOut);

    return PlayAnimationBuilder<Movie>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: opacity.from(value),
        child: Transform.translate(
            offset: Offset(0, translateY.from(value)), child: child),
      ),
    );
  }
}
