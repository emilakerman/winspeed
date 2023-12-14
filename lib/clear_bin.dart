import 'dart:io';

class ClearBin {
  void main() async {
    var powershellScript = 'Clear-RecycleBin -Force';

    await runPowerShellScript(powershellScript);
  }

  Future<void> runPowerShellScript(String script) async {
    // Replace triple backticks with an empty string to make it a raw string
    script = script.replaceAll('```', '');

    var processResult = await Process.run(
      'powershell.exe',
      ['-ExecutionPolicy', 'Bypass', '-Command', script],
    );

    // Check if the PowerShell script ran successfully
    if (processResult.exitCode == 0) {
      print('bin cleared.');
    } else {
      print('Error executing PowerShell script:');
      print(processResult.stderr);
    }
  }
}
