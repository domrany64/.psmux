[CmdletBinding(SupportsShouldProcess = $true)]
param()

$ErrorActionPreference = 'Stop'

$sourcePath = Join-Path -Path $PSScriptRoot -ChildPath '.psmux.conf'
$localSourcePath = Join-Path -Path $PSScriptRoot -ChildPath '.psmux.conf.local'
$profilePath = Join-Path -Path $HOME -ChildPath '.psmux.conf'
$localProfilePath = Join-Path -Path $HOME -ChildPath '.psmux.conf.local'

if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
    throw "Required psmux profile was not found: $sourcePath"
}

if (-not (Test-Path -LiteralPath $localSourcePath -PathType Leaf)) {
    throw "Required psmux local profile template was not found: $localSourcePath"
}

if (Test-Path -LiteralPath $profilePath -PathType Container) {
    throw "A directory exists where the psmux profile should be: $profilePath"
}

if (Test-Path -LiteralPath $localProfilePath -PathType Container) {
    throw "A directory exists where the psmux local profile should be: $localProfilePath"
}

if ($PSCmdlet.ShouldProcess($profilePath, 'Install psmux profile')) {
    $temporaryPath = Join-Path -Path $HOME -ChildPath ".psmux.conf.$([guid]::NewGuid().ToString('N')).tmp"
    $backupPath = $null

    try {
        Copy-Item -LiteralPath $sourcePath -Destination $temporaryPath

        if (Test-Path -LiteralPath $profilePath -PathType Leaf) {
            $timestamp = Get-Date -Format 'yyyyMMddHHmmss'
            $backupPath = Join-Path -Path $HOME -ChildPath ".psmux.conf.$timestamp.bak"
            if (Test-Path -LiteralPath $backupPath) {
                $backupPath = Join-Path -Path $HOME -ChildPath ".psmux.conf.$timestamp.$([guid]::NewGuid().ToString('N')).bak"
            }
            Copy-Item -LiteralPath $profilePath -Destination $backupPath
        }

        Move-Item -LiteralPath $temporaryPath -Destination $profilePath -Force
    }
    catch {
        if ($backupPath -and (Test-Path -LiteralPath $backupPath -PathType Leaf)) {
            Copy-Item -LiteralPath $backupPath -Destination $profilePath -Force
        }
        throw
    }
    finally {
        if (Test-Path -LiteralPath $temporaryPath) {
            Remove-Item -LiteralPath $temporaryPath -Force
        }
    }

    if ($backupPath) {
        Write-Host "Previous profile backed up to: $backupPath"
    }
    Write-Host "Installed psmux profile: $profilePath"
}

if (Test-Path -LiteralPath $localProfilePath -PathType Leaf) {
    Write-Host "Keeping existing psmux local profile: $localProfilePath"
}
elseif ($PSCmdlet.ShouldProcess($localProfilePath, 'Install psmux local profile template')) {
    $localTemporaryPath = Join-Path -Path $HOME -ChildPath ".psmux.conf.local.$([guid]::NewGuid().ToString('N')).tmp"
    try {
        Copy-Item -LiteralPath $localSourcePath -Destination $localTemporaryPath
        Move-Item -LiteralPath $localTemporaryPath -Destination $localProfilePath
    }
    finally {
        if (Test-Path -LiteralPath $localTemporaryPath) {
            Remove-Item -LiteralPath $localTemporaryPath -Force
        }
    }
    Write-Host "Installed psmux local profile template: $localProfilePath"
}