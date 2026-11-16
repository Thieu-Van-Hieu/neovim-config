# Cấu hình Neovim cá nhân

Cấu hình Neovim của mình, xây dựng trên [LazyVim](https://github.com/LazyVim/LazyVim) và quản lý plugin bằng [lazy.nvim](https://github.com/folke/lazy.nvim).

Repo này chủ yếu để dùng cho máy của mình. Có thể tham khảo, nhưng không đảm bảo ổn định cho người khác.

## Cấu trúc chính

- `init.lua`: điểm vào, nạp `config.lazy`.
- `lua/config/`: options, keymaps, autocmds, và bootstrap lazy.nvim.
- `lua/plugins/specs/`: cấu hình từng plugin, chia theo nhóm (editor, langs, ui, completions, ...).
- `lua/keymaps/`, `lua/settings/`, `lua/autocmds/`: keymap, thiết lập và autocmd tự viết.
- `lua/utils/`: hàm tiện ích dùng chung.
- `my-plugins/`: plugin tự viết (`flutter.nvim`, `pio.nvim`).
- `lazyvim.json`, `lazy-lock.json`: danh sách extras và phiên bản plugin đã khóa.
- `keymap.txt`: ghi chú phím tắt.

## Yêu cầu

- Neovim bản mới (theo yêu cầu của LazyVim).
- `git`, `lazygit` (cài qua `mise`, xem `mise.toml`).

## Ghi chú

- Không lưu mật khẩu hay token trong repo. File `pass.txt` đã bị bỏ khỏi git.

## Chế độ server (`NVIM_LITE=1`)

Dùng khi clone config lên server không có màn hình (không có Go, Node 22, clipboard).

- Bật: thêm `export NVIM_LITE=1` vào `~/.bashrc`, rồi mở `nvim` như bình thường.
- Tắt copilot, claudecode, flutter, markdown-preview, pio, dadbod và mason không tự cài tool.
- Clipboard dùng OSC52 khi đang ở trong SSH (`SSH_TTY`). Terminal trên máy bạn cần hỗ trợ OSC52 (kitty, WezTerm, Alacritty, Ghostty, foot, Windows Terminal, iTerm2). Nếu dùng tmux, thêm `set -g set-clipboard on` vào `~/.tmux.conf`.
- Cấu hình chế độ này nằm ở `init.lua` và `lua/plugins/specs/server/lite.lua`.
- Lite dùng `lazyvim.lite.json` thay cho `lazyvim.json`. File này bỏ các extra `lang.*`, `linting.eslint` và `formatting.prettier`. Chỉ giữ lua và markdown. Khi thêm extra mới, nhớ sửa cả hai file.
