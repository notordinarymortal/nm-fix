This is a fix for a NetworkManager randomizing mac addresses for NICs
which can cause connectivity problems.

## INSTALL

#### with cloning
    git clone https://github.com/notordinarymortal/nm-fix
    cd nm-fix
    make

#### without cloning
    sudo curl -s https://raw.githubusercontent.com/notordinarymortal/nm-fix/main/00-no-rand-mac.conf \
    -o /etc/NetworkManager/conf.d/00-no-rand-mac.conf
    sudo systemctl restart NetworkManager.service
<br>
copy, paste and execute either of the above.<br>
<br>
It should work immeadiatly, since NetworkManager will be restarted.<br>
If you want to be extra sure, you can either disconnect for a couple of
minutes or reboot your PC.

### remove fix
    make remove
## DEBUG
#### print everything needed into a file
	make debug
This will create the file `debug_output.txt`.
The file will be overwritten if it already exists. If you want to make
debug files for multiple interfaces then make a debug file, rename it
(preferably to the interface name), change the interface in the `makefile`
and repeat.
	
#### show all configuration files in terminal
	make show-config
Comments and blank lines will not be shown.
#### show logs in terminal
	make log
Have a look at the log, if the log contains the wrong interface, have a
look in the `makefile` and edit `NIC=[...]`. Everything else is explained
in comments.

The logs will go back until yesterday 00:00AM.<br>
Your device's hostname won't be shown.<br>
Only one interface will be included in the logs, defaults to "first" wifi
interface.<br>
Only necesarry parts of the log will be shown.<br>
Your assigned IPv4 addresses will be censored.<br>
If you want to change any of the above, look at the start and at the
target "log" in the `makefile`

## What will be changed
- wifi and ethernet NICs will use thier hardware MAC by default
- prevent wifi NICs to use a random MAC for scanning networks

## How the fix works

Wifi connections are renewed after ~5-10 minutes. The NIC might change
it's MAC address for this twice, once for scanning and once for
reconnecting. This causes connectivity problems on some networks.

`00-no-rand-mac.conf` has the needed settings to fix this. It needs to
be in the NetworkManager config directory, which defaults to
`/etc/NetworkManager/conf.d`. Without the NIC changing to a random MAC,
the problem goes away.

There is a chance that the settings are overwritten by other config
files for NetworkManager. To prevent this, don't remove `00-` from
the filename. This will ensure priority over other config files.
