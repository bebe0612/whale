import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key, required this.onBarrierPressed})
      : super(key: key);
  final Function() onBarrierPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onBarrierPressed();
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 300,
            height: 200,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
