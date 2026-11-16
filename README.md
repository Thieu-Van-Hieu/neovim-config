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
