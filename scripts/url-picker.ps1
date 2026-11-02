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
$urls = [System.Collections.Generic.List[string]]::new()
foreach ($match in [regex]::Matches($text, 'https?://[^\s<>"'']+')) {
    $url = $match.Value.TrimEnd([char[]]@('.', ',', ';', ')', ']', '}'))
    if ($url -and -not $urls.Contains($url)) {
        $urls.Add($url)
    }
}

if ($urls.Count -eq 0) {
    Write-Host 'No URLs found in pane history.'
    Read-Host 'Press Enter to close'
    exit 0
}

Write-Host 'Open URL (number, blank to cancel):' -ForegroundColor Cyan
for ($index = 0; $index -lt $urls.Count; $index++) {
    Write-Host ('[{0}] {1}' -f ($index + 1), $urls[$index])
}

$selection = Read-Host
$number = 0
if ([int]::TryParse($selection, [ref]$number) -and $number -ge 1 -and $number -le $urls.Count) {
    Start-Process -FilePath $urls[$number - 1]
}
