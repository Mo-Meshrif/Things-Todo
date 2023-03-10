import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomCoachMark extends StatefulWidget {
  final Widget? child;
  final String text;
  final String skip;
  final String next;
  final String? finish;
  final void Function()? onSkip;
  final void Function()? onNext;
  final bool hasDivider;

  const CustomCoachMark({
    Key? key,
    this.child,
    this.text = '',
    this.skip = "Skip",
    this.next = "Next",
    this.onSkip,
    this.onNext,
    this.hasDivider = false,
    this.finish,
  }) : super(key: key);

  @override
  State<CustomCoachMark> createState() => _CustomCoachMarkState();
}

class _CustomCoachMarkState extends State<CustomCoachMark>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 20,
      duration: const Duration(milliseconds: 800),
    )..repeat(min: 0, max: 20, reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animationController.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child == null
                ? Text(
                    widget.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : widget.child!,
            widget.hasDivider
                ? const Divider(height: 1)
                : const SizedBox(height: 16),
            widget.finish == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.onSkip,
                        child: Text(widget.skip).tr(),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: widget.onNext,
                        child: Text(
                          widget.next,
                        ).tr(),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: widget.onNext,
                    child: Text(
                      widget.finish!,
                    ).tr(),
                  ),
          ],
        ),
      ),
    );
  }
}
