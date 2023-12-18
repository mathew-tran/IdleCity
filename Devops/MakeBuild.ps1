param(
    $Branch = "main",
    $BuildVersion = "r0.0.1"
)

$ProjectPath =  "$PSScriptRoot/../project.godot"
$Godot = "C:\Users\mathe\Downloads\Godot_v4.2-stable_win64.exe\Godot_v4.2-stable_win64.exe"
Write-Host $ProjectPath

$BuildVersionScript = "$PSScriptRoot/../Scripts/AutoLoad/BuildVersion.gd"

$ExportFolder = "C:\IdleCityBuild/index.html"

function UpdateBuildHash {
    Write-Host "== Updating Build Hash =="
    ResetFile -filepath $BuildVersionScript
    $searchString = "XX_BUILD_HASH_XX"
    $hashValue = git log --pretty=format:'%h' -n 1
    (Get-Content $BuildVersionScript) | ForEach-Object {$_ -replace $searchString, $hashValue} | Set-Content $BuildVersionScript
    Get-Content $BuildVersionScript | Write-Host

}

function MakeBuildAndPackageToContent {
    Write-Host "===MAKE BUILD AND PACKAGE TO CONTENT==="

    Start-Process -Wait -FilePath $Godot -ArgumentList "$ProjectPath $type WindowsDesktop --quiet --no-window"

}

function ResetFile($filePath) 
{
    cd "$PSScriptRoot/.."
    git add $filePath
    git checkout HEAD -- $filePath
}

function main {
    UpdateBuildHash
    MakeBuildAndPackageToContent

    Write-Host "SEE: $ContentFolder"
    Start $ContentFolder

    ResetFile -filePath $BuildVersionScript

}
main

