# xigmanas-vm-bhyve
 Setup vm-bhyve on XigmaNAS 13 (embedded version)
1. Create dataset (or directory) for VM's and script directory /mnt/.../directory.
2. Set in rc.conf vm_enable to YES, vm_dir to zfs:pool/dataset (or /path/to/dir).
3. Keep this script in its own directory.
4. chmod the script u+x.
5. Always run this script using the full path: /mnt/.../directory/vm-bhyve.sh
6. You can add this script to WebGUI: Advanced: Command Scripts as a PostInit command (see 5).
7. To run vm-bhyve from shell type 'vm'.

vm-bhyve requires system version 12.0.4+.
Option uefi_vars doesn't work in FreeBSD 13.1, version 13.2+ is required.
Script tested in XigmaNAS 13.1.0.5.9790 embedded version.
FreeBSD, Linux and Windows VM's is ok.
