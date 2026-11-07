#!/bin/zsh
# New machine: pull the env:* items from Bitwarden back into the macOS Keychain.
#   bw login && export BW_SESSION="$(bw unlock --raw)" && zsh ~/Ark/dotfiles/scripts/secrets/bitwarden-to-keychain.sh
set -eu
[ -n "${BW_SESSION:-}" ] || { echo "BW_SESSION is not set"; exit 1; }
bw sync >/dev/null
bw list items --search "env:" | python3 -c '
import json,sys,subprocess,os
for i in json.load(sys.stdin):
    n=i["name"]
    if not n.startswith("env:"): continue
    v=i["login"]["password"]
    subprocess.run(["security","add-generic-password","-U","-a",os.environ["USER"],"-s",n,"-l",n+" (shell secret)","-w",v],check=True)
    print("stored",n)
'
