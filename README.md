# Oh My Psmux

A Windows-native psmux configuration porting the familiar defaults and workflow
of Oh My Tmux. The main config is [`.psmux.conf`](.psmux.conf), with
[`.psmux.conf.local`](.psmux.conf.local) for personal overrides.

## Requirements

- Windows 10 or Windows 11
- [psmux](https://github.com/psmux/psmux) installed and available in PowerShell

## Install

Clone the repository, then run the installer in PowerShell:

```powershell
git clone https://github.com/domrany64/.psmux.git
Set-Location .\.psmux
.\install.ps1
psmux
```

The installer backs up an existing `$HOME\.psmux.conf` with a timestamp before
installing the profile. It creates `$HOME\.psmux.conf.local` only if one does
not already exist, preserving your personal settings. Preview the operation
without changing files with `.\install.ps1 -WhatIf`. You can also try the
config without installing it:

```powershell
psmux -f .\.psmux.conf
```

The main profile sources `$HOME\.psmux.conf.local` after defaults, so local
settings can override them.

## Key Bindings

Both `C-b` and secondary prefix `C-a` are enabled. Press either prefix before
the following keys:

- `h`, `j`, `k`, `l`: move between panes
- `-` and `_`: split the current pane
- `H`, `J`, `K`, `L`: resize the current pane
- `+`: zoom or restore the current pane
- `C-h` and `C-l`: previous or next window
- `Tab`: return to the last window
- `m`: toggle mouse mode
- `r`: reload `$HOME\.psmux.conf`
- `e`: open `$HOME\.psmux.conf` in Notepad
- `Enter`: enter copy mode; `v` starts selection and `y` copies it
- `b`, `p`, `P`: list, paste, or choose a paste buffer

## Port Status

The profile keeps the core prefix, navigation, pane management, vi copy mode,
Windows clipboard integration, and a status theme inspired by the original.
It uses `xterm-256color`, the recommended terminal type for psmux on Windows.

Oh My Tmux's POSIX-shell initialization, TPM bootstrap, PathPicker integration,
and shell-generated battery, uptime, and host status helpers are not part of
this native profile. Use psmux's PowerShell plugins and plugin manager, [ppm],
for Windows equivalents.

[ppm]: https://github.com/psmux/psmux-plugins

## Attribution

Oh My Tmux was created by [Gregory Pakosz (@gpakosz)](https://github.com/gpakosz).
Oh My Psmux is an independent port of that configuration for psmux and is not
an official project or an endorsement by the original developer. The original
project is available at [gpakosz/.tmux](https://github.com/gpakosz/.tmux).
