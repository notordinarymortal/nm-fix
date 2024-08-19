This is a fix for a NetworkManager randomizing mac addresses for NICs
which can cause connectivity problems.

### How to install fix:

#### with cloning the git:
    git clone https://github.com/notordinarymortal/nm-fix
    cd nm-fix
    make

#### without cloning:
    sudo curl -s https://raw.githubusercontent.com/notordinarymortal/nm-fix/main/00-no-rand-mac.conf -o /etc/NetworkManager/conf.d/00-no-rand-mac.conf
    sudo systemctl restart NetworkManager

### How to remove fix:
    make remove

### What will be changed:
- wifi and ethernet NICs will use thier hardware MAC by default
- prevent wifi NICs to use a random MAC for scanning networks

### How the fix works:

Wifi connections are renewed after ~5-10 minutes. When the NIC changes
it's MAC address twice, for scanning and reconnecting. This causes
connectivity problems on some networks.

The config file has the needed settings to fix this. It needs to be in
the NetworkManager config directory, which defaults to
`/etc/NetworkManager/conf.d`.

There is a chance that the settings are overwritten by other config
files for NetworkManager. To prevent this, don't remove "00-" from
the beginning of the configuration file name. This will ensures
priority over other config files.
