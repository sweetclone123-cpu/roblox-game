# roblox-game

Code Roblox bằng **Visual Studio Code**, đồng bộ vào Roblox Studio bằng **Rojo 7.7.1**, và làm việc nhóm qua GitHub hoặc Live Share.

## Cài trên máy Windows của mỗi thành viên

1. Cài [Git](https://git-scm.com/downloads/win), [VS Code](https://code.visualstudio.com/) và Roblox Studio.
2. Chủ repo thêm bạn bè tại GitHub **Settings → Collaborators → Add people**. Mỗi người dùng tài khoản riêng và chấp nhận lời mời.
3. Clone và mở thư mục:

   ```powershell
   git clone https://github.com/sweetclone123-cpu/roblox-game.git
   cd roblox-game
   code .
   ```

4. Cài các extension được đề xuất: **Rojo**, **Luau Language Server**, **Live Share**.
5. Chạy trong PowerShell tại thư mục repo:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\setup.ps1
   ```

   Lệnh tải Rojo đúng phiên bản vào `.tools`, cài plugin Rojo cho Studio và tạo sourcemap. `Bypass` chỉ áp dụng cho tiến trình này. Nếu chính sách của máy chặn script, dùng cách cài Rojo thủ công bên dưới.

6. Trong VS Code: **Terminal → Run Task → Rojo: Serve**.
7. Trong Studio: mở place muốn phát triển, **Plugins → Rojo → Connect**, địa chỉ `localhost`, cổng `34872`. Kiểm tra danh sách thay đổi rồi kết nối. Nếu plugin chưa xuất hiện, lưu công việc và mở lại Studio.
8. Bấm **Play**: Output sẽ có `[roblox-game] Server ready` và `[roblox-game] Client ready`.

Rojo đồng bộ file từ máy vào Studio. Với cấu hình này, sửa code trong `src`, không sửa cùng các script đó trực tiếp trong Studio. Map và model vẫn thiết kế trong Studio. File `build/dev.rbxlx` chỉ là place kiểm tra code, không chứa map hiện có.

## Cấu trúc

| File/thư mục | Vị trí trong Studio |
| --- | --- |
| `src/server/*.server.luau` | `ServerScriptService.RojoServer` — code server |
| `src/client/*.client.luau` | `StarterPlayer.StarterPlayerScripts.RojoClient` — code client |
| `src/shared/*.luau` | `ReplicatedStorage.RojoShared` — ModuleScript dùng chung |

Không để bí mật hoặc logic cần bảo vệ trong client/shared. Cấu hình chỉ quản lý ba thư mục Rojo trên; nội dung không được khai báo ở bên ngoài được giữ lại. Xóa file trong các thư mục do Rojo quản lý sẽ xóa script tương ứng khi đồng bộ.

## Cùng code ngay trên một máy chủ: Live Share

1. Người host mở repo trong VS Code, chạy Rojo rồi nối Studio của host.
2. Bấm **Live Share**, tự đăng nhập GitHub/Microsoft nếu được yêu cầu, rồi chia sẻ link phiên với bạn bè.
3. Bạn bè dùng **Live Share: Join Collaboration Session**. Các bạn sửa chung file; khi lưu, Rojo trên máy host đưa code vào Studio của host.
4. Host commit và push code để giữ lại thay đổi sau phiên. Link Live Share không tự cấp quyền chỉnh sửa game Roblox hoặc repo GitHub.

Chỉ một người chạy Rojo vào cùng một place Team Create tại một thời điểm để tránh ghi đè từ các bản code khác nhau. Nếu cùng xây map, chủ game cấp quyền Edit/Team Create riêng trên Roblox. Mỗi người cũng có thể mở bản place thử nghiệm riêng và chạy Rojo trên máy mình.

## Mỗi người làm một tính năng: GitHub

Trước khi làm:

```powershell
git switch main
git pull --ff-only origin main
git switch -c feature/ten-tinh-nang
```

Sau khi sửa code và test trong Studio:

```powershell
git add src
git commit -m "Them tinh nang"
git push -u origin feature/ten-tinh-nang
```

Mở Pull Request trên GitHub để nhóm xem và merge vào `main`. Sau khi merge, các thành viên pull lại. GitHub lưu lịch sử và chia sẻ thay đổi qua commit/push/pull; muốn gõ cùng lúc dùng Live Share.

## Lệnh hữu ích

```powershell
.\.tools\rojo.exe serve default.project.json
.\.tools\rojo.exe sourcemap default.project.json --output sourcemap.json
.\.tools\rojo.exe build default.project.json --output build/dev.rbxlx
```

Chạy lại task **Rojo: Sourcemap** sau khi thêm/đổi tên/xóa script để cập nhật gợi ý đường dẫn cho Luau Language Server.

Nếu muốn dùng trình quản lý công cụ thay cho `setup.ps1`, cài [Rokit](https://github.com/rojo-rbx/rokit), chạy `rokit install` rồi `rojo plugin install` và `rojo serve`. Repo ghim cùng phiên bản trong `rokit.toml`. Các task VS Code hiện dùng bản `.tools/rojo.exe`, nên khi dùng Rokit bạn chạy các lệnh `rojo` trực tiếp hoặc đổi command của task.

Tài liệu: [Rojo trong Roblox](https://create.roblox.com/docs/projects/external-tools), [định dạng cấu hình Rojo](https://rojo.space/docs/v7/project-format/), [Live Share](https://learn.microsoft.com/en-us/visualstudio/liveshare/use/share-project-join-session-visual-studio-code).
