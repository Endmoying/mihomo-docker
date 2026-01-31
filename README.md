# Mihomo Docker

基于 Docker 的 Mihomo（原 Clash Meta）代理工具容器化部署方案，简化 Mihomo 代理服务的部署和管理过程。

## 功能特性

- **自动配置管理**：从指定 URL 下载配置文件，定期自动更新
- **环境变量配置**：通过环境变量自定义配置参数，无需修改配置文件
- **地理数据支持**：内置并自动更新 geoip.dat、geosite.dat 等地理数据文件
- **TUN 模式支持**：可作为网关使用，支持自动路由和重定向
- **多平台支持**：支持 amd64 和 arm64 架构

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/yourusername/mihomo-docker.git
cd mihomo-docker
```

### 2. 配置环境变量

复制示例环境变量文件并填写配置：

```bash
cp clash.example.env clash.env
```

编辑 `clash.env` 文件，填写必要的配置参数：

```env
CONFIG_URL=https://example.com/config.yaml
UPDATE_INTERVAL=86400
TUN=true

IPV6=true
MIXED_PORT=7890
DNS_LISTEN=127.0.0.1:53
EXTERNAL_CONTROLLER=0.0.0.0:9090
SECRET=your_secret_key
ALLOW_LAN=true
LAN_ALLOWED_IPS=["10.0.0.0/8", "127.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16","fc00::/7"]
BIND_ADDRESS=*
```

### 3. 启动服务

使用 Docker Compose 启动服务：

```bash
docker-compose up -d
```

## 配置选项

### 核心配置

- **CONFIG_URL**：配置文件下载地址
- **UPDATE_INTERVAL**：配置更新间隔（秒），默认 24 小时
- **TUN**：是否启用 TUN 模式，默认 true

### 网络配置

- **IPV6**：是否启用 IPv6，默认 true
- **MIXED_PORT**：混合代理端口，默认 7890
- **DNS_LISTEN**：DNS 服务监听地址，默认 127.0.0.1:53
- **EXTERNAL_CONTROLLER**：外部控制器地址，默认 0.0.0.0:9090
- **SECRET**：外部控制器密钥
- **ALLOW_LAN**：是否允许 LAN 访问，默认 true
- **LAN_ALLOWED_IPS**：LAN 允许的 IP 范围
- **BIND_ADDRESS**：绑定地址，默认 *

## 部署方式

### Docker Compose（推荐）

使用提供的 `docker-compose.yml` 文件：

```yaml
version: "3"

services:
  clash:
    image: ghcr.io/darknightlab/clash-docker:main
    container_name: clash
    restart: always
    network_mode: host
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    env_file:
      - clash.env
    volumes:
      - ./config:/root/.config/clash
```

### 手动构建镜像

如果需要自定义镜像：

```bash
docker build -t mihomo-docker .
docker run --name clash \
  --restart always \
  --network host \
  --cap-add NET_ADMIN \
  --device /dev/net/tun \
  --env-file clash.env \
  -v ./config:/root/.config/clash \
  mihomo-docker
```

## 注意事项

1. **TUN 模式配置**：
   - 若启用 TUN 模式并作为网关使用，需要在主机上启用 IP 转发：
   ```bash
   sysctl -w net.ipv4.ip_forward=1
   sysctl -w net.ipv6.conf.all.forwarding=1
   ```

2. **配置文件格式**：
   - CONFIG_URL 指向的配置文件需要是合法的 YAML 格式

3. **首次启动**：
   - 首次启动时会自动下载配置文件和地理数据

4. **网络模式**：
   - 使用 host 网络模式以获得最佳性能和兼容性

## 目录结构

```
mihomo-docker/
├── .github/
│   └── workflows/
│       └── docker-publish.yml  # Docker 镜像自动构建配置
├── Dockerfile                 # 容器构建文件
├── clash.example.env          # 环境变量示例配置
├── docker-compose.yml         # Docker Compose 配置文件
├── entrypoint.sh              # 容器启动脚本
├── setenv.py                  # 配置更新脚本
└── README.md                  # 项目说明文档
```

## 工作原理

1. **容器启动**：执行 entrypoint.sh 脚本
2. **配置管理**：从 CONFIG_URL 下载配置文件，定期更新
3. **环境变量处理**：通过 setenv.py 脚本将环境变量应用到配置文件
4. **服务启动**：启动 Mihomo 服务，应用配置

## 常见问题

### 服务无法启动

- 检查 CONFIG_URL 是否可访问
- 检查配置文件格式是否正确
- 检查端口是否被占用

### TUN 模式不工作

- 确保主机已启用 IP 转发
- 确保容器有 NET_ADMIN 权限
- 确保 /dev/net/tun 设备已正确映射

### 配置文件不更新

- 检查 CONFIG_URL 是否正确
- 检查网络连接是否正常
- 检查 UPDATE_INTERVAL 设置是否合理

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 鸣谢

- [Mihomo](https://github.com/MetaCubeX/mihomo) - 核心代理工具
- [MetaCubeX/meta-rules-dat](https://github.com/MetaCubeX/meta-rules-dat) - 地理数据文件
- [GitHub Actions](https://github.com/features/actions) - 自动化构建

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目！