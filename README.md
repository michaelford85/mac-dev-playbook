<img src="https://raw.githubusercontent.com/geerlingguy/mac-dev-playbook/master/files/Mac-Dev-Playbook-Logo.png" width="250" height="156" alt="Mac Dev Playbook Logo" />

# Mac Development Ansible Playbook

[![CI][badge-gh-actions]][link-gh-actions]

This playbook installs and configures most of the software I use on my Mac for web and software development. Some things in macOS are slightly difficult to automate, so there are still a few manual installation steps—but they’re all documented here.

---

## Prerequisites

Before installing Ansible or running this playbook, make sure the following tools are installed and configured **in this order**.

### 1. Install Apple Command Line Tools

```bash
xcode-select --install
```

### 2. Install Homebrew

Homebrew is required for managing system packages and dependencies.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, ensure Homebrew is on your `PATH` (Apple Silicon Macs):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

### 3. Install pyenv

`pyenv` is used to manage Python versions cleanly and avoid coupling this project to a specific system Python version.

```bash
brew install pyenv
```

Add pyenv to your shell:

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
echo 'eval "$(pyenv init -)"' >> ~/.zprofile
source ~/.zprofile
```

### 4. Install the Latest Stable Python Version

Install the latest stable Python version available via pyenv:

```bash
pyenv install --list | grep -E "^[[:space:]]*[0-9]+\\.[0-9]+\\.[0-9]+$" | tail
```

Then install and activate it locally:

```bash
pyenv install <latest_version>
pyenv local <latest_version>
```

This creates a `.python-version` file in the repository and ensures a consistent Python runtime.

### 5. Create a Project Virtual Environment

Create and activate a virtual environment **inside the project directory** using the pyenv-managed Python version:

```bash
python -m venv .venv
source .venv/bin/activate
```

From this point on, all Python and Ansible commands should be run inside this virtual environment.

---

## Install Ansible

With the virtual environment activated, install Ansible in a way that is **independent of any hardcoded Python version**:

```bash
pip install --upgrade pip
pip install ansible-core
```

You can verify the installation with:

```bash
ansible --version
```

---

## Installation

1. Clone or download this repository to your local machine.
2. Activate the virtual environment:

   ```bash
   source .venv/bin/activate
   ```

3. Install required Ansible roles:

   ```bash
   ansible-galaxy install -r requirements.yml
   ```

4. Run the playbook:

   ```bash
   ansible-playbook main.yml --ask-become-pass
   ```

   Enter your macOS account password when prompted for the **BECOME** password.

> **Note**: If Homebrew-related tasks fail, you may need to accept Xcode’s license or resolve a Brew issue. Run:
>
> ```bash
> brew doctor
> ```

---

## Use with a Remote Mac

You can use this playbook to manage other Macs—local or remote (e.g., MacStadium). Ensure SSH access is enabled on the target Mac:

1. System Settings → General → Sharing
2. Enable **Remote Login**

Or via command line:

```bash
sudo systemsetup -setremotelogin on
```

Edit the `inventory` file and replace `127.0.0.1` with:

```text
<ip_or_hostname> ansible_user=<ssh_username>
```

If SSH keys are not used, add `--ask-pass` when running `ansible-playbook`.

---

## Running a Specific Set of Tagged Tasks

Run only selected portions of the playbook using tags:

```bash
ansible-playbook main.yml -K --tags "dotfiles,homebrew"
```

Available tags include: `dotfiles`, `homebrew`, `mas`, `extra-packages`, `osx`.

---

## Overriding Defaults

You can override any defaults from `default.config.yml` by creating a `config.yml` file. Example:

```yaml
homebrew_installed_packages:
  - cowsay
  - git
  - go

mas_installed_apps:
  - { id: 443987910, name: "1Password" }
  - { id: 498486288, name: "Quick Resizer" }
  - { id: 557168941, name: "Tweetbot" }
  - { id: 497799835, name: "Xcode" }
```

Dotfiles are installed by default. Disable with:

```yaml
configure_dotfiles: no
```

---

## Full / From-Scratch Setup Guide

A complete from-scratch macOS setup guide is available here:

[full-mac-setup-mford.md](full-mac-setup-mford.md)

---

## Testing the Playbook

Many people have asked me if I often wipe my entire workstation and start from scratch just to test changes to the playbook. Nope! This project is [continuously tested on GitHub Actions' macOS infrastructure](https://github.com/michaelford85/mac-dev-playbook/actions?query=workflow%3ACI).


You can also run macOS itself inside a VM, for at least some of the required testing (App Store apps and some proprietary software might not install properly). I currently recommend:

  - [UTM](https://mac.getutm.app)
  - [Tart](https://github.com/cirruslabs/tart)

## Learn Ansible

Check out [Master Ansible](https://teachmeansible.com/), which teaches you how to automate almost anything with Ansible.

This project is continuously tested on GitHub Actions macOS runners.
---

## Author

This project was originally created by [Jeff Geerling](https://www.jeffgeerling.com/) (originally inspired by [MWGriffin/ansible-playbooks](https://github.com/MWGriffin/ansible-playbooks)).

[badge-gh-actions]: https://github.com/michaelford85/mac-dev-playbook/actions/workflows/ci.yml/badge.svg?branch=master
[link-gh-actions]:  https://github.com/michaelford85/mac-dev-playbook/actions/workflows/ci.yml

