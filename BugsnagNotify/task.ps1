using module .\support.psm1
using module .\bugsnag.psm1

Trace-VstsEnteringInvocation $MyInvocation

$versionSource = Get-VstsInput -Name AppVersionSource -Require

$jsonFile = Get-VstsInput -Name JsonFile
$propertyPath = Get-VstsInput -Name PropertyPath
$appVersionValue = Get-VstsInput -Name AppVersionValue

# Notification Settings

$bugsnagUrl = Get-VstsInput -Name BugsnagUrl
$bugsnagApiKey = Get-VstsInput -Name BugsnagApiKey
$bugsnagBuilderName = Get-VstsInput -Name BugsnagBuilderName
$bugsnagReleaseStage = Get-VstsInput -Name BugsnagReleaseStage
$bugsnagAutoAssignRelease = Get-VstsInput -Name BugsnagAutoAssignRelease -AsBool
$bugsnagSourceControl = Get-VstsInput -Name BugsnagSourceControl -AsBool
$bugsnagSCProvider = Get-VstsInput -Name BugsnagSCProvider
$bugsnagSCRepo = Get-VstsInput -Name BugsnagSCRepo
$bugsnagSCRevision = Get-VstsInput -Name BugsnagSCRevision


# ###########################################################################
# ###########################################################################

if ($versionSource -eq "jsonfile") {
    Write-Output "App Version Source     : Json File"
    Write-Output "Json File              : $($jsonFile)"
    Write-Output "Bugsnag Property       : $($propertyPath)"
}
else {
    Write-Output "App Version Source     : Value"
    Write-Output "App Version Value      : $($appVersionValue)"
}

Write-Host "=============================================================================="

Write-Output "Notify Url             : $($bugsnagUrl)"
Write-Output "Api Key                : $(if (![System.String]::IsNullOrWhiteSpace($bugsnagApiKey)) { '***'; } else { '<not present>'; })"
Write-Output "Builder Name           : $($bugsnagBuilderName)"
Write-Output "Release Stage          : $($bugsnagReleaseStage)"
$autoAssign = BoolToYesNo $bugsnagAutoAssignRelease
Write-Output "Auto Assign Release    : $($autoAssign)"
$sourceControl = BoolToYesNo $bugsnagSourceControl
Write-Output "Source Control         : $($sourceControl)"
if ($bugsnagSourceControl) {
    Write-Output "- Provider             : $($bugsnagSCProvider)"
    Write-Output "- Repo                 : $($bugsnagSCRepo)"
    Write-Output "- Revision             : $($bugsnagSCRevision)"
}

Write-Host "=============================================================================="


# ###########################################################################
# ###########################################################################

# ---------------------------------------------------------------- Setup Notify Args

$bugsnagArgs = ParseBugsnagArgs $bugsnagUrl $bugsnagApiKey $bugsnagBuilderName $bugsnagReleaseStage $bugsnagAutoAssignRelease $bugsnagSourceControl $bugsnagSCProvider $bugsnagSCRepo $bugsnagSCRevision

if ($versionSource -eq "jsonfile") {

    # ---------------------------------------------------------------- Check Json File

    if (!([System.IO.File]::Exists($jsonFile))) {
        Write-Error "Your json file cannot be found at the specified location: $($jsonFile)"
        exit 0
    }

    if ($null -eq $propertyPath -or $propertyPath.length -lt 1) {
        Write-Error "Please specify a property path."
        exit 0
    }

    # ---------------------------------------------------------------- Parse File Version

    $jsonInput = Get-Content $jsonFile | Out-String | ConvertFrom-Json

    $appVersion = Invoke-Expression "`$jsonInput.$propertyPath" 

    if ($null -eq $appVersion) {
        Write-Warning "The current value at path '$($propertyPath)' is null. This indicates the property may not exist. Using 0.0.0.";
        $appVersion = "0.0.0"
    }
    else {
        Write-Host "Current value at '$propertyPath': $appVersion";
    }

}
else {
    $appVersion = $appVersionValue
}

Write-Host "Using App Version: $appVersion"

$bugsnagArgs.AppVersion = $appVersion

# ---------------------------------------------------------------- Notify Bugsnag

Write-Host "============================================================================== Notify Bugsnag"

Write-Output "Builder Name           : $($bugsnagBuilderName)"
Write-Output "Release Stage          : $($bugsnagReleaseStage)"
Write-Output "App Version            : $($appVersion)"

Write-Host "Attempting to notifying Bugsnag of release at: $bugsnagUrl"
  
$result = NotifyBugsnag $bugsnagUrl $bugsnagArgs

if ($result -eq $false) { exit 0 }