# Full Mac Setup Process (for Michael Ford)

There are some things in life that just can't be automated... or aren't 100% worth the time :(

This document covers that, at least in terms of setting up a brand new Mac out of the box.

These instructions assume that the playbook and ansible are installed on a remote linux machine.

The default location for all necessary files in Dropbox is: 
- In the Dropbox GUI: `/Dropbox/My Documents/Macbook Ansible Restore`
- On the target Mac: `{{ dropbox_local_path }}/My Documents/Macbook Ansible Restore`
  - Where `{{ dropbox_local_path }}` is the path to the Dropbox folder on the target machine, that you should also specify in the `config.yml` file.

## Initial configuration of a brand new Mac

### Pre-automation Tasks
Before starting, I completed Apple's mandatory macOS setup wizard (creating a local user account, and optionally signing into my iCloud account). Once on the macOS desktop, I do the following (in order):

  - SSH setup.
    - Manually copy the private SSH key that are needed to log into the remote Ansible machine, from Dropbox (via Airdrop or Web GUI) at `/Dropbox/My Documents/SSH keys/Home Lab/fordlab.pem`.
  - Turn on [Remote Login](https://support.apple.com/guide/mac-help/allow-a-remote-computer-to-access-your-mac-mchlp1066/mac) and [Screen Sharing](https://support.apple.com/guide/mac-help/turn-screen-sharing-on-or-off-mh11848/mac) in Settings on Target Mac
  - Ensure that the approprpiate SSH Public key (at `/Dropbox/My Documents/SSH keys/Home Lab/fordlab.pub`) that allows remote access is populated in `~/.ssh/authorized_keys` on the target Mac.
  - Sign into:
    - iCloud
    - iMessage
    - Mac App Store
  - Ensure Apple's command line tools are installed (`xcode-select --install` to launch the installer)
  - Install homebrew:
    - `$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
  - Install the ansible collections and roles required:
    - `$ ansible-galaxy install -r <repository root>/requirements.yml`
  - Specify the privilege escalation password for your target machines. You have several options:
    - Make the playbook query you for the become password when running the main.yml file, with the argument `--ask-become-pass`
    - Specify the `ansible_become_password` variable in the `config.yml` file.
    - If you are running the playbook on multiple macs, and they have different passwords, you can set the inventory variable `ansible_become_pass`.
  - Make the following role tweaks:
    - **<repository root>/roles/geerlingguy.dotfiles/tasks/main.yml**:
      - For the task `Ensure dotfiles repository is cloned locally`, add `force: true` to the git module arguments.
        - ```
            
              - name: Ensure dotfiles repository is cloned locally.
                git:
                  repo: "{{ dotfiles_repo }}"
                  dest: "{{ dotfiles_repo_local_destination }}"
                  version: "{{ dotfiles_repo_version }}"
                  accept_hostkey: "{{ dotfiles_repo_accept_hostkey }}"
                  force: true
                become: false
          ```
    - **<repository root>/roles/ansible-role-dock/tasks/remove.yml**:
      - Comment out the task `Dockutil | Removing items`.
        - ```
              # - name: Dockutil | Removing items
              #   ansible.builtin.shell: "{{ lookup('template', './templates/remove.j2') | replace('\n', '') | trim }}"
              #   loop_control:
              #     label: "{{ item.item }}"
              #   changed_when: false
              #   when: dock_dockitems_to_remove is defined and (dock_dockitems_to_remove | length > 0)
              #   tags:
              #     - dock-remove
          ``` 
            

### Automated Installations

- Ensure that config.yml is in the cloned repository, sourced from Dropbox.
- Run the playbook remotely with `--tags homebrew, sudoers`.
  - `$ ansible-playbook main.yml  --tags "homebrew,sudoers"`
  - If there are errors, you may need to finish up other tasks like installing 'old-fashioned' apps first
- Install old-fashioned apps:
  - Install [Insta360 Link](https://www.insta360.com/download/insta360-link)
  - Install [Google Chat](https://chat.google.com/download/) from within Brave Browser
  - Install [VMWare Fusion Player](https://customerconnect.vmware.com/en/evalcenter?p=fusion-player-personal-13) (dmg file and licence are in DropBox)
- Set up Dropbox and sync the following folders:
  - `{{ dropbox_local_path }}/apps/`
  - `{{ dropbox_local_path }}/My Documents/Macbook Ansible Restore/`
- Run the playbook remotely with `--skip-tags homebrew, post`.
  - `$ ansible-playbook main.yml  --skip-tags "homebrew,post"`
  - NOTE: The Dock may not show updates after this; in order to show the changes, run the following command in the Mac Terminal:
    - `killall Dock`
    - This command will terminate the Dock process, and macOS will automatically restart it. Any changes applied to the Dock should be resolved after this command.


### Post Automation Manual Processes
- Finder Settings:
  - Use the Terminal to permanently set hidden files to show in Finder
    - `$ defaults write com.apple.Finder AppleShowAllFiles true`
    - `$ killall Finder`
  - Finder Favorites Sidebar
    - ![Finder Favorites](./images/finder_favorites.png) 
    - Remove Recent
    - Add:
      - ~/.ssh
      - ~/git-workspace
      - ~/chatgpt-workspace
      - ~/.kube
      - ~/Library/Caches
  - In Finder settings, check the box `Show all filename extensions` and set `New Finder windows show` to the home folder.
    - ![Finder Settings](./images/finder_settings.png)
- System Settings
  - Wi-Fi
    - Set Wireless SSID and DNS Server to Pihole
  - Privacy & Security
    - Privacy
      - Screen Recording
        - Give the following apps permissions
          - Amazon Chime
          - Brave Browser
          - FaceTime
          - Google Chrome
          - Microsoft Teams
          - WebEx
          - zoom.us
  - Desktop & Dock
    - Show recent applications in dock: `disabled`
    - Hot Corners
      - Upper Left: `Notification Center`
      - Lower Left: `Lock Screen`
      - Upper Right: `-`
      - Lower Right: `Put Display to Sleep` 
  - Touch ID & Password
    - Add Fingerprints for TouchID
    - Allow Apple Watch to Unlock Mac   
  - Internet Accounts
    - Set up Google Account and sync contacts and calendar with Mac
  - Trackpad
    - Tap to Click: `Enabled`
    - Tap with one finger
    - App Exposé: `Swipe Down with Four Fingers`
  - Sound:
    - Sound Effects:
      - Play user interface sound effects: `Disabled`
  - Open at Login:
    - Open at Login:
      - AlDente.app (if a laptop)
      - Dropbox.app
      - Rectangle.app
    - Allow in the Background:
      - 1Password.app
      - AlDente
      - Docker.app
      - Dropbox
      - ExpressVPN
      - Logi Options+
      - Microsoft Office Licensing
      - Spotify.app
      - Wireguard.app
      - zoom.us.app
  - Notifications
    - Home
      - Play Sound for notification: `disable`
- iMessage
  - Turn off sound for iMessage
- Google Chrome/Brave Browser:
  - Install Google Chrome/Brave Browser extensions (list in DropBox)
  - Import Google Chrome/Brave Browser bookmarks from Dropbox
  - Set Brave Browser to default
  - Set Brave Browser default search engine to Google
- Configure Wireguard
  - retrieve peer files from Shared Google Drive folder "Wireguard Clients"
- Sign into Slack workspaces (list in DropBox)
- Apps to Authenticate with License Keys (list in DropBox):
  - ExpressVPN
  - DaisyDisk
  - Al Dente
  - makemkv
- Change Optical Drive Settings:
  - ![Blu Ray and DVD Settings](./images/dvd_blu_ray.png)
- Wallpaper
  - Located in `{{ dropbox_local_path }}/My Documents/Desktop Backgrounds`
- Run the playbook remotely with `--tags post`.
  - `$ ansible-playbook main.yml  --tags "post` 

### Manual Application Configurations
- Instructions and images found in Dropbox at `{{ dropbox_local_path }}/My Documents/Macbook Ansible Restore/apps`
- Applications to configure:
  - Handbrake
  - MakeMKV
  - Windows App
  - Logi Options+
  - Slack
  - Chrome
  - Brave
  - Wireguard


### Macbook-specific manual configuration
- Instructions and images found in Dropbox at `{{ dropbox_local_path }}/My Documents/Macbook Ansible Restore/apps`
  - AlDente

### Other MacOS App Notes
- Found at this Markdown file: [Mac Application Setup Notes](./mac-app-notes-mford.md)

## When formatting old Mac
  - Follow Apple's guide (TODO)

## Todo list for post provision automation
- Apps to Configure 
  - Alcove


