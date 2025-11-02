# NixOS System Configurations

This repository contains my NixOS system configurations, derived from
[Mitchell Hashimoto's excellent nixos-config](https://github.com/mitchellh/nixos-config)
(MIT License, Copyright 2021 Mitchell Hashimoto).

This repository isn't meant to be a turnkey solution to copying my setup or learning Nix,
so I want to apologize to anyone trying to look for something "easy". I've
tried to use very simple Nix practices wherever possible, but if you wish
to copy from this, you'll have to learn the basics of Nix, NixOS, etc.

I don't claim to be an expert at Nix or NixOS, so there are certainly
improvements that could be made! Feel free to suggest them, but please don't
be offended if I don't integrate them, I value having my config work over
having it be optimal.

## What's Different From the Original?

This configuration builds upon Mitchell Hashimoto's work with the following customizations:

### Desktop Environment
- **GNOME Desktop** as the default environment (with specializations for Plasma)
- Removed Hyprland and i3 configurations
- GNOME optimized for VMware Fusion on macOS
- Full screen support with automatic display resolution adjustment

### Development Tools
- **Mise** for managing Ruby and Node.js versions (replacing asdf/fnm)
- **Rust** development with rust-analyzer, rustfmt, and format-on-save
- **Go** development with gopls and format-on-save
- **Ruby** development with solargraph and format-on-save
- **NvChad** Neovim configuration with Telescope, LSP, and DAP
- **UV** for Python package management

### System Configuration
- **Timezone**: Asia/Ho_Chi_Minh (Vietnam)
- **Eza** configured with icons, showing all/hidden files by default
- **OSC 52 clipboard** support for seamless copy/paste over SSH from macOS to VM
- **Automatic NixOS generations cleanup**: weekly garbage collection, store optimization
- **Boot menu limited to 10 generations** to keep boot screen clean

### Clipboard Workflow
SSH from macOS (Ghostty) → NixOS VM with OSC 52:
- Copy in VM automatically syncs to macOS clipboard
- Paste from macOS works seamlessly
- No timeout errors

## How I Work

I like to use macOS as the host OS and NixOS within a VM as my primary
development environment. I use the graphical applications on the host
(browser, calendars, mail app, iMessage, etc.) but I do almost everything
dev-related in the VM (editor, compilation, databases, etc.).

Inevitably I get asked **why?** I genuinely like the macOS application
ecosystem, and I'm pretty "locked in" to their various products such as
iMessage. I like the Apple hardware, and I particularly like that my hardware
always Just Works with excellent performance, battery life, and service.
However, I prefer the Linux environment for almost all my dev work. I find
that modern computers are plenty fast enough for the best of both worlds.

Here is what it ends up looking like (from the original):

![Screenshot](https://raw.githubusercontent.com/mitchellh/nixos-config/main/.github/images/screenshot.png)

Note that I usually full screen the VM so there isn't actually a window,
and I three-finger swipe or use other keyboard shortcuts to active that
window.

### Common Questions Related To This Workflow

**How does web application development work?** I use the VM's IP. Even
though it isn't strictly static, it never changes since I rarely run
other VMs. You just have to make sure software in the VM listens
on `0.0.0.0` so that it isn't only binding to loopback.

**Does copy/paste work?** Yes. This configuration uses OSC 52 to seamlessly
copy from the VM to macOS clipboard over SSH.
for details.

**Do you use shared folders?** I set up a shared folder so I can access
the home directory of my host OS user, but I very rarely use it. I primarily
only use it to access browser downloads. You can see this setup in these
Nix files.

**Do you ever launch graphical applications in the VM?** Yes, with GNOME
desktop. I use Firefox in the VM for OAuth flows, testing, and browsing.
The GNOME desktop environment works great in VMware Fusion.

**Do you have graphical performance issues?** For the types of graphical
applications I run (GUIs, browsers, etc.), not really. VMware (and other
hypervisors) support 3D acceleration on macOS and I get really smooth
rendering because of it.

**How do you full screen the VM?** Press `Control + Command + F` in VMware Fusion.
The VM automatically adjusts resolution thanks to VMware Tools.

**This can't actually work! This only works on a powerful workstation!**
I've been doing this (following Mitchell's approach) and it works great for me.
I use this VM on a MacBook Pro with VMware Fusion and have no issues whatsoever.

**Does this work with Apple Silicon Macs?** Yes, I use VMware Fusion
on Apple Silicon. Folder syncing, clipboards, and graphics acceleration all work.

## Setup (VM)

Video from original: <https://www.youtube.com/watch?v=ubDMLoWz76U>

**Note:** This setup guide covers VMware Fusion because that is the
hypervisor I use day to day. Others have reported getting similar configurations
working with Parallels or UTM.

You can download the NixOS ISO from the
[official NixOS download page](https://nixos.org/download.html#nixos-iso).
There are ISOs for both `x86_64` and `aarch64` at the time of writing this.

Create a VMware Fusion VM with the following settings:

* ISO: NixOS 25.05 or later.
* Disk: SATA 150 GB+
* CPU/Memory: I give at least half my cores and half my RAM, as much as you can.
* Graphics: Full acceleration, full resolution, maximum graphics RAM.
* Network: Shared with my Mac.
* Remove sound card, remove video camera, remove printer.
* Profile: Disable almost all keybindings
* Boot Mode: UEFI

Boot the VM, and using the graphical console, change the root password to "root":

```bash
$ sudo su
$ passwd
# change to root
```

At this point, verify `/dev/sda` exists. This is the expected block device
where the Makefile will install the OS. If you setup your VM to use SATA,
this should exist. If `/dev/nvme` or `/dev/vda` exists instead, you didn't
configure the disk properly. Note, these other block device types work fine,
but you'll have to modify the `bootstrap0` Makefile task to use the proper
block device paths.

Also at this point, I recommend making a snapshot in case anything goes wrong.
I usually call this snapshot "prebootstrap0". This is entirely optional,
but it'll make it super easy to go back and retry if things go wrong.

Run `ifconfig` and get the IP address of the first device. It is probably
`192.168.58.XXX`, but it can be anything. In a terminal with this repository
set this to the `NIXADDR` env var:

```bash
export NIXADDR=<VM ip address>
```

The Makefile assumes an Intel processor by default. If you are using an
ARM-based processor (M1, etc.), you must change `NIXNAME` so that the ARM-based
configuration is used:

```bash
export NIXNAME=vm-aarch64
```

**Other Hypervisors:** If you are using Parallels, use `vm-aarch64-prl`.
If you are using UTM, use `vm-aarch64-utm`. Note that the environments aren't
_exactly_ equivalent between hypervisors but they're very close and they
all work.

Perform the initial bootstrap. This will install NixOS on the VM disk image
but will not setup any other configurations yet. This prepares the VM for
any NixOS customization:

```bash
make vm/bootstrap0
```

After the VM reboots, run the full bootstrap, this will finalize the
NixOS customization using this configuration:

```bash
make vm/bootstrap
```

You should have a graphical functioning dev VM with GNOME desktop.

At this point, I never use Mac terminals ever again. I clone this repository
in my VM and I use the other Make tasks such as `make test`, `make switch`, etc.
to make changes my VM.

## Quick Start After Bootstrap

After your VM is set up, here's what you get out of the box:

### Desktop Environment
```bash
# Full screen the VM
Control + Command + F

# Or use Unity mode for seamless integration
Control + Command + U

# GNOME is running by default
# You can boot into Plasma specialization from boot menu
```

### Development Environment
```bash
# Rust development with format-on-save
nvim main.rs
# Save will auto-format with rustfmt

# Go development with format-on-save
nvim main.go
# Save will auto-format with gopls

# Ruby development with format-on-save
nvim app.rb
# Save will auto-format with solargraph

# Copy current file path
# In Neovim: <space> + c + p

# Manage Ruby versions with mise
mise use ruby@3.3.0

# Manage Node.js versions with mise
mise use node@20

# Python with uv
uv venv
source .venv/bin/activate
uv pip install <package>
```

### File Browsing
```bash
# Eza with icons (configured aliases)
ls      # Shows all files with icons
ll      # Long format with git status
la      # Long format with headers
lt      # Tree view (2 levels)
llt     # Long tree view with git status
```

### Clipboard Over SSH
```bash
# SSH from macOS (Ghostty)
ssh user@vm-ip

# Copy in Neovim (copies to macOS clipboard via OSC 52)
# Visual mode: y
# Normal mode: yy

# Paste from macOS
# Cmd+V in terminal, or 'p' in Neovim
```

### NixOS System Management
```bash
# Your system automatically cleans up old generations weekly
# Boot menu shows only last 10 generations

# List current generations
nixos-rebuild list-generations

# Manual cleanup (if needed)
sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage --delete-old
sudo nix-store --optimize

# Rollback if something breaks
sudo nixos-rebuild switch --rollback
```

## Configuration Structure

```
.
├── flake.nix                      # Main flake configuration
├── machines/
│   ├── vm-shared.nix              # Shared VM configuration (GNOME, timezone, auto-cleanup)
│   ├── vm-aarch64.nix             # ARM64 VM (Apple Silicon)
│   └── vm-intel.nix               # x86_64 VM
├── modules/
│   └── specialization/
│       ├── gnome-ibus.nix         # GNOME with IBus input
│       └── plasma.nix             # KDE Plasma specialization
├── users/
│   └── thoaivk/
│       ├── home-manager.nix       # User packages and config
│       └── nvim/                  # NvChad configuration
│           ├── lua/
│           │   ├── options.lua    # Neovim options (OSC 52)
│           │   ├── mappings.lua   # Keybindings
│           │   ├── configs/
│           │   │   └── lspconfig.lua  # LSP with format-on-save
│           │   └── plugins/
│           │       ├── init.lua   # Plugin list
│           │       └── configs/
│           │           └── telescope.lua  # Telescope config
│           └── init.lua           # Neovim entry point
└── Makefile                       # Build and deploy commands
```

## Key Features

### Automatic Garbage Collection

Configured in `machines/vm-shared.nix`:
- Runs weekly
- Deletes generations older than 30 days
- Optimizes Nix store (deduplicates files)
- Keeps boot menu clean (max 10 entries)

### Format-on-Save

Configured in `users/thoaivk/nvim/lua/configs/lspconfig.lua`:
- **Rust**: rustfmt via rust-analyzer
- **Go**: gofumpt via gopls
- **Ruby**: RuboCop via solargraph

### OSC 52 Clipboard

Configured in `users/thoaivk/nvim/lua/options.lua`:
- Copy in VM → macOS clipboard (via OSC 52)
- Paste from macOS → VM (via terminal paste)
- No timeout errors
- Works over SSH

### GNOME Desktop

Configured in `machines/vm-shared.nix`:
- Default desktop environment
- Full VMware Fusion integration
- Auto-resolution adjustment
- Full screen: `Control + Command + F`

## Updating the System

```bash
# In the VM, pull latest changes
cd ~/Project/nixos-config
git pull

# Test the configuration
make test

# Apply the configuration
make switch

# Or from macOS host
NIXADDR=<vm-ip> make vm/copy && make vm/switch
```

## Setup (macOS/Darwin)

**THIS IS OPTIONAL AND UNRELATED TO THE VM WORK.** I recommend you ignore
this unless you're interested in using Nix to manage your Mac too.

I share some of my Nix configurations with my Mac host and use Nix
to manage _some_ aspects of my macOS installation, too. This uses the
[nix-darwin](https://github.com/LnL7/nix-darwin) project. I don't manage
_everything_ with Nix, for example I don't manage apps, some of my system
settings, Homebrew, etc. I plan to migrate some of those in time.

To utilize the Mac setup, first install Nix using some Nix installer.
There are two great installers right now:
[nix-installer](https://github.com/DeterminateSystems/nix-installer)
by Determinate Systems and [Flox](https://floxdev.com/). The point of both
for my configs is just to get the `nix` CLI with flake support installed.

Once installed, clone this repo and run `make`. If there are any errors,
follow the error message (some folders may need permissions changed,
some files may need to be deleted). That's it.

**WARNING: Don't do this without reading the source.** This repository
is and always has been _my_ configurations. If you blindly run this,
your system may be changed in ways that you don't want. Read my source!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

This repository is derived from [Mitchell Hashimoto's nixos-config](https://github.com/mitchellh/nixos-config),
Copyright (c) 2021 Mitchell Hashimoto, also licensed under the MIT License.

## Acknowledgments

- **Mitchell Hashimoto** for the original excellent NixOS configuration and workflow
- **NixOS Community** for the amazing ecosystem
- **NvChad** for the Neovim configuration framework

## Troubleshooting

### Display Not Auto-Resizing on Full Screen
```bash
# In VM terminal
xrandr-auto
```

### Format-on-Save Not Working
```bash
# Check LSP status
:LspInfo

# Check if language server is running
:LspLog
```

### Boot Menu Has Too Many Entries
This should be handled automatically, but if needed:
```bash
# Keep only last 5 generations
sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage --delete-old
sudo nixos-rebuild switch
```

## Contributing

This is my personal configuration repository. While I'm happy to accept suggestions,
I may not integrate all changes as I prioritize having a working setup over
having an optimal one. Feel free to fork and adapt to your needs!
