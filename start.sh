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
