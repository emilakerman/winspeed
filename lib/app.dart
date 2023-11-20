import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winspeed/common_widgets/action_list.dart';
import 'package:winspeed/disable_cortana.dart';
import 'package:winspeed/enums/window_size_enum.dart';
import 'package:winspeed/theme.dart';
import 'package:winspeed/uninstall_list.dart';
import 'package:winspeed/utils/resize_window.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  // List<String> listOfStrings = ['1'];

  @override
  ConsumerState<MyApp> createState() => _MyAppConsumerState();
}

class _MyAppConsumerState extends ConsumerState<MyApp> {
  @override
  void initState() {
    actionChangeWindowSize(
      windowSizeEnum: WindowSizeEnum.desktop,
      ref: ref,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DisableCortana disableCortana = DisableCortana();

    // THIS ONE WORKS as of 2023-11-13
    Future<void> uninstallProgramNotMSI2(List<String> uninstallList) async {
      try {
        for (var item in uninstallList) {
          await Process.run(
            item,
            ['/S'], // S = silent uninstall!!! works!!!
            runInShell: true,
          );
          print("$item uninstalled!!!");
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    void removeInitialString() {
      actionsList.remove('Nothing done yet!');
    }

    return MaterialApp(
      theme: AppTheme.themeData,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(112, 70, 68, 68),
        body: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "WINSPEED DEBLOATER",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  child: const Text("Uninstall Program"),
                  onPressed: () {
                    uninstallProgramNotMSI2(
                      uninstallList,
                    );
                    setState(() {
                      actionsList.add('programs uninstalled');
                      removeInitialString();
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  disableCortana.main();
                  setState(() {
                    actionsList.add('cortana disabled');
                    removeInitialString();
                  });
                },
                child: const Text("Disable cortana"),
              ),
              Expanded(
                child: ActionList(listOfStrings: actionsList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
