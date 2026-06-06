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

Clone this repository somewhere local, then run the repository installer.

Example:

```bash
chmod +x install-skill.sh
./install-skill.sh
```

Install a specific skill only:

```bash
./install-skill.sh bootstrap-mac-terminal
```

## Update Workflow

1. Edit or add a skill in this repository.
2. Commit and push to GitHub.
3. Run `./install-skill.sh` on the target machine to sync into `~/.codex/skills`.

## Notes

- Skills in this repository are intended for Codex-compatible clients.
- Each skill is self-contained and should include its own `SKILL.md`, scripts, assets, and references where needed.
