# dnfonclearlinux
Script to enable basic dnf functionality on Intel Clear Linux.

**Proof of concept. This _will_ probably break your swupd.** Run in a container or VM.

Tested on clear-27230.

### Background

In lieu of traditional single-package package management, Intel Clear Linux groups it's packages in task-related [bundles](https://clearlinux.org/documentation/clear-linux/reference/bundles/available-bundles).
For example, installing the [shells bundle](https://github.com/clearlinux/clr-bundles/blob/master/bundles/shells) installs a handful of shells like bash, zsh, and fish.

### The Problem

In most cases it is sufficient to install one tool that fulfills a given purpose (e.g. bash for shell),
rather than also installing the alternative or optional tools that bundles attempt to provide.

This is especially true for embedded applications where disk space is a limited resource.
Bundles often cause all-or-nothing situations where a desired utility is only available via a bundle that is too large.

### Solution

Intel Clear Linux includes dnf in the [package-utils](https://github.com/clearlinux/clr-bundles/blob/master/bundles/package-utils) bundle that can be set up with repos, including a handy [Intel Clear Linux dnf-compatible repo](https://download.clearlinux.org/current/x86_64/os/). This allows *basic* dnf functionality (see Known Issues) and greater package granularity than the official Intel Clear Linux bundle approach.

### Why Should I Care?

This allows you to:

* Install specific packages in Intel Clear Linux, from Intel Clear Linux repo's containing optimized binaries, without having to install an entire bundle.

### Installation

```
git clone https://github.com/yewwayne/dnfonclearlinux.git
cd dnfonclearlinux
nano dnf.conf	# make edits as necessary
chmod u+x setup-dnf.sh
sudo ./setup-dnf.sh	# run script
```

### Usage

dnf queries installed packages for one that specifies which `releasever` to use.
Clear Linux provides no such package, therefore all dnf invocations must include `--releasever=$(</usr/share/clear/version)`.

### Known Working

* Initial setup, installing some basic packages, and rebooting the system

### Known Issues

* **Swupd shows "Installed version: 1" after dnf install**: Swupd detects current version by reading VERSION_ID from `/usr/lib/os-release`. Most likely dnf installed "filesystem" package that replaces VERSION_ID with 1.  
  Fix: `sed -i 's/^\(VERSION_ID=\).*/\1'$(</usr/share/clear/version)/ /usr/lib/os-release`
* Removing a package also removes its unused dependencies, which could end up removing parts of swupd's installed bundles. This can be repaired with `swupd verify --fix --picky`.

### To Do

* See if swupd functionality can be recovered
* Test kernel installation and upgrades
* Test upgrading to newer Clear Linux versions
* Test additional third-party repositories.
* Test if possible to build from third-party source rpms with optimized settings and fulfill their dependencies with optimized Intel Clear Linux source.
* **Write a less-invasive RPM-based package manager for Clear Linux, more like Homebrew**

## Caution

Installing packages using dnf instead of swupd is not officially supported on Intel Clear Linux and can and will break your system, swupd, and cause data loss. It should only be used for very specific use-cases after thorough testing in a non-production machine. In general it's going to be safer to install an extra bundle than to resort to this.
