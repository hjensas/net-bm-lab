#!/bin/bash

while (true); do
  # If the VM is not running, wait 10 seconds and restart it.
  if ! /usr/bin/virsh domcontrol cisco-nxosv; then
    echo 'nxos-vm-monitor.service - libvirt VM: nexus is not running, it will be started again in 10 seconds.'
    sleep 10
    /usr/bin/virsh start cisco-nxosv
    echo 'waiting for cisco-nxos to boot'
    while ! ping -c 1 -n -w 1 192.168.24.21 &> /dev/null
    do
      echo 'Waiting for cisco-nxos to boot ...'
      sleep 60
    done
    echo 'cisco-nxos is back online'
    sleep 30
    echo 'On cisco-nxos running command: install activate mtx-openconfig-all'
    sshpass -p password ssh -o StrictHostKeyChecking=no admin@192.168.24.21 "install activate mtx-openconfig-all"
  fi
  sleep 30
done
