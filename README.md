# dnfonclearlinux
Script to enable basic dnf functionality on Intel Clear Linux.

**Proof of concept. This _will_ probably break your swupd.** Run in a container or VM.

Tested on clear-19810.

### Background

In lieu of traditional single-package package management, Intel Clear Linux groups it's packages in task-related [bundles](https://clearlinux.org/documentation/clear-linux/reference/bundles/available-bundles). These are generally very useful. For example, installing the [shells bundle](https://github.com/clearlinux/clr-bundles/blob/master/bundles/shells) installs a couple of useful shells like bash, zsh, and fish.

### The Problem

But if you want to install third-party apps, Intel recommends [flatpak](https://clearlinux.org/documentation/clear-linux/tutorials/flatpak). Flatpak is helpful and a decent comprimise for apps like Spotify and Corebird which have complicated dependency requirements.

Overall I find the flatpak apps to be slow compared to normal Linux distro binaries and particularly slow compared to the optimized Intel Clear Linux binaries. LibreOffice in flatpak is just not responsive enough. Also not all third-party apps are available in flatpak, such as Enpass or Virtual Studio Code.

### Solution

Intel Clear Linux includes dnf in the [package-utils](https://github.com/clearlinux/clr-bundles/blob/master/bundles/package-utils) bundle that can be set up with repos, including a handy [Intel Clear Linux dnf-compatible repo](https://download.clearlinux.org/current/x86_64/os/). This allows *basic* dnf functionality (see Known Issues) and greater package granularity than the official Intel Clear Linux bundle approach.

### Why Should I Care?

This allows you to:

* Install specific packages in Intel Clear Linux, from Intel Clear Linux repo's containing optimized binaries, without having to install an entire bundle.
* Install third-party dnf repos and rpms and fulfill their dependencies with Intel Clear Linux optimized binaries, e.g. LibreOffice 6.

### Installation

```
git clone https://github.com/yewwayne/dnfonclearlinux.git
cd dnfonclearlinux
nano dnf.conf	# make edits as necessary
chmod u+x setup-dnf.sh
sudo ./setup-dnf.sh	# run script
```

### Known Working

* None so far

### Known Issues

* **This will probably break your swupd.**
* Uninstalling python3 breaks dnf, requiring a reinstall of Clear Linux. *You have been warned.*

### To Do

* Test additional third-party repositories.
* Test if possible to build from third-party source rpms with optimized settings and fulfill their dependencies with optimized Intel Clear Linux source.
* **Write a less-invasive RPM-based package manager for Clear Linux, more like Homebrew**

## Caution

Installing packages using dnf instead of swupd is not officially supported on Intel Clear Linux and can and will break your system, swupd, and cause data loss. It should only be used for very specific use-cases after thorough testing in a non-production machine. In general it's going to be safer to install an extra bundle than to resort to this.
