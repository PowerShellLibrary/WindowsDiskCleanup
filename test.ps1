# $appsar = Get-Item C:\Users\Alan\AppData\Local\*\app-*\resources\app.asar

$appsar.Directory.Parent | Group-Object -Property @{Expression = { $_.Parent.Name } } | % {
    Write-Host "Processing $($_.Name)" -ForegroundColor Yellow
    if ($_.Count -ge 2) {
        Write-Host "Found redundancy" -ForegroundColor Green

        $last = $_.Group | Sort-Object -Property LastWriteTime | Select-Object -SkipLast 1 #|  `
        # Remove-Item -Recurse
        Write-Host $last.Name
    }
}


return
# Get-ChildItem C:\Users\Alan\AppData\Local | %{
#     write-host $_.Name -ForegroundColor Yellow
#     Get-ChildItem $_.FullName -Directory | Group-Object -Property @{Expression = { [regex]::Match($_.Name, "[A-Za-z.-]*").value } } | ? { $_.Count -ge 2 } | % {
#         write-host $_.Name -ForegroundColor Green
#         # $_.Group | `
#         #     Sort-Object -Property CreationTime | `
#         #     Select-Object -SkipLast 1 | `
#         #     Remove-Item -Recurse
#     }
# }




# $extensions = Get-Content -Path C:\Users\Alan\.vscode\extensions\extensions.json | ConvertFrom-Json
# $extensions.relativeLocation

# # return
# Get-ChildItem C:\Users\Alan\.vscode\extensions | Group-Object  -Property @{Expression = { [regex]::Match($_.Name, "[A-Za-z.-]*").value } } | ? { $_.Count -ge 2 } | % {
#     write-host $_.Name -ForegroundColor Green
#     $_.Group | `
#         Sort-Object -Property CreationTime | `
#         Select-Object -SkipLast 1 | ? { $extensions.relativeLocation.contains($_.name) -eq $false } | `
#         Remove-Item -Recurse
# }