import 'package:flutter/widgets.dart';

class Gap extends StatelessWidget {
  final double size;

  const Gap(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(dimension: size);
  }
}
