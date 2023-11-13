import 'dart:io';

Future<String?> findUninstaller(String programName) async {
  try {
    // Use the 'where' command to search for uninstallers in common directories
    ProcessResult result = await Process.run(
      'where',
      ['$programName-uninstall.exe'],
    );

    // Check if the command was successful and the output is not empty
    if (result.exitCode == 0 && result.stdout != null) {
      String uninstallerPath = result.stdout.toString().trim();
      return uninstallerPath;
    } else {
      // If 'where' command doesn't find the uninstaller, you may need to try other methods
      print('Uninstaller not found for $programName');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

void main() async {
  // Replace 'ProgramName' with the actual name of the program you're looking for
  String programName = 'ProgramName';

  String? uninstallerPath = await findUninstaller(programName);

  if (uninstallerPath != null) {
    print('Uninstaller found: $uninstallerPath');
  } else {
    print('Uninstaller not found for $programName');
  }
}
