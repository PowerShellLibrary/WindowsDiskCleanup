# Public Cmdlets

## Common

### `Get-DiskSpace`
- **Description**: Retrieves disk space information for a specified drive.
- **Parameters**:
  - `Name`: The drive letter (default is the home drive).
  - `SpaceType`: Type of space to retrieve (`Free`, `Total`, or `Used`).
  - `Unit`: Unit of measurement (`GB`, `MB`, or `KB`).
- **Example**:
    ```powershell
    Get-DiskSpace -SpaceType Free -Unit GB
    ```

### `Remove-OldItem`
- **Description**: Removes old files or directories based on their creation time.
- **Parameters**:
  - `Path`: Path to the file or directory.
  - `File`: File object to remove.
  - `Days`: Files older than this number of days will be removed.
  - `DryRun`: If specified, only simulates the removal.
- **Example**:
    ```powershell
    Remove-OldItem -Path "C:\Temp\example.txt" -Days 30
    ```
## Cleanup

### `Remove-ChromiumTempData`
- **Description**: Removes temporary data created by Chromium-based browsers.
- **Parameters**:
  - `Days`: Files older than this number of days will be removed.
  - `DryRun`:  If specified, only simulates the removal.
- **Example**:
    ```powershell
    Remove-ChromiumTempData -Days 30 -DryRun
    ```

### `Remove-CrashDump`
- **Description**: Deletes crash dump files from the `CrashDumps` folder.
- **Parameters**:
  - `Days`: Files older than this number of days will be removed.
  - `DryRun`: If specified, only simulates the removal.
- **Example**:
    ```powershell
    Remove-CrashDump -Days 7
    ```

### `Remove-DebugDiagLogs`
`
- **Description**: Removes logs generated by **DebugDiag** service.
- **Parameters**:
  - `Days`: Files older than this number of days will be removed.
  - `DryRun`: If specified, only simulates the removal.
- **Example**:
    ```powershell
    Remove-DebugDiagLogs -Days 14
    ```

### `Remove-IISLog`
`
- **Description**: Deletes **IIS** log files from the specified folder
- **Parameters**:
  - `Days`: Files older than this number of days will be removed.
  - `LogFilesFolder`: Path to the IIS log files folder (default is `%SystemDrive%\inetpub\logs\LogFiles`).
  - `DryRun`: If specified, only simulates the removal.
- **Example**:
    ```powershell
    Remove-IISLog -Days 7
    ```

### `Remove-TempASPNETFile`
- **Description**: Deletes temporary ASP.NET files from the specified folder.
- **Parameters**:
  - `Days`: Files older than this number of days will be removed.
  - `FolderPath`: Path to the temporary ASP.NET files folder (default is `%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\root`).
  - `DryRun`: If specified, only simulates the removal.
- **Example**:
    ```powershell
    Remove-TempASPNETFile -Days 60
    ```