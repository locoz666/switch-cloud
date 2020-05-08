#!/bin/sh
filename="gamepad-agent_Linux_armv6.zip"
latest_version=$(curl -s -I https://github.com/locoz666/gamepad-agent/releases/latest | grep "location: " | grep -o -E "v[0-9]+\.[0-9]+\.[0-9]+")
echo "$latest_version"
url="https://github.com/locoz666/gamepad-agent/releases/download/${latest_version}/${filename}"
wget "$url"
unzip "$filename"
chmod +x "$(pwd)/gamepad-agent"
echo "
server:
  listen: 9999
type: server
" >"$(pwd)/config.yaml"

old_script_path="$(pwd)/scripts/run.sh"
script_path="$(pwd)/run.sh"
mv "${old_script_path}" "${script_path}"
chmod +x ./run.sh
echo "#!/bin/sh -e" >/etc/rc.local
echo "cd $(pwd) && ./run.sh" >>/etc/rc.local
echo "exit 0" >>/etc/rc.local
sudo ./run.sh
