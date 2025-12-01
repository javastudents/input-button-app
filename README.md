# 输入框 + 按钮示例

- 打开 `index.html` 即可看到一个输入框和一个可点击按钮。
- 点击按钮会弹出输入框中的内容；为空时会提示按钮已点击。

## 本地预览
- 方式一：直接双击打开 `index.html`
- 方式二：在此目录运行 `python3 -m http.server 8000` 后访问 `http://localhost:8000/`

## 结构
- `index.html` 页面文件

## 部署到 GitHub（含 Pages）
- 已在此目录初始化 Git 仓库并提交到 `main` 分支
- 在 GitHub 上创建一个空仓库，仓库名与本地文件夹同名：`input-button-app`
- 将本地仓库与远程关联并推送：
  - `git remote add origin https://github.com/javastudents/input-button-app.git`
  - `git push -u origin main`
- 在 GitHub 仓库设置中启用 Pages：
  - Source 选择 `Deploy from a branch`
  - Branch 选择 `main`，Folder 选择 `/ (root)`
  - 保存后，几分钟内可通过 `https://javastudents.github.io/input-button-app/` 访问

若你的账户启用了强制 HTTPS 或需要更改默认分支名称，可按需调整上述设置。

### 一键脚本（自动创建仓库并推送、尝试启用 Pages）
- 需要一个 GitHub Personal Access Token（建议权限：`repo` 与 `pages`）
- 设置环境变量并执行：
  - `export GITHUB_TOKEN=ghp_xxx`
  - `bash scripts/create_and_deploy.sh javastudents input-button-app`
- 脚本会：
  - 调用 GitHub API 创建公开仓库（如已存在则跳过）
  - 配置 `origin` 并推送 `main`
  - 尝试启用 `Pages` 为 `main / root`

### Pages 与 HTTPS 注意事项
- GitHub Pages 使用 HTTPS 提供页面；若嵌入的远端地址为 `http://<IP>:9000`，浏览器会因“混合内容”阻止加载
- 页面已在 HTTPS 环境下尝试使用 `https://<IP>:9000`，若远端未配置 HTTPS，仍无法显示
- 解决方式：
  - 为远端服务启用 HTTPS（自签证书或受信证书）
  - 通过反向代理将 `http://<IP>:9000` 升级为 HTTPS 并同源提供
  - 或在本地开发环境（HTTP）进行访问与调试
