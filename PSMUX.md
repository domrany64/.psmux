# Oh my psmux

This is an independent native-Windows psmux profile inspired by Oh my tmux! It
keeps the upstream `.tmux.conf` for tmux and WSL and provides `psmux.conf` for
psmux on Windows. It is not an official project by the Oh my tmux! author.

## Install

In PowerShell, from this repository's directory, test the profile without
changing your existing config:

```powershell
psmux -f .\psmux.conf
```

To install it as psmux's default config, back up any existing profile before
copying:

```powershell
if (Test-Path "$HOME\.psmux.conf") {
    $backup = "$HOME\.psmux.conf.$(Get-Date -Format yyyyMMddHHmmss).bak"
    Copy-Item "$HOME\.psmux.conf" $backup
}
Copy-Item .\psmux.conf "$HOME\.psmux.conf"
psmux
```

Optional personal tmux-style settings can go in
`$HOME\.psmux.conf.local`; the profile sources that file if it exists. The
upstream `.tmux.conf.local` is not read by psmux because it contains shell
variable assignments rather than tmux commands.

## Included

- `C-b` and secondary `C-a` prefixes
- Oh my tmux!-style window and pane navigation, splitting, resizing, and zoom
- Vi copy mode and psmux's built-in Windows clipboard integration
- A status line and pane/window colors adapted from the upstream theme
- Windows-appropriate `xterm-256color`

The profile intentionally omits Oh my tmux!'s POSIX-shell initialization,
TPM bootstrap, PathPicker integration, and shell-generated battery, uptime, and
host status helpers. For Windows plugin equivalents, use psmux's PowerShell
plugins and plugin manager, [ppm](https://github.com/psmux/psmux-plugins).
