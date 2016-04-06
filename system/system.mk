TARGET_GENERIC_HOSTNAME=$(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
TARGET_GENERIC_ISSUE=$(call qstrip,$(BR2_TARGET_GENERIC_ISSUE))
TARGET_GENERIC_ROOT_PASSWD=$(call qstrip,$(BR2_TARGET_GENERIC_ROOT_PASSWD))
TARGET_GENERIC_ENGRADMIN_PASSWD=$(call qstrip,$(BR2_TARGET_GENERIC_ENGRADMIN_PASSWD))
TARGET_GENERIC_KEYXFER_PASSWD=$(call qstrip,$(BR2_TARGET_GENERIC_KEYXFER_PASSWD))
TARGET_GENERIC_NOBODY_PASSWD=$(call qstrip,$(BR2_TARGET_GENERIC_NOBODY_PASSWD))
TARGET_GENERIC_PASSWD_METHOD=$(call qstrip,$(BR2_TARGET_GENERIC_PASSWD_METHOD))
TARGET_GENERIC_GETTY_PORT=$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT))
TARGET_GENERIC_GETTY_BAUDRATE=$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE))
TARGET_GENERIC_GETTY_TERM=$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_TERM))
TARGET_GENERIC_GETTY_OPTIONS=$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_OPTIONS))

ROOTFS_OVERLAY_DIR=/opt/Projects/cm130/rootfs_overlay
ROOTFS_OVERLAY_ETC_DIR=$(ROOTFS_OVERLAY_DIR)/etc
SHADOW_FILE=$(ROOTFS_OVERLAY_ETC_DIR)/shadow
TARGET_ETC_DIR=$(TARGET_DIR)/etc
#SHADOW_FILE=$(TARGET_ETC_DIR)/shadow

target-generic-securetty:
	grep -q '^$(TARGET_GENERIC_GETTY_PORT)$$' $(TARGET_DIR)/etc/securetty || \
		echo '$(TARGET_GENERIC_GETTY_PORT)' >> $(TARGET_DIR)/etc/securetty

target-generic-hostname:
	mkdir -p $(TARGET_DIR)/etc
	echo "$(TARGET_GENERIC_HOSTNAME)" > $(TARGET_DIR)/etc/hostname
	$(SED) '$$a \127.0.1.1\t$(TARGET_GENERIC_HOSTNAME)' \
		-e '/^127.0.1.1/d' $(TARGET_DIR)/etc/hosts

target-generic-issue:
	mkdir -p $(TARGET_DIR)/etc
	echo "$(TARGET_GENERIC_ISSUE)" > $(TARGET_DIR)/etc/issue

target-root-passwd: host-mkpasswd
target-nobody-passwd: host-mkpasswd
target-engradmin-passwd: host-mkpasswd
target-keyxfer-passwd: host-mkpasswd

target-root-passwd:
ifneq ($(TARGET_GENERIC_ROOT_PASSWD),)
	TARGET_GENERIC_ROOT_PASSWD_HASH=$$($(MKPASSWD) -m "$(TARGET_GENERIC_PASSWD_METHOD)" "$(TARGET_GENERIC_ROOT_PASSWD)"); \
	$(SED) "s,^root:[^:]*:,root:$$TARGET_GENERIC_ROOT_PASSWD_HASH:," $(SHADOW_FILE)
else
	$(SED) "s,^root:[^:]*:,root:*:," $(SHADOW_FILE)
endif

target-keyxfer-passwd:
ifneq ($(TARGET_GENERIC_KEYXFER_PASSWD),)
	TARGET_GENERIC_KEYXFER_PASSWD_HASH=$$($(MKPASSWD) -m "$(TARGET_GENERIC_PASSWD_METHOD)" "$(TARGET_GENERIC_KEYXFER_PASSWD)"); \
	$(SED) "s,\(^keyxfer\):\([^:]*\):\([0-9]*\):,keyxfer:$$TARGET_GENERIC_KEYXFER_PASSWD_HASH:0:," $(SHADOW_FILE)
else
	$(SED) "s,\(^keyxfer\):\([^:]*\):\([0-9]*\):,keyxfer:*:0:," $(SHADOW_FILE)
endif

target-nobody-passwd:
ifneq ($(TARGET_GENERIC_NOBODY_PASSWD),)
	TARGET_GENERIC_NOBODY_PASSWD_HASH=$$($(MKPASSWD) -m "$(TARGET_GENERIC_PASSWD_METHOD)" "$(TARGET_GENERIC_NOBODY_PASSWD)"); \
	$(SED) "s,^nobody:[^:]:,nobody:$$TARGET_GENERIC_NOBODY_PASSWD_HASH:," $(SHADOW_FILE)
else
	$(SED) "s,\(^nobody\):\([^:]*\):,nobody:*:," $(SHADOW_FILE)
endif

target-engradmin-passwd:
ifneq ($(TARGET_GENERIC_ENGRADMIN_PASSWD),)
	TARGET_GENERIC_ENGRADMIN_PASSWD_HASH=$$($(MKPASSWD) -m "$(TARGET_GENERIC_PASSWD_METHOD)" "$(TARGET_GENERIC_ENGRADMIN_PASSWD)"); \
	$(SED) "s,\(^engr$$.admin\):\([^:]*\):,engr$$.admin:$$TARGET_GENERIC_ENGRADMIN_PASSWD_HASH:," $(SHADOW_FILE); \
	echo "engr$$.admin - NOT empty"
else
	$(SED) "s,\(^engr$$.admin\):\([^:]*\):,engr$$.admin:*:," $(SHADOW_FILE) ; \
	echo "engr$$.admin - empty"
endif

target-generic-getty-busybox:
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(TARGET_GENERIC_GETTY_PORT)::respawn:/sbin/getty -L $(TARGET_GENERIC_GETTY_OPTIONS) $(TARGET_GENERIC_GETTY_PORT) $(TARGET_GENERIC_GETTY_BAUDRATE) $(TARGET_GENERIC_GETTY_TERM) #~' \
		$(TARGET_DIR)/etc/inittab

# In sysvinit inittab, the "id" must not be longer than 4 bytes, so we
# skip the "tty" part and keep only the remaining.
target-generic-getty-sysvinit:
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(shell echo $(TARGET_GENERIC_GETTY_PORT) | tail -c+4)::respawn:/sbin/getty -L $(TARGET_GENERIC_GETTY_OPTIONS) $(TARGET_GENERIC_GETTY_PORT) $(TARGET_GENERIC_GETTY_BAUDRATE) $(TARGET_GENERIC_GETTY_TERM) #~' \
		$(TARGET_DIR)/etc/inittab

# Find commented line, if any, and remove leading '#'s
target-generic-do-remount-rw:
	$(SED) '/^#.*# REMOUNT_ROOTFS_RW$$/s~^#\+~~' $(TARGET_DIR)/etc/inittab

# Find uncommented line, if any, and add a leading '#'
target-generic-dont-remount-rw:
	$(SED) '/^[^#].*# REMOUNT_ROOTFS_RW$$/s~^~#~' $(TARGET_DIR)/etc/inittab

ifeq ($(BR2_TARGET_GENERIC_GETTY),y)
TARGETS += target-generic-securetty
endif

ifneq ($(TARGET_GENERIC_HOSTNAME),)
TARGETS += target-generic-hostname
endif

ifneq ($(TARGET_GENERIC_ISSUE),)
TARGETS += target-generic-issue
endif

ifeq ($(BR2_ROOTFS_SKELETON_DEFAULT),y)
TARGETS += target-root-passwd
TARGETS += target-nobody-passwd
TARGETS += target-engradmin-passwd
TARGETS += target-keyxfer-passwd

ifeq ($(BR2_TARGET_GENERIC_GETTY),y)
TARGETS += target-generic-getty-$(if $(BR2_PACKAGE_SYSVINIT),sysvinit,busybox)
endif

ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)
TARGETS += target-generic-do-remount-rw
else
TARGETS += target-generic-dont-remount-rw
endif
endif
