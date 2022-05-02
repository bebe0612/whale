import 'package:example/views/third_view.dart';
import 'package:flutter/material.dart';
import 'package:whale/whale.dart';

class SecondView extends StatelessWidget {
  const SecondView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Second',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Whale.goByWidget(this, ThirdView());
                },
                child: const Text("Whale.Go(this, ThirdView())")),
          ],
        ),
      ),
    );
  }
}
