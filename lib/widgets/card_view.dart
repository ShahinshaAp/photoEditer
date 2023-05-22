import 'package:flutter/material.dart';


class CardView extends StatelessWidget {
  final Widget child;
  final bool elevation;

  const CardView({
    super.key, required this.child, required this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color:  Color.fromRGBO(202, 209, 214, 1),
        ),
      ),
      shadowColor:const Color.fromRGBO(152, 160, 164, 0.25),
      child: Container(
          padding: const EdgeInsets.all(10),
          width:  MediaQuery.of(context).size.width,
          child: child),
    );
  }
}
