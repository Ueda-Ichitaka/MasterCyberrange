# bwinfosec.mssql

This ansible role will install a SQL Server Developer Edition 2019 instance on supported Windows platforms. This role can be adjusted to install any supported SQL server installation.

This role also handles local firewall changes as required and demonstrates how to make configuration adjustments to the SQL instance.

Works on

- Windows Server 2019

## Requirements

Powershell 5.0 / WMF 5.1 should be installed on target host.

You can do this in two steps with:

```yaml
# The latest powershell gives us more flexiablity to use Windows DSC items
- name: Windows | Install Powershell 5.0
  chocolatey.chocolatey.win_chocolatey:
    name: "powershell"
  register: check_powershell5
  retries: 3
  delay: 10

# Powershell 5.0 requires a reboot, so lets get it done if it's needed.
- name: Windows | Reboot to complete Powershell 5.0 install
  win_reboot:
    # We will give windows a full hour to reboot.
    reboot_timeout: 3600
    post_reboot_delay: 60
  when: check_powershell5.changed
```

## Role Variables

N/A

## Dependencies

N/A

## Example Playbook

    - hosts: install_mssql
      roles:
         - { role: bwinfosec.mssql }

## Local Development

This role includes a Vagrantfile that will spin up a local Windows Server 2019 VM in Virtualbox.
After creating the VM it will automatically run our role.

### Development requirements

`pip3 install pywinrm`

#### Usage

- Run `vagrant up` to create a VM and run our playbook
- Run `vagrant provision` to reapply our playbook
- Run `vagrant destroy -f && vagrant up` to recreate the VM and run our playbook.
- Run `vagrant destroy` to remove the VM.
