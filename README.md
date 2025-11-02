# nix-config

Configuration for nixOS

### Create symbolic link

```shell
# Backup the original configuration
sudo mv /etc/nixos /etc/nixos.bak
sudo ln -s ~/nix-config /etc/nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```

### Generate proxmox vms
To generate proxmox vms that you can import as backups in proxmox, you need [nixos-generators](https://github.com/nix-community/nixos-generators)

```shell
# Create a termporary session with nixos-generators
nix develop nixpkgs#nixos-generators

# Create a vm 
nixos-generate -f proxmox  --flake .#<host name (ex. pve-nixos-net)>
```
Nixos-generator will creat a .vma.zst file in the store. Look at the logs for the location.
Now you can copy this file into proxmox using scp in the path `/var/lib/vz/dump` but make sure that the folder exists and is it the Path/Target of the proxmox datacenter/storage/local.

Now you can restore the vm by going into the proxmox UI in local/backups and selecting the uploaded file

### Deploy NixOs LXC on proxmox
check this [guide](https://nixos.wiki/wiki/Proxmox_Linux_Container) for more details.

##### Import LXC container image
1) Copy the link of the latest successful `nixos.ProxmoxLXC` job from https://hydra.nixos.org/project/nixos (latest full build)
2) in proxmox, under CT templates paste the link under `Download from URL`

##### Create container
```shell
ctid="2__"
ctname="<lxc-hostname>"
ctt=" /var/lib/vz/template/cache/vztmpl/<TEMPLATE_NAME.tar.xz>"
cts="local-lvm"

ipaddr="192.168.188.<ip from 30 to 100>/24"
gw="192.168.188.1"
dns="9.9.9.9"
domain="local"

pct create ${ctid} ${ctt} \
  --hostname=${ctname} \
  --ostype=nixos --unprivileged=0 --features nesting=1 \
  --net0 name=eth0,bridge=vmbr0,ip=${ipaddr},gw=${gw} \
  --nameserver=${dns} --searchdomain=${domain} \
  --arch=amd64 --swap=1024 --memory=2048 \
  --storage=${cts}
```

you can now start the container, increase disk size and remove root password

```shell
pct resize ${ctid} rootfs +2G
pct start ${ctid}
pct enter ${ctid}

source /etc/set-environment
passwd --delete root
```

### Update NIXOS configuration after deployment in proxmox
```shell
nixos-rebuild --flake .#flakeTarget --target-host user@remote-host --sudo --ask-sudo-password switch
```

## Theme

The theme should be `Monokay pro`

### Windows terminal

Add `"tabColor": "#D17E55"` in the NixOs profile<br>
Add `"tabColor": "#4176a2"` in the PowerShell profile

```json
{
  "name": "Monokai Pro",
  "black": "#403e41",
  "red": "#ff6188",
  "green": "#a9dc76",
  "yellow": "#ffd866",
  "blue": "#fc9867",
  "purple": "#ab9df2",
  "cyan": "#78dce8",
  "white": "#fcfcfa",
  "brightBlack": "#727072",
  "brightRed": "#ff6188",
  "brightGreen": "#a9dc76",
  "brightYellow": "#ffd866",
  "brightBlue": "#fc9867",
  "brightPurple": "#ab9df2",
  "brightCyan": "#78dce8",
  "brightWhite": "#fcfcfa",
  "background": "#403e41",
  "foreground": "#fcfcfa",
  "selectionBackground": "#fcfcfa",
  "cursorColor": "#fcfcfa"
}
```
