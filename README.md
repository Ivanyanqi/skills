# My Skills

Personal Codex skills managed in a standalone Git repository so they can be reused across machines and shared with other clients.

## Included Skills

### `bootstrap-mac-terminal`

Recreates this Mac terminal setup:

- `iTerm2`
- `JetBrains Mono Nerd Font`
- `oh-my-zsh`
- `powerlevel10k`
- `eza` aliases
- lightweight Tokyo Night `Neovim`

Source:

- [bootstrap-mac-terminal/SKILL.md](/Users/ivanqi/Documents/aiworkspace/my-skills/bootstrap-mac-terminal/SKILL.md)

## Install A Skill Into Codex

Clone this repository somewhere local, then copy the skill folder into `~/.codex/skills`.

Example:

```bash
mkdir -p ~/.codex/skills
cp -R bootstrap-mac-terminal ~/.codex/skills/bootstrap-mac-terminal
```

Or, from the workspace version of this repository:

```bash
bash bootstrap-mac-terminal/scripts/install_or_sync_skill.sh
```

## Update Workflow

1. Edit or add a skill in this repository.
2. Commit and push to GitHub.
3. Sync the changed skill into `~/.codex/skills` on the target machine.

## Notes

- Skills in this repository are intended for Codex-compatible clients.
- Each skill is self-contained and should include its own `SKILL.md`, scripts, assets, and references where needed.
