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
- `F`: choose and open Windows paths found in pane history
- `U`: choose and open URLs found in pane history
- `r`: reload `$HOME\.psmux.conf`
- `e`: open `$HOME\.psmux.conf` in Notepad
- `Enter`: enter copy mode; `v` starts selection and `y` copies it
- `b`, `p`, `P`: list, paste, or choose a paste buffer

## Port Status

This is a behavior port, not a line-for-line translation. The original tmux
shell bootstrap is replaced with tmux-compatible psmux commands, PowerShell,
and native Windows plugins.

**Ported**

- Prefixes, pane/window navigation, splits, resizing, copy mode, and buffer keys
- Theme colors, status layout, bell/activity indicators, titles, and window flags
- Pane split path retention, local `user`/`host`, and Windows uptime display
- Native Windows clipboard
- `Prefix + F/U` path and URL pickers using popup windows
- Optional battery, CPU/memory, and network status through official psmux plugins

The profile uses `xterm-256color` and native 24-bit color, as recommended by
psmux on Windows. To enable the optional plugins, install PPM once, then press
`Prefix + I`:

```powershell
$pluginRepo = Join-Path $env:TEMP ("psmux-plugins-" + [guid]::NewGuid())
git clone --depth 1 https://github.com/psmux/psmux-plugins.git $pluginRepo
New-Item -ItemType Directory "$HOME\.psmux\plugins" -Force | Out-Null
Copy-Item "$pluginRepo\ppm" "$HOME\.psmux\plugins\ppm" -Recurse
Remove-Item $pluginRepo -Recurse -Force
```

The installer adds picker scripts under `$HOME\.psmux\plugins\oh-my-psmux` and
preserves existing copies.

**Remaining Differences**

- SSH/Mosh-aware username, hostname, and remote-pane reconstruction are absent;
  status shows local Windows identity. Pane-split bindings explicitly pass
  `#{pane_current_path}`; new-session/new-window bindings add no path override.
- POSIX load average has no Windows equivalent. CPU/memory plugins show different
  metrics. Uptime is one rendered segment, not upstream's `#{uptime_*}` variables.
- Upstream custom formats `#{circled_window_index}`, `#{circled_session_name}`,
  `#{root}`, `#{pretty_pane_current_path}`, and user-defined shell functions
  aren’t provided as matching variables. Pane paths are shortened with psmux's
  native truncation format instead.
- Battery plugins show their own percentage/status presentation; exact upstream
  battery bars, gradients, Powerline separators, and per-segment theme controls
  are not reproduced.
- `Prefix + +` uses psmux's pane zoom, not upstream's separate-window maximize.
  Path picker supports existing absolute Windows paths; URL picker opens URLs in
  the browser. Neither matches all PathPicker/Urlscan/Urlview features.
- `Prefix + e` opens Notepad; `VISUAL`/`EDITOR` selection and tmux syntax-aware
  editing are not ported.
- PPM uses manual `Prefix + I/U/M` install/update/clean actions. Oh My Tmux's
  automatic TPM updates on launch/reload and `#!important` mechanism are absent;
  local psmux commands load after defaults and can override them directly.
- Upstream `.tmux.conf.local` shell assignments and custom functions are not
  compatible. Translate customizations to psmux commands in
  `.psmux.conf.local`.

The main config and local overrides still allow native psmux `set`, `bind`, and
`unbind` customization. See `.psmux.conf.local` for examples.

[ppm]: https://github.com/psmux/psmux-plugins

## Attribution

Oh My Tmux was created by [Gregory Pakosz (@gpakosz)](https://github.com/gpakosz).
Oh My Psmux is an independent port of that configuration for psmux and is not
an official project or an endorsement by the original developer. The original
project is available at [gpakosz/.tmux](https://github.com/gpakosz/.tmux).
