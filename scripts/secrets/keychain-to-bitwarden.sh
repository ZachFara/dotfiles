#!/bin/zsh
# Copies the shell secrets from the macOS Keychain into Bitwarden, one login item per secret,
# inside a folder called "env". Values are read straight from the Keychain and never printed.
#
# Run it yourself, in your own terminal, after unlocking Bitwarden:
#   bw login                      # first time only
#   export BW_SESSION="$(bw unlock --raw)"
#   zsh ~/Ark/dotfiles/scripts/secrets/keychain-to-bitwarden.sh
set -eu
LIST="$HOME/.config/zsh/keychain-items.txt"
[ -n "${BW_SESSION:-}" ] || { echo "BW_SESSION is not set. Run: export BW_SESSION=\"\$(bw unlock --raw)\""; exit 1; }
bw sync >/dev/null
folder_id="$(bw list folders | python3 -c 'import json,sys; print(next((f["id"] for f in json.load(sys.stdin) if f["name"]=="env"),""))')"
if [ -z "$folder_id" ]; then
  folder_id="$(bw get template folder | python3 -c 'import json,sys; d=json.load(sys.stdin); d["name"]="env"; print(json.dumps(d))' | bw encode | bw create folder | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')"
  echo "created Bitwarden folder: env"
fi
while IFS= read -r name; do
  [ -n "$name" ] || continue
  value="$(security find-generic-password -a "$USER" -s "env:$name" -w)"
  existing="$(bw list items --search "env:$name" | python3 -c 'import json,sys; print(next((i["id"] for i in json.load(sys.stdin) if i["name"]=="env:'"$name"'"),""))')"
  if [ -n "$existing" ]; then
    bw get item "$existing" | python3 -c 'import json,sys,os; d=json.load(sys.stdin); d["login"]["password"]=os.environ["V"]; print(json.dumps(d))' V="$value" | bw encode | bw edit item "$existing" >/dev/null
    echo "updated  env:$name"
  else
    V="$value" FID="$folder_id" N="$name" python3 -c 'import json,os; print(json.dumps({"type":1,"name":"env:"+os.environ["N"],"folderId":os.environ["FID"],"notes":"shell environment variable "+os.environ["N"]+"; loaded by ~/.zsh_keychain_secrets via the macOS Keychain","login":{"username":os.environ["N"],"password":os.environ["V"]}}))' | bw encode | bw create item >/dev/null
    echo "created  env:$name"
  fi
done < "$LIST"
echo "done. On a new Mac, run bitwarden-to-keychain.sh to load them back into the Keychain."
