#!/bin/sh
# filename:     vm-bhyve.sh
# author:       nivigor
# date:         2023-04-24	Initial
# date:         2023-04-29	Add UEFI support
# date:         2023-05-22	Refactoring, add column
# date:         2023-11-30	FreeBSD bug workaround.
#               ZfS volume with volmode=dev may not appear in dev/zvol until reboot
# purpose:      Install vm-bhyve on XigmaNAS 13 (embedded version).
#
#----------------------- Set variables ------------------------------------------------------------------
DIR=`dirname $0`;
#----------------------- Set Errors ---------------------------------------------------------------------
_msg() { case $@ in
  0) echo "The script will exit now."; exit 0 ;;
  1) echo "No route to server, or file do not exist on server"; _msg 0 ;;
  2) echo "Can't find ${PKG}-*.pkg on ${DIR}/All"; _msg 0 ;;
  3) echo "vm-bhyve installed and ready!)"; exit 0 ;;
  4) echo "Always run this script using the full path: /mnt/.../directory/vm-bhyve.sh"; _msg 0 ;;
esac ; exit 0; }
#----------------------- Check for full path ------------------------------------------------------------
if [ ! `echo $0 |cut -c1-5` = "/mnt/" ]; then _msg 4 ; fi
cd $DIR;
#----------------------- Download ca_root_nss if needed and install -------------------------------------
PKG="ca_root_nss"
if [ ! -e ${DIR}/All/${PKG}-*.pkg ]; then pkg fetch -o ${DIR} -y ${PKG} || _msg 1; fi
if [ -f ${DIR}/All/${PKG}-*.pkg ]; then pkg add `ls ${DIR}/All/${PKG}-*.pkg` || _msg 2; fi
#----------------------- Download vm-bhyve if needed and install -----------------------------------------
PKG="vm-bhyve"
if [ ! -e ${DIR}/All/${PKG}-*.pkg ]; then pkg fetch -o ${DIR} -y ${PKG} || _msg 1; fi
if [ -f ${DIR}/All/${PKG}-*.pkg ]; then pkg add `ls ${DIR}/All/${PKG}-*.pkg` || _msg 2; fi
#----------------------- FreeBSD bug workaround ----------------------------------------------------------
PKG="/usr/local/lib/vm-bhyve/vm-zfs"
mv ${PKG} ${PKG}.bak
sed 's/volmode=dev/volmode=geom/' ${PKG}.bak > ${PKG}
#----------------------- Download and decompress edk2-bhyve files if needed ------------------------------
PKG="edk2-bhyve"
if [ ! -d ${DIR}/usr/local/share/edk2-bhyve ]; then
  if [ ! -e ${DIR}/All/${PKG}-*.pkg ]; then pkg fetch -o ${DIR} -y ${PKG} || _msg 1; fi
  if [ -f ${DIR}/All/${PKG}-*.pkg ]; then tar xzf ${DIR}/All/${PKG}-*.pkg || _msg 2;
    rm -R ${DIR}/usr/local/share/licenses; rm -R ${DIR}/usr/local/share/uefi-firmware;
    rm ${DIR}/+*; fi
  if [ ! -d ${DIR}/usr/local/share/edk2-bhyve ]; then _msg 4; fi
fi
#----------------------- Create column file if needed --------------------------------
if [ ! -f ${DIR}/column ]; then
  b64decode << EOF
begin-base64 555 column.lzma
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
eIXkXSD3xGS1DTJQZyLOKpfxnP6kiNs=
====
EOF
  unlzma column.lzma; chmod u+x column
  if [ ! -f ${DIR}/column ]; then _msg 4; fi
fi
#----------------------- Create symlinks ----------------------------------------------------------------
mkdir -p /usr/local/share/uefi-firmware;
for i in `ls $DIR/usr/local/share/edk2-bhyve/`
  do if [ ! -e /usr/local/share/uefi-firmware/${i} ]; then
    ln -s ${DIR}/usr/local/share/edk2-bhyve/$i /usr/local/share/uefi-firmware; fi; done
ln -s ${DIR}/column /usr/bin;
#----------------------- Start vm ------------------------------------------------------------------
service vm start
_msg 3 ; exit 0;
#----------------------- End of Script ------------------------------------------------------------------
# 1. Create dataset (or directory) for VM's and script directory /mnt/.../directory.
# 2. Set in rc.conf vm_enable to YES, vm_dir to zfs:pool/dataset (or /path/to/dir).
# 3. Keep this script in its own directory.
# 4. chmod the script u+x.
# 5. Always run this script using the full path: /mnt/.../directory/vm-bhyve.sh
# 6. You can add this script to WebGUI: Advanced: Command Scripts as a PostInit command (see 5).
# 7. To run vm-bhyve from shell type 'vm'.
