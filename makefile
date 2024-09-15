CONF_DIR=/etc/NetworkManager/conf.d
CONFIG_FILE=00-no-rand-mac.conf
LOG_STARTDATE=yesterday
DEBUG_FILE=debug_output.txt

# replace with the name of NIC you want the logs for, defaults to first
# wifi NIC. you can find the name of the NICs in "nmcli device status"
NIC=$(shell nmcli device status | awk '$$2 == "wifi" { print $$1; exit }')



fix all install config:
	@ if ! [ -e /sbin/NetworkManager ]; then \
		echo "[ERROR] NetworkManager is not installed!"; \
		exit 1; fi

	sudo cp $(CONFIG_FILE) $(CONF_DIR)
	sudo systemctl restart NetworkManager


uninstall unfix clean remove:
	sudo rm -f $(CONF_DIR)/$(CONFIG_FILE)
	sudo systemctl restart NetworkManager


# will find all necessary configuration files and only print out 
# necessary parts 
show-config:
	@for file in $$(find /etc/NetworkManager /usr/lib/NetworkManager -name "*.conf"); do \
		echo $$file; \
		awk '!/^#/ && NF' "$$file"; \
		echo; \
		done


log:
	# the sed line will censor any IPv4 address
	# if you remove it, you'll also have to remove "\" from the line above
	journalctl --unit NetworkManager.service --since $(LOG_STARTDATE) --no-hostname --grep="($(NIC))" | \
		sed -E 's/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/XXX.XXX.XXX.XXX/g' 


debug-file:
	@echo "===== CONFIG FILES =====" >> $(DEBUG_FILE)
	make show-config --no-print-directory >> $(DEBUG_FILE)
	@echo "===== LOGS =====" >> $(DEBUG_FILE)
	make log --no-print-directory >> $(DEBUG_FILE)
