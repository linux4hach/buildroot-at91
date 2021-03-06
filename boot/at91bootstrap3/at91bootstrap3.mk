################################################################################
#
# at91bootstrap3
#
################################################################################

AT91BOOTSTRAP3_VERSION =at91bootstrap-3.x
# AT91BOOTSTRAP3_SITE = $(call github,linux4hach,at91bootstrap,$(AT91BOOTSTRAP3_VERSION))
AT91BOOTSTRAP3_SITE        = https://github.com/linux4hach/at91bootstrap.git
AT91BOOTSTRAP3_SITE_METHOD = git

AT91BOOTSTRAP3_INSTALL_IMAGES = YES
AT91BOOTSTRAP3_INSTALL_TARGET = NO

AT91BOOTSTRAP3_DEFCONFIG = \
	$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_DEFCONFIG))
AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE = \
	$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE))
AT91BOOTSTRAP3_CUSTOM_PATCH_DIR = \
	$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_PATCH_DIR))

AT91BOOTSTRAP3_ARCH=$(KERNEL_ARCH)
AT91BOOTSTRAP3_MAKE_OPT = CROSS_COMPILE=$(TARGET_CROSS) DESTDIR=$(BINARIES_DIR) \
	ARCH=$(AT91BOOTSTRAP3_ARCH)

ifneq ($(AT91BOOTSTRAP3_CUSTOM_PATCH_DIR),)
define AT91BOOTSTRAP3_APPLY_CUSTOM_PATCHES
	support/scripts/apply-patches.sh $(@D) $(AT91BOOTSTRAP3_CUSTOM_PATCH_DIR) \
		at91bootstrap3-\*.patch
endef

AT91BOOTSTRAP3_POST_PATCH_HOOKS += AT91BOOTSTRAP3_APPLY_CUSTOM_PATCHES
endif

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_DEFCONFIG),y)
AT91BOOTSTRAP3_SOURCE_CONFIG = \
	$(AT91BOOTSTRAP3_DEFCONFIG)_defconfig
else ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_CUSTOM_CONFIG),y)
AT91BOOTSTRAP3_SOURCE_CONFIG = $(AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE)
endif

define AT91BOOTSTRAP3_CONFIGURE_CMDS
	# cp $(AT91BOOTSTRAP3_SOURCE_CONFIG) $(@D)/.config
	# $(SED) 's/image.bin/uImage/' $(@D)/.config
	# $(MAKE) mrproper
	$(MAKE) -C $(@D) $(AT91BOOTSTRAP3_MAKE_OPT) $(AT91BOOTSTRAP3_SOURCE_CONFIG)
endef

define AT91BOOTSTRAP3_BUILD_CMDS
	# $(MAKE) mrproper
	# $(MAKE) -C $(@D) $(AT91BOOTSTRAP3_MAKE_OPT) $(AT91BOOTSTRAP3_SOURCE_CONFIG)
	$(MAKE) $(AT91BOOTSTRAP3_MAKE_OPT) -C $(@D) 
endef

define AT91BOOTSTRAP3_INSTALL_IMAGES_CMDS
	cp $(@D)/binaries/at91bootstrap.bin $(BINARIES_DIR)/bootstrap.bin
endef

$(eval $(generic-package))

# Checks to give errors that the user can understand
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_DEFCONFIG),y)
ifeq ($(AT91BOOTSTRAP3_DEFCONFIG),)
$(error No at91bootstrap3 defconfig name specified, check your BR2_TARGET_AT91BOOTSTRAP3_DEFCONFIG setting)
endif
endif

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_CUSTOM_CONFIG),y)
ifeq ($(AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE),)
$(error No at91bootstrap3 configuration file specified, check your BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE setting)
endif
endif
endif
