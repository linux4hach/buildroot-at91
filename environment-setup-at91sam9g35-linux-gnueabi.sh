PROPER_TRIPLE="arm-buildroot-linux-gnueabi-"
export BASE_PATH=/opt/HachDev/BuildSystems/cm130/buildroot-at91-crosscompile-root/output/host
export SDKTARGETSYSROOT=$BASE_PATH/usr/arm-buildroot-linux-gnueabi

export PATH=$BASE_PATH/usr/arm-buildroot-linux-gnueabi/bin:$BASE_PATH/usr/bin:$PATH
export CCACHE_PATH=$BASE_PATH/usr/arm-buildroot-linux-gnueabi/bin:$BASE_PATH/usr/bin:$CCACHE_PATH
export PKG_CONFIG_SYSROOT_DIR=$SDKTARGETSYSROOT
export PKG_CONFIG_PATH=$SDKTARGETSYSROOT/sysroot/usr/lib/pkgconfig
unset command_not_found_handle
export CC="${PROPER_TRIPLE}gcc"
export CXX="${PROPER_TRIPLE}g++"
export CPP="${PROPER_TRIPLE}gcc -E"
export AS="${PROPER_TRIPLE}as"
export LD="${PROPER_TRIPLE}ld"
export GDB="${PROPER_TRIPLE}gdb"
export STRIP="${PROPER_TRIPLE}strip"
export RANLIB="${PROPER_TRIPLE}ranlib"
export OBJCOPY="${PROPER_TRIPLE}objcopy"
export OBJDUMP="${PROPER_TRIPLE}objdump"
export AR="${PROPER_TRIPPLE}ar"
export NM="${PROPER_TRIPPLE}nm"
export M4="m4"
export QMAKE=qmake
export TARGET_PREFIX=${PROPER_TRIPLE}
export ARCH=arm
export CROSS_COMPILE=${PROPER_TRIPLE}

