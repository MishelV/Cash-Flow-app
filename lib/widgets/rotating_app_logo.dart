import 'package:flutter/material.dart';

class RotatingAppLogo extends StatefulWidget {
  RotatingAppLogo({
    Key? key,
  }) : super(key: key);

  AnimationController? _controller;

  AnimationController presistentAnimator(TickerProvider vsync) {
    if (_controller != null) return _controller!;
    _controller = AnimationController(
      duration: const Duration(seconds: 600),
      vsync: vsync,
    );
    return _controller!;
  }

  void stopAnimation() {
    _controller?.stop();
  }

  void continueAnimation() {
    _controller?.reset();
    _controller?.forward();
  }

  @override
  State<RotatingAppLogo> createState() => _RotatingAppLogoState();
}

class _RotatingAppLogoState extends State<RotatingAppLogo>
    with SingleTickerProviderStateMixin {
  AnimationController? currentAnimator;

  AnimationController get animator {
    currentAnimator ??= widget.presistentAnimator(this);
    return currentAnimator!;
  }

  @override
  void didChangeDependencies() {
    animator.reset();
    animator.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget._controller!.isAnimating) {
          widget._controller!.stop();
        } else {
          widget._controller!.forward();
        }
      },
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 40.0).animate(widget._controller!),
        child: Image.asset(
          'assets/images/finance.png',
        ),
      ),
    );
  }
}
