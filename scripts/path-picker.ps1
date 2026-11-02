[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$PaneId
)

$ErrorActionPreference = 'Stop'
$psmux = (Get-Command psmux -ErrorAction Stop).Source
$captured = & $psmux capture-pane -p -J -S - -E - -t $PaneId 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host 'Could not read pane contents.'
    Read-Host 'Press Enter to close'
    exit 1
}

$text = $captured -join "`n"
$pattern = '(?i)"(?<quoted>[a-z]:[\\/][^"]+)"|(?<bare>[a-z]:[\\/][^\s<>"|?*]+)'
$paths = [System.Collections.Generic.List[string]]::new()
foreach ($match in [regex]::Matches($text, $pattern)) {
    $candidate = if ($match.Groups['quoted'].Success) {
        $match.Groups['quoted'].Value
    } else {
        $match.Groups['bare'].Value
    }
    $candidate = $candidate.TrimEnd([char[]]@('.', ',', ';', ')', ']', '}'))
    if (Test-Path -LiteralPath $candidate) {
        $resolved = (Resolve-Path -LiteralPath $candidate).Path
        if (-not $paths.Contains($resolved)) {
            $paths.Add($resolved)
        }
    }
}

if ($paths.Count -eq 0) {
    Write-Host 'No existing Windows paths found in pane history.'
    Read-Host 'Press Enter to close'
    exit 0
}

Write-Host 'Open path (number, blank to cancel):' -ForegroundColor Cyan
for ($index = 0; $index -lt $paths.Count; $index++) {
    Write-Host ('[{0}] {1}' -f ($index + 1), $paths[$index])
}

$selection = Read-Host
$number = 0
if ([int]::TryParse($selection, [ref]$number) -and $number -ge 1 -and $number -le $paths.Count) {
    Start-Process -FilePath $paths[$number - 1]
}
