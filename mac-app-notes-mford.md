# Mac Application Setup Notes

This document contains personal instructions and command references for using key applications installed via my Mac Ansible setup.

## 📚 Table of Contents

- [VS Code](#vs-code)
- [iMessage Exporter](#imessage-exporter)

---
## 📬 VS Code

[Visual Studio Code Website](https://code.visualstudio.com/)

Tips for configuring remote development and using GitHub Copilot effectively.

### 🔗 Remote Server Access (SSH)

Set up a dedicated SSH config file for remote hosts so you can easily connect in VS Code:

💡 Make sure the “Remote - SSH” extension is installed in VS Code.

From VS Code, open the Command Palette (Cmd+Shift+P) and run:

`Remote-SSH: Connect to Host...`

You should now see your servers in the `~/.ssh/remote-hosts/config` file as options.

### 🌟 GitHub Copilot Setup

1) Install the GitHub Copilot extension from the Extensions Marketplace.

2) Open any file and sign in when prompted with your GitHub credentials.

3) Enable inline suggestions if not already enabled:
  - Go to Settings → Copilot: Enable
  - Or use Command Palette: GitHub Copilot: 

💡 Requires a GitHub Copilot subscription or a free trial.

## 📬 iMessage Exporter

[imessage-exporter GitHub Repo](https://github.com/ReagentX/imessage-exporter)

Export your iMessage history into a browsable HTML archive with attachments.

### Exporting Messages with Attachments

To save all messages and attachments in a single HTML file with full conversation context:

```bash
imessage-exporter -f html -c full -o ~/imessage_export_$(date +%d%m%Y%H%M%S)_full