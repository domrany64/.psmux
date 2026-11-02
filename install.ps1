[CmdletBinding(SupportsShouldProcess = $true)]
param()

$ErrorActionPreference = 'Stop'

$sourcePath = Join-Path -Path $PSScriptRoot -ChildPath 'psmux.conf'
$profilePath = Join-Path -Path $HOME -ChildPath '.psmux.conf'

if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
    throw "Required psmux profile was not found: $sourcePath"
}

if (Test-Path -LiteralPath $profilePath -PathType Container) {
    throw "A directory exists where the psmux profile should be: $profilePath"
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