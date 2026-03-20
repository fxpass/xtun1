#!/bin/bash  

export UUID=${UUID:-'fdeeda45-0a8e-4570-bcc6-d68c995f5830'} # 如开启哪吒v1,不同的平台需要改一下，否则会覆盖
export NEZHA_SERVER=${NEZHA_SERVER:-''}       # v1哪吒填写形式：nezha.xxx.com:8008,v0哪吒填写形式：nezha.xxx.com
export NEZHA_PORT=${NEZHA_PORT:-''}           # v1哪吒不要填写这个,v0哪吒agent端口为{443,8443,2053,2083,2087,2096}其中之一时自动开启tls
export NEZHA_KEY=${NEZHA_KEY:-''}             # 哪吒v0-agent密钥或v1的NZ_CLIENT_SECRET
export ARGO_DOMAIN=${ARGO_DOMAIN:-''}         # 固定隧道域名,留空即启用临时隧道
export ARGO_AUTH=${ARGO_AUTH:-''}             # 固定隧道token或json,留空即启用临时隧道,json获取:https://json.zone.id
export CFIP=${CFIP:-'saas.sin.fan'}           # argo节点优选域名或优选ip
export CFPORT=${CFPORT:-'443'}                # argo节点端口 
export NAME=${NAME:-''}                       # 节点名称  
export FILE_PATH=${FILE_PATH:-'.npm'}         # sub 路径  
export ARGO_PORT=${ARGO_PORT:-'8001'}         # argo端口 使用固定隧道token,cloudflare后台设置的端口需和这里对应
export S5_PORT=${S5_PORT:-''}                 # socks5端口,支持多端口玩具可填写，否则不动
export HY2_PORT=${HY2_PORT:-''}               # Hy2 端口，支持多端口玩具可填写，否则不动
export TUIC_PORT=${TUIC_PORT:-''}             # Tuic 端口，支持多端口玩具可填写，否则不动
export ANYTLS_PORT=${ANYTLS_PORT:-''}         # AnyTLS 端口,支持多端口玩具可填写，否则不动
export REALITY_PORT=${REALITY_PORT:-''}       # Reality 端口,支持多端口玩具可填写，否则不动 
export ANYREALITY_PORT=${ANYREALITY_PORT:-''} # AnyReality 端口,支持多端口玩具可填写，否则不动   
export CHAT_ID=${CHAT_ID:-''}                 # TG chat_id，可在https://t.me/laowang_serv00_bot 获取
export BOT_TOKEN=${BOT_TOKEN:-''}             # TG bot_token, 使用自己的bot需要填写,使用上方的bot不用填写,不会给别人发送
export UPLOAD_URL=${UPLOAD_URL:-''}  # 订阅自动上传地址,没有可不填,需要填部署Merge-sub项目后的首页地址,例如：https://merge.xxx.com
export DISABLE_ARGO=${DISABLE_ARGO:-'false'}  # 是否禁用argo, true为禁用,false为不禁用,默认开启

if [ -f ".env" ]; then
set -o allexport
source <(grep -v '^#' .env | sed 's/^export //' )
set +o allexport
fi

[ ! -d "${FILE_PATH}" ] && mkdir -p "${FILE_PATH}"

delete_old_nodes() {
[[ -z $UPLOAD_URL || ! -f "${FILE_PATH}/sub.txt" ]] && return
old_nodes=$(base64 -d "${FILE_PATH}/sub.txt" | grep -E '(vless|vmess|trojan|hysteria2|tuic)://')
[[ -z $old_nodes ]] && return

json_data='{"nodes": ['
for node in $old_nodes; do
json_data+="\"$node\","
done
json_data=${json_data%,}
json_data+=']}'

curl -X DELETE "$UPLOAD_URL/api/delete-nodes" \
-H "Content-Type: application/json" \
-d "$json_data" 
