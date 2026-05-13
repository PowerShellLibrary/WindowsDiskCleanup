
gi  'C:\Windows\Temp\*'



return
gi -Path 'C:\Users\*\AppData\Local\Google\Chrome\User Data\*\Cache' | % {
    (Get-ChildItem -Recurse $_.FullName | Measure-Object -Property Length -Sum).Sum / 1MB
}

# $path = 'C:\Users\Alan\AppData\Local\Google\Chrome\User Data\System Profile'


return
# List all msp files in %windir%\Installer and convert to string
$strAllMsp = Get-ChildItem -Path C:\Windows\Installer\*.msp | Select-Object Name -ExpandProperty Name


Get-ChildItem -Path C:\Windows\Installer\*.msp | Measure-Object -Property size -Sum

# List all currently installed msp files and convert to string
$strInstalledMsps = Get-MSIPatchInfo | Select-Object LocalPackage -ExpandProperty LocalPackage

# Create a new array of all the installed msp files but run a regex query to strip the path from the string so the format is the same as the strAllMsp variable
$array = @()
foreach ($Msp in $strInstalledMsps) {
    $a = $Msp -creplace '(?s)^.*\\', ''
    $array += $a
}
# Remove any duplicate values from the array
$array = $array | Select-Object -uniq

$obinst = @()
foreach ($x in $strAllMsp) {
    if (!($array.Contains($x))) {
        $obinst += $x
    }
}

$obinst | ForEach-Object { Get-ChildItem -Path C:\Windows\Installer\$_ } -ov item