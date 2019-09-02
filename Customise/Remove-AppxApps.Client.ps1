<#
        .SYNOPSIS
            Removes a specified list of AppX packages from the current system.
 
        .DESCRIPTION
            Removes a specified list of AppX packages from the current user account and the local system
            to prevent new installs of in-built apps when new users log onto the system. Return True or 
            False to flag whether the system requires a reboot as a result of removing the packages.

            If the script is run elevated, it will remove provisioned packages from the system. Otherwise only packages for the current user account will be removed.

        .PARAMETER Operation
            Specify the AppX removal operation - either Blacklist or Whitelist. 

        .PARAMETER Blacklist
            Specify an array of AppX packages to 'blacklist' or remove from the current Windows instance,
            all other apps will remain installed. The script will use the blacklist by default.
  
        .PARAMETER Whitelist
            Specify an array of AppX packages to 'whitelist' or keep in the current Windows instance.
            All apps except this list will be removed from the current Windows instance.

        .EXAMPLE
            PS C:\> .\Remove-AppxApps.ps1 -Operation Blacklist
            
            Remove the default list of Blacklisted AppX packages stored in the function.
 
        .EXAMPLE
            PS C:\> .\Remove-AppxApps.ps1 -Operation Whitelist
            
            Remove the default list of Whitelisted AppX packages stored in the function.

         .EXAMPLE
            PS C:\> .\Remove-AppxApps.ps1 -Operation Blacklist -Blacklist "Microsoft.3DBuilder_8wekyb3d8bbwe", "Microsoft.XboxApp_8wekyb3d8bbwe"
            
            Remove a specific set of AppX packages a specified in the -Blacklist argument.
 
         .EXAMPLE
            PS C:\> .\Remove-AppxApps.ps1 -Operation Whitelist -Whitelist "Microsoft.BingNews_8wekyb3d8bbwe", "Microsoft.BingWeather_8wekyb3d8bbwe"
            
            Remove AppX packages from the system except those specified in the -Whitelist argument.

        .NOTES
 	        NAME: Remove-AppxApps.ps1
	        VERSION: 3.0
	        AUTHOR: Aaron Parker
	        TWITTER: @stealthpuppy
 
        .LINK
            http://stealthpuppy.com
#>
[CmdletBinding(SupportsShouldProcess = $True, DefaultParameterSetName = "Blacklist")]
Param (
    [Parameter(Mandatory = $False, ParameterSetName = "Blacklist", HelpMessage = "Specify whether the operation is a blacklist or whitelist.")]
    [Parameter(Mandatory = $False, ParameterSetName = "Whitelist", HelpMessage = "Specify whether the operation is a blacklist or whitelist.")]
    [ValidateSet('Blacklist', 'Whitelist')]
    [System.String] $Operation = "Blacklist",

    [Parameter(Mandatory = $False, ParameterSetName = "Blacklist", HelpMessage = "Specify an AppX package or packages to remove.")]
    [System.String[]] $Blacklist = (
        "7EE7776C.LinkedInforWindows_w1wdnht996qgy", # LinkedIn
        "king.com.CandyCrushSodaSaga_kgqvnymyfvs32", # Candy Crush
        "king.com.FarmHeroesSaga_kgqvnymyfvs32", # Farm Heroes Saga
        "Microsoft.3DBuilder_8wekyb3d8bbwe", # 3D Builder
        "Microsoft.BingFinance_8wekyb3d8bbwe", # Bing Finance
        "Microsoft.BingNews_8wekyb3d8bbwe", # Microsoft News
        "Microsoft.BingSports_8wekyb3d8bbwe", # Bing Sports
        "Microsoft.BingWeather_8wekyb3d8bbwe", # Weather
        # "Microsoft.GetHelp_8wekyb3d8bbwe",                    # Get Help [remove for virtual desktops]
        # "Microsoft.Getstarted_8wekyb3d8bbwe",                 # Windows Tips
        "Microsoft.Messaging_8wekyb3d8bbwe", # Messaging
        # "Microsoft.Microsoft3DViewer_8wekyb3d8bbwe",          # 3D Viewer
        # "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",         # Office 365 hub
        "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe", # Solitaire
        # "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",       # Stick Notes
        # "Microsoft.MixedReality.Portal_8wekyb3d8bbwe",        # Mixed Reality Portal [remove for virtual desktops]
        # "Microsoft.MSPaint_8wekyb3d8bbwe",                    # Paint 3D
        "Microsoft.Office.Desktop_8wekyb3d8bbwe", # Office 365 desktop application. Remove if deploying Office 365 ProPlus
        "Microsoft.Office.Desktop.Access_8wekyb3d8bbwe", # Office 365 desktop application. Remove if deploying Office 365 ProPlus
        "Microsoft.Office.Desktop.Excel_8wekyb3d8bbwe", # Office 365 desktop application. Remove if deploying Office 365 ProPlus
        "Microsoft.Office.Desktop.Outlook_8wekyb3d8bbwe", # Office 365 desktop application. Remove if deploying Office 365 ProPlus
        "Microsoft.Office.Desktop.PowerPoint_8wekyb3d8bbwe", # Office 365 desktop application. Remove if deploying Office 365 ProPlus
        "Microsoft.Office.Desktop.Publisher_8wekyb3d8bbwe", # Office 365 desktop application. Remove if deploying Office 365 ProPlus
        "Microsoft.Office.Desktop.Word_8wekyb3d8bbwe", # Office 365 desktop application. Remove if deploying Office 365 ProPlus
        # "Microsoft.Office.OneNote_8wekyb3d8bbwe",             # Microsoft OneNote. Remove not using Office 365
        "Microsoft.OneConnect_8wekyb3d8bbwe", # Mobile Plans
        "Microsoft.People_8wekyb3d8bbwe", # People
        # "Microsoft.PPIProjection_cw5n1h2txyewy",              # Connect (Miracast) [remove for virtual desktops]
        # "Microsoft.Print3D_8wekyb3d8bbwe",                    # Print 3D
        # "Microsoft.ScreenSketch_8wekyb3d8bbwe",               # Snip & Sketch
        "Microsoft.SkypeApp_kzf8qxf38zg5c", # Skype
        # "Microsoft.Windows.Photos_8wekyb3d8bbwe",             # Photos
        # "Microsoft.WindowsAlarms_8wekyb3d8bbwe",              # Alarms
        # "Microsoft.WindowsCalculator_8wekyb3d8bbwe",          # Calculator
        # "Microsoft.WindowsCamera_8wekyb3d8bbwe",              # Camera
        "Microsoft.windowscommunicationsapps_8wekyb3d8bbwe", # Mail, Calendar [remove for virtual desktops]
        # "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",         # Feedback Hub [remove for virtual desktops]
        # "Microsoft.WindowsMaps_8wekyb3d8bbwe",                # Maps
        "Microsoft.WindowsPhone_8wekyb3d8bbwe", # Phone
        # "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe",       # Voice Recorder
        "Microsoft.XboxApp_8wekyb3d8bbwe", # Xbox Console Companion
        "Microsoft.XboxGameCallableUI_cw5n1h2txyewy", # Xbox UI
        "Microsoft.XboxGameOverlay_8wekyb3d8bbwe", # Xbox UI
        "Microsoft.XboxGamingOverlay_8wekyb3d8bbwe", # Xbox Game Bar
        # "Microsoft.YourPhone_8wekyb3d8bbwe",                  # Your Phone [remove for virtual desktops]
        "Microsoft.ZuneMusic_8wekyb3d8bbwe", # Zune Music
        "Microsoft.ZuneVideo_8wekyb3d8bbwe"                     # Zune Video
    ),

    [Parameter(Mandatory = $False, ParameterSetName = "Whitelist", HelpMessage = "Specify an AppX package or packages to keep, removing all others.")]
    [System.String[]] $Whitelist = (
        "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe",
        "Microsoft.GetHelp_8wekyb3d8bbwe",
        "Microsoft.Getstarted_8wekyb3d8bbwe",
        "Microsoft.HEIFImageExtension_8wekyb3d8bbwe",
        "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe", 
        "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
        "Microsoft.MSPaint_8wekyb3d8bbwe",
        "Microsoft.Office.OneNote_8wekyb3d8bbwe",
        "Microsoft.Print3D_8wekyb3d8bbwe",
        "Microsoft.ScreenSketch_8wekyb3d8bbwe",
        "Microsoft.StorePurchaseApp_8wekyb3d8bbwe",
        "Microsoft.VP9VideoExtensions_8wekyb3d8bbwe",
        "Microsoft.Wallet_8wekyb3d8bbwe",
        "Microsoft.WebMediaExtensions_8wekyb3d8bbwe",
        "Microsoft.WebpImageExtension_8wekyb3d8bbwe",
        "Microsoft.Windows.Photos_8wekyb3d8bbwe", 
        "Microsoft.WindowsAlarms_8wekyb3d8bbwe",
        "Microsoft.WindowsCalculator_8wekyb3d8bbwe",
        "Microsoft.WindowsCamera_8wekyb3d8bbwe",  
        "Microsoft.WindowsMaps_8wekyb3d8bbwe",
        "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe",
        "Microsoft.WindowsStore_8wekyb3d8bbwe",
        "Microsoft.YourPhone_8wekyb3d8bbwe"
    )
)

# A set of apps that we'll never try to remove
[System.String[]] $protectList = (
    "Microsoft.WindowsStore_8wekyb3d8bbwe",
    "Microsoft.MicrosoftEdge_8wekyb3d8bbwe",
    "Microsoft.Windows.Cortana_cw5n1h2txyewy",
    "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe",
    "Microsoft.StorePurchaseApp_8wekyb3d8bbwe",
    "Microsoft.Wallet_8wekyb3d8bbwe"
)

# Get elevated status. If elevated we'll remove packages from all users and provisioned packages
[System.Boolean] $Elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If ($Elevated) { Write-Verbose -Message "$($MyInvocation.MyCommand): Running with elevated privileges. Removing provisioned packages as well." }

Switch ($Operation) {
    "Blacklist" {
        # Filter list if it contains apps from the $protectList
        $packagesToRemove = Compare-Object -ReferenceObject $Blacklist -DifferenceObject $protectList -PassThru
    }
    "Whitelist" {
        Write-Warning -Message "$($MyInvocation.MyCommand): Whitelist action may break stuff."
        If ($Elevated) {
            # Get packages from the current system for all users
            Write-Verbose -Message "$($MyInvocation.MyCommand): Enumerating all users apps."
            $packagesAllUsers = Get-AppxPackage -AllUsers -PackageTypeFilter Main, Resource | `
                Where-Object { $_.NonRemovable -eq $False } | Select-Object -Property PackageFamilyName
        }
        Else {
            # Get packages for the current user
            Write-Verbose -Message "$($MyInvocation.MyCommand): Enumerating all users apps."
            $packagesAllUsers = Get-AppxPackage -PackageTypeFilter Main, Resource | `
                Where-Object { $_.NonRemovable -eq $False } | Select-Object -Property PackageFamilyName
        }
        # Select unique packages
        $uniquePackagesAllUsers = $packagesAllUsers.PackageFamilyName | Sort-Object -Unique

        # Filter out the whitelisted apps
        Write-Verbose -Message "$($MyInvocation.MyCommand): Filtering whitelisted apps."
        $packagesToRemove = Compare-Object -ReferenceObject $uniquePackagesAllUsers -DifferenceObject $Whitelist -PassThru
    }
}

# Remove the apps; Walk through each package in the array
ForEach ($app in $packagesToRemove) {
           
    # Get the AppX package object by passing the string to the left of the underscore
    # to Get-AppxPackage and passing the resulting package object to Remove-AppxPackage
    $Name = ($app -split "_")[0]
    Write-Verbose -Message "$($MyInvocation.MyCommand): Evaluating: [$Name]."
    If ($Elevated) {
        $package = Get-AppxPackage -Name $Name -AllUsers
    }
    Else {
        $package = Get-AppxPackage -Name $Name
    }
    If ($package) {
        If ($PSCmdlet.ShouldProcess($package.PackageFullName, "Remove User app")) {
            try {
                $package | Remove-AppxPackage -ErrorAction SilentlyContinue
            }
            catch [System.Exception] {
                Write-Warning -Message "$($MyInvocation.MyCommand): Failed to remove: [$($package.PackageFullName)]."
                Throw $_.Exception.Message
                Break
            }
            finally {
                $removedPackage = New-Object -TypeName System.Management.Automation.PSObject
                $removedPackage | Add-Member -Type "NoteProperty" -Name 'RemovedPackage' -Value $app
                Write-Output -InputObject $removedPackage
            }
        }
    }

    # Remove the provisioned package as well, completely from the system
    If ($Elevated) {
        $package = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq (($app -split "_")[0])
        If ($package) {
            If ($PSCmdlet.ShouldProcess($package.PackageName, "Remove Provisioned app")) {
                try {
                    $action = Remove-AppxProvisionedPackage -Online -PackageName $package.PackageName -ErrorAction SilentlyContinue
                }
                catch [System.Exception] {
                    Write-Warning -Message "$($MyInvocation.MyCommand): Failed to remove: [$($package.PackageName)]."
                    Throw $_.Exception.Message
                    Break
                }
                finally {
                    $removedPackage = New-Object -TypeName System.Management.Automation.PSObject
                    $removedPackage | Add-Member -Type "NoteProperty" -Name 'RemovedProvisionedPackage' -Value $app
                    Write-Output -InputObject $removedPackage
                    If ($action.RestartNeeded -eq $True) { Write-Warning -Message "$($MyInvocation.MyCommand): Reboot required: [$($package.PackageName)]" }
                }
            }
        }
    }
}
