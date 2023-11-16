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

  // Only for microsoft programs
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
      } catch (e) {
        print('Error: $e');
      }
    }

    void removeInitialString() {
      widget.listOfStrings.remove('Nothing done yet!');
    }

    return MaterialApp(
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
                      widget.listOfStrings.add('programs uninstalled');
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
                    widget.listOfStrings.add('cortana disabled');
                    removeInitialString();
                  });
                },
                child: const Text("Disable cortana"),
              ),
              Expanded(
                child: ActionList(listOfStrings: widget.listOfStrings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionList extends StatefulWidget {
  final List<String> listOfStrings;
  const ActionList({super.key, required this.listOfStrings});

  @override
  State<ActionList> createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listOfStrings.length,
      itemBuilder: (context, index) {
        final item = widget.listOfStrings[index];
        return ListTile(
          title: Text(
            item,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
