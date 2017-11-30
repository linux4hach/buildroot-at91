################################################################################
#
# tar to archive target filesystem
#
################################################################################

TAR_OPTS := $(BR2_TARGET_ROOTFS_TAR_OPTIONS)

define ROOTFS_TAR_CMD
 tar -c$(TAR_OPTS)f $@ -C $(TARGET_DIR) . ; \
$(foreach ROOTFS_DIR, $(BR2_TARGET_ROOTFS_TAR_DIR), \
	tar -c$(TAR_OPTS)zf $(BINARIES_DIR)/$(subst /,_,$(call qstrip,$(ROOTFS_DIR))).tar.gz -C $(TARGET_DIR) ./$(call qstrip,$(ROOTFS_DIR)) ;)
endef

$(eval $(call ROOTFS_TARGET,tar))	

 
