import 'dart:io';
import 'package:flutter/material.dart';
import 'package:winspeed/disable_cortana.dart';
import 'package:winspeed/uninstall_list.dart';

void main() {
  runApp(MyApp(
    listOfStrings: ['Nothing done yet!'],
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.listOfStrings});
  List<String> listOfStrings = ['1'];

  //Only for microsoft programs
  void uninstallProgram(String programName) {
    Process.run('msiexec', ['/uninstall', programName])
        .then((ProcessResult result) {
      print(programName);
      print('Exit code: ${result.exitCode}');
      print('stdout: ${result.stdout}');
      print('stderr: ${result.stderr}');
    });
  }

  Future<void> uninstallProgramNotMSI(String programPath) async {
    ProcessResult result =
        await Process.run('runas', ['/user:Administrator', programPath]);
    print('Exit code: ${result.exitCode}');
    print('stdout: ${result.stdout}');
    print('stderr: ${result.stderr}');
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    DisableCortana disableCortana = DisableCortana();
    // THIS ONE WORKS as of 2023-11-13 but not silent uninstall
    Future<void> uninstallProgramNotMSI2(List<String> uninstallList) async {
      try {
        for (var item in uninstallList) {
          ProcessResult result = await Process.run(
            item,
            ['/S'], // S = silent uninstall!!! works!!!
            runInShell: true,
          );
          print("$item uninstalled!!!");
        }

        // print('Exit code: ${result.exitCode}');
        // print('stdout: ${result.stdout}');
        // print('stderr: ${result.stderr}');
      } catch (e) {
        print('Error: $e');
      }
    }

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(112, 70, 68, 68),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                  child: const Text("Uninstall Program"),
                  onPressed: () {
                    uninstallProgramNotMSI2(
                      uninstallList,
                    );
                    setState(() {
                      widget.listOfStrings.add('programs uninstalled');
                    });
                  }),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                disableCortana.main();
                setState(() {
                  widget.listOfStrings.add('cortana disabled');
                });
              },
              child: const Text("Disable cortana"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.listOfStrings?.length,
                itemBuilder: (context, index) {
                  final item = widget.listOfStrings?[index];
                  return ListTile(
                    title: Text(
                      "$item",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
