#Requires -RunAsAdministrator
<#
    .SYNOPSIS
    Sets Disk Cleanup tool settings for each operatng system.
  
    .NOTES
    NAME: Set-CleanMgrSettings.ps1
    VERSION: 1.1
    AUTHOR: Aaron Parker
    LASTEDIT: April 25, 2016
 
    .LINK
    http://stealthpuppy.com
#>

#region Functions
Function Set-RegistryValue {
    <#
        .SYNOPSIS
            Creates a registry value in a target key. Creates the target key if it does not exist.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [System.String] $Key,

        [Parameter(Mandatory = $True)]
        [System.String] $Value,

        [Parameter(Mandatory = $True)]
        $Data,

        [Parameter(Mandatory = $False)]
        [ValidateSet('Binary', 'ExpandString', 'String', 'Dword', 'MultiString', 'QWord')]
        [System.String] $Type = "String"
    )

    try {
        If (Test-Path -Path $Key -ErrorAction SilentlyContinue) {
            Write-Verbose "Path exists: $Key"
        }
        Else {
            Write-Verbose -Message "Does not exist: $Key."

            $folders = $Key -split "\\"
            $parent = $folders[0]
            Write-Verbose -Message "Parent is: $parent."

            ForEach ($folder in ($folders | Where-Object { $_ -notlike "*:" })) {
                New-Item -Path $parent -Name $folder -ErrorAction SilentlyContinue | Out-Null
                $parent = "$parent\$folder"
                If (Test-Path -Path $parent -ErrorAction SilentlyContinue) {
                    Write-Verbose -Message "Created $parent."
                }
            }
            Test-Path -Path $Key -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Error "Failed to create key $Key."
        Break
    }
    finally {
        Write-Verbose -Message "Setting $Value in $Key."
        New-ItemProperty -Path $Key -Name $Value -Value $Data -PropertyType $Type -Force -ErrorAction SilentlyContinue | Out-Null
    }

    $val = Get-Item -Path $Key
    If ($val.Property -contains $Value) {
        Write-Verbose "Write value success: $Value"
        Write-Output $True
    }
    Else {
        Write-Verbose "Write value failed."
        Write-Output $False
    }
}
#endregion

# Set the path to the CleanMgr settings in the registry
$RegPath = "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"

# Windows 10
If ([Environment]::OSVersion.Version -ge (New-Object "Version" 10, 0)) {
    Set-RegistryValue -Key "$RegPath\Active Setup Temp Folders" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\BranchCache" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Downloaded Program Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Internet Cache Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Old ChkDsk Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Previous Installations" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Recycle Bin" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\RetailDemo Offline Content" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Service Pack Cleanup" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Setup Log Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\System error memory dump files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\System error minidump files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Temporary Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Temporary Setup Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Thumbnail Cache" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Update Cleanup" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Upgrade Discarded Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\User file versions" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Windows Defender" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Windows Error Reporting Archive Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Windows Error Reporting Queue Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Windows Error Reporting System Archive Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Windows Error Reporting System Queue Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Windows Error Reporting Temp Files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Windows ESD installation files" -Value "StateFlags0100" -Data 2
    Set-RegistryValue -Key "$RegPath\Windows Upgrade Log Files" -Value "StateFlags0100" -Data 2
}

# Run CleanMgr
# Start-Process -FilePath $env:SystemRoot\system32\Cleanmgr.exe -ArgumentList "/sagerun:100" -Wait
