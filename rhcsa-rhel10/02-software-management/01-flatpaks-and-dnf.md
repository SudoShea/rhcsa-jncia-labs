# Lab 02.1: DNF & Flatpak Software Management on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/02-software-management/01-flatpaks-and-dnf.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Configure and manage standard DNF software repositories and package groups.
2. Inspect RPM package metadata, dependencies, installed file lists, and DNF transaction history.
3. Configure Flatpak remotes (repositories) on RHEL 10.
4. Search, install, inspect, and manage Flatpak application lifecycles.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine (provisioned using `manage-lab-vms.yml`).
* Administrative access via `sudo` or the `root` account.
* Active internet connectivity on the lab VM (or access to local mirror repositories).

---

## 🛠️ Scenario

As a Red Hat System Administrator, you are tasked with standardising software distribution across workstations and servers. You must configure local DNF repository settings, install system diagnostic tools using package groups, inspect RPM database entries, and integrate Flatpak application packaging for desktop users without polluting the underlying host filesystem.

---

## 📝 Lab Tasks

### Task 1: DNF Repository Configuration & Package Groups
1. Inspect all active DNF repositories on the system.
2. Enable the `codeready-builder-for-rhel-10-x86_64-rpms` repository (or equivalent EPEL build dependency repo).
3. Search for the **Development Tools** package group and install it using DNF.
4. Inspect the DNF transaction history to identify the transaction ID for the group installation.

### Task 2: RPM Inspection & Queries
1. Query the RPM database to locate which package owns the binary `/usr/bin/htop` (or `/usr/bin/nmcli` if htop is not installed).
2. List all files installed on the filesystem by the `procps-ng` package.
3. Verify the integrity of all installed files belonging to the `openssh-server` package to detect potential configuration file modifications.

### Task 3: Flatpak Remote Management
1. Verify that the `flatpak` utility is installed on RHEL 10.
2. Add the official **Flathub** remote repository system-wide, ensuring it does not overwrite existing configurations if already present.
3. List all configured Flatpak remotes and confirm Flathub is enabled.

### Task 4: Flatpak Application Installation & Lifecycle
1. Search the Flatpak remotes for the text editor application `org.gnome.TextEditor` (or `org.gimp.GIMP`).
2. Install the application system-wide from the Flathub remote.
3. Display detailed metadata for the installed Flatpak application, including its runtime, architecture, and sandbox permissions.
4. Run the application via the CLI (or inspect its execution command).
5. Cleanly uninstall the Flatpak application and purge any orphaned runtime dependencies.

---

## 🔍 Verification & Self-Test

Run these validation commands to verify your implementation:

```bash
# 1. Confirm Flatpak remote is configured
flatpak remotes | grep -i flathub

# 2. Confirm package group installation history
sudo dnf history list | head -n 10

# 3. Verify RPM package ownership query
rpm -qf /usr/bin/nmcli
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: DNF & Repositories
```bash
# 1. List enabled repositories
sudo dnf repolist

# 2. Enable CodeReady Builder repository
sudo dnf config-manager --set-enabled codeready-builder-for-rhel-10-x86_64-rpms

# 3. Search and install Development Tools group
sudo dnf group list
sudo dnf group install "Development Tools" -y

# 4. Inspect DNF transaction history
sudo dnf history
```
Task 2 Solutions: RPM Database Queries
```bash
# 1. Find package ownership of a binary
rpm -qf /usr/bin/nmcli

# 2. List files installed by procps-ng
rpm -ql procps-ng

# 3. Verify files belonging to openssh-server
rpm -V openssh-server
```
Task 3 Solutions: Flatpak Remotes
```bash
# 1. Verify Flatpak binary
flatpak --version

# 2. Add Flathub remote system-wide
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 3. List active Flatpak remotes
flatpak remotes -d
```
Task 4 Solutions: Flatpak Application Lifecycle
```bash
# 1. Search for application
flatpak search org.gnome.TextEditor

# 2. Install application system-wide
sudo flatpak install flathub org.gnome.TextEditor -y

# 3. Inspect application metadata and permissions
flatpak info org.gnome.TextEditor

# 4. List installed Flatpaks
flatpak list

# 5. Uninstall application and prune unused runtimes
sudo flatpak uninstall org.gnome.TextEditor -y
sudo flatpak uninstall --unused -y
```
