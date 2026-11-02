# Oh my psmux

This is an independent native-Windows psmux profile inspired by Oh my tmux! It
keeps the upstream `.tmux.conf` for tmux and WSL and provides `psmux.conf` for
psmux on Windows. It is not an official project by the Oh my tmux! author.

## Install

In PowerShell, clone this repository and run the installer:

```powershell
git clone https://github.com/domrany64/.psmux.git
Set-Location .\.psmux
.\install.ps1
psmux
```

The installer backs up an existing `$HOME\.psmux.conf` with a timestamp before
installing the new profile. Preview its actions without changing files with:

```powershell
.\install.ps1 -WhatIf
```

To test the config without installing it, run `psmux -f .\psmux.conf`.

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
