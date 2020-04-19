function Convert-BinaryToString {
   [CmdletBinding()] param (
      [string] $FilePath
   )
   try {
      $ByteArray = [System.IO.File]::ReadAllBytes($FilePath);
   }
   catch {
      throw "Failed to read file. Ensure that you have permission to the file, and that the file path is correct.";
   }
   if ($ByteArray) {
      $Base64String = [System.Convert]::ToBase64String($ByteArray);
   }
   else {
      throw '$ByteArray is $null.';
   }
   Write-Output -InputObject $Base64String 
}