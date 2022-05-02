import 'package:example/dialogs/custom_dialog.dart';
import 'package:example/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:whale/whale.dart';

class ThirdView extends StatelessWidget {
  const ThirdView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Third',
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
                  Whale.backByContext(context);
                },
                child: const Text("back to this view")),
            ElevatedButton(
                onPressed: () {
                  Whale.showDialog(
                      targetView: HomeView(),
                      dialog: CustomDialog(onBarrierPressed: () {
                        Whale.hideDialog(dialogName: 'dialog-from-third');
                      }),
                      dialogName: 'dialog-from-third');
                },
                child: const Text("show dialog to HomeView()")),
          ],
        ),
      ),
    );
  }
}
