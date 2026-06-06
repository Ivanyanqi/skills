# 恢复说明

- Shell 备份会保存为 `~/.zshrc.codex-bak.<timestamp>` 和 `~/.p10k.zsh.codex-bak.<timestamp>`。
- Neovim 备份会保存为 `~/.config/nvim.codex-bak.<timestamp>`。
- 如果 shell 提示符效果不对，恢复最新的 `~/.zshrc` 和 `~/.p10k.zsh` 备份，然后重新打开一个终端窗口。
- 如果 `Neovim` 启动失败，先恢复最新的 `~/.config/nvim` 备份，再检查插件网络访问后重新运行安装脚本。
- 如果 `iTerm2` 的变化没有生效，先退出 `iTerm2`，重新打开后确认偏好文件存在，再重新运行 profile 配置脚本。
