# Git clone with personal and work accounts

Use one Linux user with separate project folders. An SSH key selects the GitHub account used for authentication; Git's `user.name` and `user.email` select the author recorded on new commits.

## One-time setup on a new machine

These examples use `~/dev/personal/` and `~/dev/work/`. Replace the example names and emails with your own. On an already configured machine, skip to **Clone repositories**.

1. Create a different SSH key for each account, or reuse your existing keys. Choose unused filenames when generating new keys:

   ```bash
   ssh-keygen -t ed25519 -C 'PERSONAL_EMAIL' -f ~/.ssh/github_personal
   ssh-keygen -t ed25519 -C 'WORK_EMAIL' -f ~/.ssh/github_work
   ```

   Add each `.pub` file to the matching GitHub account in Settings → SSH and GPG keys. Private key files stay on your machine.

2. Set your personal commit identity as the default:

   ```bash
   git config --global user.name 'PERSONAL_NAME'
   git config --global user.email 'PERSONAL_EMAIL'
   mkdir -p ~/dev/personal ~/dev/work
   ```

3. Add this block to `~/.ssh/config`, adapting the key filename if necessary. If a `Host github.com` block already exists, update that block:

   ```sshconfig
   Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/github_personal
       IdentitiesOnly yes
   ```

4. Create a separate `~/.ssh/github-work.conf`:

   ```sshconfig
   Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/github_work
       IdentitiesOnly yes
   ```

   Add any additional work host aliases to this file with their matching keys.

5. Configure work identity and authentication for repositories inside the work folder:

   ```bash
   git config --file ~/.gitconfig-work user.name 'WORK_NAME'
   git config --file ~/.gitconfig-work user.email 'WORK_EMAIL'
   git config --file ~/.gitconfig-work core.sshCommand "ssh -F $HOME/.ssh/github-work.conf"
   git config --global 'includeIf.gitdir:~/dev/work/.path' ~/.gitconfig-work
   ```

   The trailing `/` in the `gitdir` condition includes repositories nested beneath the folder. To apply the same work settings to a copied laptop home:

   ```bash
   git config --global 'includeIf.gitdir:~/laptop-home/.path' ~/.gitconfig-work
   ```

## Clone repositories

Replace `OWNER` and `REPO` with the repository's owner or organization and name:

```bash
# Personal account
git clone git@github.com:OWNER/REPO.git "$HOME/dev/personal/REPO"

# Work account
git clone git@github.com:OWNER/REPO.git "$HOME/dev/work/REPO"
```

Use an SSH clone URL with this setup. Inside the cloned repository, ordinary `git fetch`, `git pull`, and `git push` use its configured SSH account. Authentication with a particular account still requires that account to have access to the repository.

To explicitly select the work account for an initial clone:

```bash
GIT_SSH_COMMAND="ssh -F $HOME/.ssh/github-work.conf" \
  git clone git@github.com:OWNER/REPO.git "$HOME/dev/work/REPO"
```

## Verify before committing

Run inside the repository:

```bash
git config --show-origin --get user.name
git config --show-origin --get user.email
git config --show-origin --get core.sshCommand
git remote -v
```

Check each GitHub account directly:

```bash
ssh -T git@github.com
ssh -T -F ~/.ssh/github-work.conf git@github.com
```

GitHub's successful authentication message names the account. Its SSH check exits with status 1 because GitHub does not provide shell access.

Repository-local Git settings override the folder defaults. If an old repository uses the wrong email or SSH command, inspect `git config --local --list` and correct those settings. A `GIT_SSH_COMMAND` environment variable also overrides `core.sshCommand`; unset it after a temporary account override. Moving a repository between folders changes applicable folder defaults, but does not rewrite earlier commits.

References: [GitHub multiple-account guidance](https://docs.github.com/en/account-and-profile/how-tos/account-management/managing-multiple-accounts?platform=linux) and [Git conditional includes and configuration](https://git-scm.com/docs/git-config).
