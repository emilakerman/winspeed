import 'dart:io';

class DisableCortana {
  void main() async {
    // Define the PowerShell script
    var powershellScript = r'''
Write-Host "Disabling Cortana"
$Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
$Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
$Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
If (!(Test-Path $Cortana1)) {
    New-Item $Cortana1
}
Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0 
If (!(Test-Path $Cortana2)) {
    New-Item $Cortana2
}
Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1 
Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1 
If (!(Test-Path $Cortana3)) {
    New-Item $Cortana3
}
Set-ItemProperty $Cortana3 HarvestContacts -Value 0
''';

    // Run PowerShell script
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
      print('cortana disabled.');
    } else {
      print('Error executing PowerShell script:');
      print(processResult.stderr);
    }
  }
}
