import 'package:example/dialogs/custom_dialog.dart';
import 'package:example/views/second_view.dart';
import 'package:flutter/material.dart';
import 'package:whale/whale.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
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
                  Whale.goByWidget(this, SecondView());
                },
                child: const Text("Whale.Go(this, SecondView());")),
            ElevatedButton(
                onPressed: () {
                  Whale.showDialog(
                    targetView: this,
                    dialog: CustomDialog(
                      onBarrierPressed: () {
                        Whale.hideDialog(
                            dialogName: 'customDialog', targetView: this);
                      },
                    ),
                    dialogName: 'customDialog',
                  );
                },
                child: const Text("Whale.showDialog(this, CustomDialog());")),
            ElevatedButton(
                onPressed: () {
                  Whale.replaceByWidget(from: this, to: SecondView());
                },
                child: const Text("replace HomeView to SecondView")),
          ],
        ),
      ),
    );
  }
}
