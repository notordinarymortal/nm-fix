CONF_DIR=/etc/NetworkManager/conf.d
CONFIG_FILE=00-no-rand-mac.conf



fix all install config:
	@[ -e /sbin/NetworkManager ]
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
