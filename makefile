CONF_DIR=/etc/NetworkManager/conf.d
CONFIG_FILE=00-no-rand-mac.conf
DEBUG_FILE=debug_output.txt

# replace with the name of NIC you want the logs for, defaults to first
# wifi NIC. you can find the name of the NICs in "nmcli device status"
# Examples:
# NIC=wlp3s0
# NIC=enp2s0
NIC=$(shell nmcli device status | awk '$$2 == "wifi" { print $$1; exit }')

# this will set how long the logs will go back
# yesterday = yesterday 00:00AM
# today 	= today 00:00AM
# "YYYY-MM-DD HH:MM:SS"
# Examples:
# LOG_STARTDATE="2024-09-15 13:23:00"
# LOG_STARTDATE=today
LOG_STARTDATE=yesterday


fix all install config:
	@ if ! [ -e /sbin/NetworkManager ]; then \
		echo "[ERROR] NetworkManager is not installed!"; \
		exit 1; fi

	sudo cp $(CONFIG_FILE) $(CONF_DIR)
	sudo systemctl restart NetworkManager


uninstall unfix remove:
	sudo rm -f $(CONF_DIR)/$(CONFIG_FILE)
	sudo systemctl restart NetworkManager


# will find all necessary configuration files and only print out the
# necessary parts 
show-config:
	@for file in \
		$$(find /etc/NetworkManager /usr/lib/NetworkManager -name "*.conf"); do \
			echo $$file; \
			awk '!/^#/ && NF' "$$file"; \
			echo; done


log:
# awk will remove unecessary parts of the logs
# sed will censor any IPv4 address
# if you remove any line, "\" should not be in the last line
	journalctl --unit NetworkManager.service \
		--since $(LOG_STARTDATE) \
		--no-hostname \
		--grep="\($(NIC)\)" | \
			awk '{printf "%s %s %s %s %s\t", $$1,$$2,$$3,$$5,$$7; for (i=8; i<=NF; i++) printf "%s ", $$i; printf "\n"}' | \
			sed -E 's/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/XXX.XXX.XXX.XXX/g' 


debug debug-file:
	{ \
	echo "===== CONFIG FILES ====="; make show-config --no-print-directory; \
	echo -e "\n"; \
	echo "=====     LOGS     ====="; make log --no-print-directory; \
	} > $(DEBUG_FILE)

clean:
	rm $(DEBUG_FILE)
