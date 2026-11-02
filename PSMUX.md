# Oh my psmux

This is an independent native-Windows psmux port inspired by Oh My Tmux. Its
configuration follows the same main/local structure: `.psmux.conf` contains the
defaults and `.psmux.conf.local` contains personal overrides.

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

To test the config without installing it, run `psmux -f .\.psmux.conf`.

Optional personal psmux commands go in `$HOME\.psmux.conf.local`; the main
profile sources that file if it exists. The installer copies the sample local
file only when you do not already have one.

## Included

- `C-b` and secondary `C-a` prefixes
- Oh My Tmux-style window and pane navigation, splitting, resizing, and zoom
- Vi copy mode and psmux's built-in Windows clipboard integration
- A status line and pane/window colors adapted from the upstream theme
- Windows-appropriate `xterm-256color`

The profile intentionally omits Oh My Tmux's POSIX-shell initialization,
TPM bootstrap, PathPicker integration, and shell-generated battery, uptime, and
host status helpers. For Windows plugin equivalents, use psmux's PowerShell
plugins and plugin manager, [ppm](https://github.com/psmux/psmux-plugins).
