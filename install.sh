#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
for dependency in zsh python3; do
  command -v "$dependency" >/dev/null || { echo "Missing $dependency; see README.md" >&2; exit 1; }
done
for required in "$HOME/.oh-my-zsh/oh-my-zsh.sh" "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
  [[ -f "$required" ]] || { echo "Missing shell dependency; see README.md" >&2; exit 1; }
done
python3 - "$repo_dir" <<'PY'
import datetime,json,os,shutil,sys
from pathlib import Path
repo=Path(sys.argv[1]); home=Path.home()
config=Path(os.environ.get('XDG_CONFIG_HOME',str(home/'.config')))
vscode=config/'Code/User/settings.json'
# Parse before changing files; do not overwrite unsupported JSON-with-comments.
try:
    existing=json.loads(vscode.read_text()) if vscode.exists() else {}
except json.JSONDecodeError:
    raise SystemExit('VS Code settings use JSON comments/trailing commas. Merge vscode/settings.json manually before rerunning.')
if not isinstance(existing,dict):
    raise SystemExit('VS Code settings must contain a JSON object.')
updates=json.loads((repo/'vscode/settings.json').read_text())
profiles=dict(existing.get('terminal.integrated.profiles.linux',{}))
profiles.update(updates['terminal.integrated.profiles.linux'])
existing.update(updates)
existing['terminal.integrated.profiles.linux']=profiles
backup=home/'.local/state/dotfiles-backups'/datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f')
mappings=[
 ('zsh/.zshrc',home/'.zshrc'),
 ('zsh/.zprofile',home/'.zprofile'),
 ('zsh/themes/agnoster-catppuccin.zsh-theme',home/'.oh-my-zsh/custom/themes/agnoster-catppuccin.zsh-theme'),
 ('ghostty/config.ghostty',config/'ghostty/config.ghostty'),
]
for _,dst in mappings+[(None,vscode)]:
    if dst.exists() or dst.is_symlink():
        saved=backup/dst.relative_to(home) if dst.is_relative_to(home) else backup/'external-config'/dst.name
        saved.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(dst,saved)
# Unlink config symlinks so installing never overwrites their source repository.
for src,dst in mappings:
    dst.parent.mkdir(parents=True,exist_ok=True)
    if dst.is_symlink(): dst.unlink()
    shutil.copy2(repo/src,dst)
# Use the detected Zsh path on other Linux installations.
ghostty=config/'ghostty/config.ghostty'
ghostty.write_text(ghostty.read_text().replace('command = /usr/bin/zsh','command = '+shutil.which('zsh')))
existing['terminal.integrated.profiles.linux']['Zsh']['path']=shutil.which('zsh')
vscode.parent.mkdir(parents=True,exist_ok=True)
if vscode.is_symlink(): vscode.unlink()
vscode.write_text(json.dumps(existing,indent=4)+'\n')
print('Installed shell, Ghostty and VS Code settings.')
print('Backups:',backup)
PY
zsh -n "$HOME/.zshrc"
if command -v ghostty >/dev/null; then ghostty +validate-config; fi
if command -v code >/dev/null; then code --install-extension Catppuccin.catppuccin-vsc; fi
printf '%s\n' 'Reload Ghostty config and open a new terminal (or run exec zsh).'
