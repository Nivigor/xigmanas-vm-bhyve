#!/bin/sh
# filename:     vm-bhyve.sh
# author:       nivigor
# date:         2023-04-24
# date:         2023-04-29	Add UEFI support
# purpose:      Install vm-bhyve on XigmaNAS 13 (embedded version).
#
#----------------------- Set variables ------------------------------------------------------------------
DIR=`dirname $0`;
CA_ROOT_NSSFILE="ca_root_nss-*"
VMFILE="vm-bhyve-*"
EDK2FILE="edk2-bhyve-*"
#----------------------- Set Errors ---------------------------------------------------------------------
_msg() { case $@ in
  0) echo "The script will exit now."; exit 0 ;;
  1) echo "No route to server, or file do not exist on server"; _msg 0 ;;
  2) echo "Can't find ${FILE} on ${DIR}"; _msg 0 ;;
  3) echo "vm-bhyve installed and ready!)"; exit 0 ;;
  4) echo "Always run this script using the full path: /mnt/.../directory/vm-bhyve.sh"; _msg 0 ;;
esac ; exit 0; }
#----------------------- Check for full path ------------------------------------------------------------
if [ ! `echo $0 |cut -c1-5` = "/mnt/" ]; then _msg 4 ; fi
cd $DIR;
#----------------------- Download ca_root_nss if needed and install -------------------------------------
FILE=${CA_ROOT_NSSFILE}
if [ ! -e ${DIR}/${FILE} ]; then pkg fetch -y ca_root_nss;
  cp `find /var/cache/pkg/ -name ${FILE} -not -name "*~*"` ${DIR} || _msg 1; fi
if [ -f ${DIR}/${FILE} ]; then pkg add ${DIR}/${FILE} || _msg 2; rm /var/cache/pkg/*; fi
#----------------------- Download vm-bhyve if needed and install -------------------------------------
FILE=${VMFILE}
if [ ! -e ${DIR}/${FILE} ]; then pkg fetch -y vm-bhyve;
  cp `find /var/cache/pkg/ -name ${FILE} -not -name "*~*"` ${DIR} || _msg 1; fi
if [ -f ${DIR}/${FILE} ]; then pkg add ${DIR}/${FILE} || _msg 2; rm /var/cache/pkg/*; fi
#----------------------- Download and decompress edk2-bhyve files if needed --------------------------------
FILE=${EDK2FILE}
if [ ! -d ${DIR}/usr/local/share/edk2-bhyve ]; then
  if [ ! -e ${DIR}/${FILE} ]; then pkg fetch -y edk2-bhyve;
    cp `find /var/cache/pkg/ -name ${FILE} -not -name "*~*"` ${DIR} || _msg 1; fi
  if [ -f ${DIR}/${FILE} ]; then tar xzf ${DIR}/${FILE} || _msg 2};
    rm -R ${DIR}/usr/local/share/licenses; rm -R ${DIR}/usr/local/share/uefi-firmware;
    rm ${DIR}/+*; rm /var/cache/pkg/*; fi
  if [ ! -d ${DIR}/usr/local/share/edk2-bhyve ]; then _msg 4; fi
fi
#----------------------- Create symlinks ----------------------------------------------------------------
mkdir -p /usr/local/share/uefi-firmware;
for i in `ls $DIR/usr/local/share/edk2-bhyve/`
  do if [ ! -e /usr/local/share/uefi-firmware/${i} ]; then
    ln -s ${DIR}/usr/local/share/edk2-bhyve/$i /usr/local/share/uefi-firmware; fi; done
#----------------------- Start vm ------------------------------------------------------------------
service vm start
_msg 3 ; exit 0;
#----------------------- End of Script ------------------------------------------------------------------
# 1. Keep this script in its own directory.
# 2. chmod the script u+x,
# 3. Always run this script using the full path: /mnt/.../directory/vm-bhyve.sh
# 4. You can add this script to WebGUI: Advanced: Command Scripts as a PostInit command (see 3).
# 5. To run vm-bhyve from shell type 'vm'.
