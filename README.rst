net-bm-lab
##########

Lab for developing openstack/networking-baremetal network device integration

The ansible playbooks in this lab will set up a virtual lab. An openstack node
(devstack) with Ironic services, a virtual switch (Cisco NXOS) and a Virtual
Baremetal node. The Openstack controller and the Virtual Baremetal has it's
network connectivity via the Virtual Switch to allow Neutron ML2 integration
development/testing.

Lab diagram::

  ┌─────────────────────────┐
  │ devstack VM             │
  │ Admin IP: 192.168.24.40 │
  │ Admin user: root        │
  │ Devstack user: stack    │
  └────┬────────────────────┘
       │eth1/1
  ┌────┴──────────────────────┐
  │ NXOS Switch               │
  │ User/Pass: admin/password │
  │ Admin IP: 192.168.24.21   │
  │ telnet 127.0.0.1 52099    │
  └────┬──────────────────────┘
       │eth1/3
  ┌────┴───────────────────┐
  │ nxos_bm0               │
  │ Virtual Baremetal Node │
  └────────────────────────┘

Dependencies
============

- Ubuntu (jammy) - KVM hypervisor node
- Git
- Ansible
- Ansible ``community.libvirt`` collection
- Ansible ``community.crypto`` collection
- Ansible ``ansible.posix`` collection

KVM hypervisor setup
====================

#. Create the user account and set up sudo on the lab hypervisor
   ::
     useradd -s /bin/bash -d /opt/stack -m stack
     echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
     su - stack
#. Install ansible
   ::
     sudo apt install ansible -y
     ansible-galaxy collection install community.libvirt
     ansible-galaxy collection install community.crypto
     ansible-galaxy collection install ansible.posix
     ansible-galaxy collection install openstack.cloud
#. Clone the git repository
   ::
     git clone https://github.com/hjensas/net-bm-lab.git
#. Get virtual switch images, see `Get virtual switch images`_
#. Run the playbook to set up the lab
   ::
     ansible-playbook -i net-bm-lab/inventory.yaml net-bm-lab/playbooks/lab.yaml


Get virtual switch images
=========================

Download Virtual switch image files and copy them to the
``net-bm-lab/virtual-switch-images/`` directory. See below for links to vendor
specific download pages.

For example::

  $ ls -l net-bm-lab/virtual-switch-images/
  total 2400128
  -rw-r--r--. 1 stack stack 1961689088 Jun  5 02:07 nexus9500v64.10.2.2.F.qcow2
  -rw-r--r--. 1 stack stack  496041984 Jun  5 02:07 vEOS64-lab-4.27.3F.vmdk

Cisco NXOS
----------

Download `Cisco Nexus 9000/3000 Virtual Switch for KVM
<https://software.cisco.com/download/home/286312239/type/282088129>`_.

.. NOTE:: Currently only nexus9500v64.10.2.3.F.qcow2 can be used. Using a
          different image will require changeing the ``nxos_image`` in
          inventory as well as the ``target_system_image`` in
          ``playbooks/roles/nxos/files/poap.script``.

Arista vEOS
-----------

Download `Virtual EOS vmdk image
<https://www.arista.com/en/support/software-download>`_.

.. NOTE:: The inventory expect vEOS64-lab-4.27.3F.vmdk, update the
          ``veos_image`` variable in inventory if using a different image.
